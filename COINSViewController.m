//
//  COINSViewController.m
//  FracCalc
//
//  Created by Yusuke Iwama on 9/14/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import "COINSViewController.h"
#import "COINSFraction.h"
#import "COINSFractionContext.h"

@interface COINSViewController ()

@end

@implementation COINSViewController {
	COINSFractionContext *context;
	NSMutableString *inputHistory;
	
	NSInteger firstFractionSign, secondFractionSign;
	NSUInteger firstFractionNumerator, firstFractionDenominator, secondFractionNumerator, secondFractionDenominator;
	unichar operator;
}

@synthesize keyboard;

@synthesize firstSignLabel, firstNumeratorLabel, firstVinculumView, firstDenominatorLabel, firstIntegerLabel;
@synthesize firstOperatorLabel;
@synthesize secondSignLabel, secondNumeratorLabel, secondVinculumView, secondDenominatorLabel, secondIntegerLabel;
@synthesize leftParenthesisLabel, rightParenthesisLabel;
@synthesize firstEqualLabel;
@synthesize thirdSignLabel, thirdNumeratorLabel, thirdVinculumView, thirdDenominatorLabel, thirdIntegerLabel;
@synthesize messageLabel;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setNeedsStatusBarAppearanceUpdate];
	
	inputHistory = [NSMutableString string];
	
	keyboard.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{ // update button alignment according to UIInterfaceOrientation
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait
		|| self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self didRotateFromInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
	} else {
		[self didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle{ // set status bar style to LightContent
    return UIStatusBarStyleLightContent;
}

#pragma mark COINSKeyboardDelegate

- (void)input:(unichar)c;
{ // parse inputString every time when c is input

	/* 
	 基本方針
	 マス目を順次埋めていく処理を時系列順に書いていく
	 */
	
	// 今回入力された文字を入力履歴に追加する
	[inputHistory appendFormat:@"%c", c];
	
	// 毎回再描画するため、前回のラベルや括線を消去する。
	firstSignLabel.text = @"";
	firstNumeratorLabel.text = @"";
	firstDenominatorLabel.text = @"";
	firstIntegerLabel.text = @"";
	
	firstOperatorLabel.text = @"";
	
	secondSignLabel.text = @"";
	secondNumeratorLabel.text = @"";
	secondDenominatorLabel.text = @"";
	secondIntegerLabel.text = @"";
	
	leftParenthesisLabel.hidden = YES;
	rightParenthesisLabel.hidden = YES;
	leftParenthesisLabel.transform = CGAffineTransformMakeScale(1.0, 2.0);
	rightParenthesisLabel.transform = CGAffineTransformMakeScale(1.0, 2.0);
	
	firstEqualLabel.text = @"";
	
	thirdSignLabel.text = @"";
	thirdNumeratorLabel.text = @"";
	thirdDenominatorLabel.text = @"";
	thirdIntegerLabel.text = @"";
	
	firstVinculumView.hidden = YES;
	secondVinculumView.hidden = YES;
	thirdVinculumView.hidden = YES;
	
	firstFractionSign = 0;
	firstFractionNumerator = 0;
	firstFractionDenominator = 0;
	secondFractionSign = 0;
	secondFractionNumerator = 0;
	secondFractionDenominator = 0;
	
	if (c == 'a') { // All Clear
        [inputHistory deleteCharactersInRange:NSMakeRange(0, inputHistory.length)];
	} else if (c == 'c') { // Clear
		if (inputHistory.length > 1) { // 自分自身と直前の一文字を削除する
			[inputHistory deleteCharactersInRange:NSMakeRange(inputHistory.length - 2, 2)];
		} else { // １文字も入力履歴がない場合は全消去する
			[inputHistory deleteCharactersInRange:NSMakeRange(0, inputHistory.length)];
		}
	}
	
	NSLog(@"inputHistory: %@", inputHistory);

	// Contextを取得
	context = [[COINSFractionContext alloc] init];
	
	for (NSUInteger i = 0; i < inputHistory.length; i++) {
		unichar ch = [inputHistory characterAtIndex:i];
		[context inputChar:ch];
		// 状態チェック
		NSLog(@"State: %@", [context.currentState class]);
		if ([context.currentState class] == [COINSFractionStateBadInput class]) {
			[inputHistory deleteCharactersInRange:NSMakeRange(inputHistory.length - 1, 1)];
		} else if ([context.currentState class] == [COINSFractionStateFirstSign class]) {
			if ([firstSignLabel.text isEqualToString:@""]) {
				firstSignLabel.text = @"-";
				firstFractionSign = -1;
			} else {
				firstSignLabel.text = @"";
				firstFractionSign = 1;
			}
		} else if ([context.currentState class] == [COINSFractionStateFirstNumber class]) {
			firstIntegerLabel.text = [NSString stringWithFormat:@"%@%c", firstIntegerLabel.text, ch];
			firstFractionNumerator = [firstIntegerLabel.text integerValue];
			firstFractionDenominator = 1;
			if (firstFractionSign == 0) {
				firstFractionSign = 1;
			}
		} else if ([context.currentState class] == [COINSFractionStateFirstVinculum class]) {
			firstDenominatorLabel.text = firstIntegerLabel.text;
			firstIntegerLabel.text = @"";
			firstVinculumView.hidden = NO;
			firstFractionDenominator = firstFractionNumerator;
		} else if ([context.currentState class] == [COINSFractionStateFirstNumerator class]) {
			firstNumeratorLabel.text = [NSString stringWithFormat:@"%@%c", firstNumeratorLabel.text, ch];
			firstFractionNumerator = [firstNumeratorLabel.text integerValue];
		} else if ([context.currentState class] == [COINSFractionStateFirstIntegerZero class]) {
			firstIntegerLabel.text = @"0";
			firstFractionNumerator = 0;
			firstFractionDenominator = 1;
		} else if ([context.currentState class] == [COINSFractionStateOperatorButDivision class]
				   || [context.currentState class] == [COINSFractionStateOperatorDivision class]) {
			firstOperatorLabel.text = [NSString stringWithFormat:@"%c", ch];
			if (ch == '*') {
				firstOperatorLabel.text = @"×";
			} else if (ch == '/') {
				firstOperatorLabel.text = @"÷";
			}
			operator = ch;
		} else if ([context.currentState class] == [COINSFractionStateSecondSign class]
				   || [context.currentState class] == [COINSFractionStateSecondSignDivision class]) {
			if ([secondSignLabel.text isEqualToString:@""]) {
				secondSignLabel.text = @"-";
				secondFractionSign = -1;
				leftParenthesisLabel.hidden = NO;
				rightParenthesisLabel.hidden = NO;
			} else {
				secondSignLabel.text = @"";
				secondFractionSign = 1;
				leftParenthesisLabel.hidden = YES;
				rightParenthesisLabel.hidden = YES;
			}
		} else if ([context.currentState class] == [COINSFractionStateSecondNumber class]) {
			secondIntegerLabel.text = [NSString stringWithFormat:@"%@%c", secondIntegerLabel.text, ch];
			secondFractionNumerator = [secondIntegerLabel.text integerValue];
			secondFractionDenominator = 1;
			if (secondFractionSign == 0) {
				secondFractionSign = 1;
			}
		} else if ([context.currentState class] == [COINSFractionStateSecondVinculum class]) {
			secondDenominatorLabel.text = secondIntegerLabel.text;
			secondIntegerLabel.text = @"";
			secondVinculumView.hidden = NO;
			secondFractionDenominator = secondFractionNumerator;
		} else if ([context.currentState class] == [COINSFractionStateSecondNumerator class]) {
			secondNumeratorLabel.text = [NSString stringWithFormat:@"%@%c", secondNumeratorLabel.text, ch];
			secondFractionNumerator = [secondNumeratorLabel.text integerValue];
		} else if ([context.currentState class] == [COINSFractionStateSecondIntegerZero class]) {
			secondIntegerLabel.text = @"0";
			secondFractionNumerator = 0;
			secondFractionDenominator = 1;
		} else if ([context.currentState class] == [COINSFractionStateEnd class]) {
			// Evaluate
			COINSFraction *firstFraction = [COINSFraction fractionWithSign:firstFractionSign
																 numerator:firstFractionNumerator
															   denominator:firstFractionDenominator];
			COINSFraction *secondFraction = [COINSFraction fractionWithSign:secondFractionSign
																  numerator:secondFractionNumerator
																denominator:secondFractionDenominator];
			COINSFraction *thirdFraction;
			switch (operator) {
				case '+':
					thirdFraction = [COINSFraction add:secondFraction to:firstFraction];
					break;
				case '-':
					thirdFraction = [COINSFraction subtract:secondFraction from:firstFraction];
					break;
				case '*':
					thirdFraction = [COINSFraction multiply:firstFraction by:secondFraction];
					break;
				case '/':
					thirdFraction = [COINSFraction divide:firstFraction by:secondFraction];
					break;
				default:
					NSLog(@"Evaluation failed");
					break;
			}
			NSLog(@"%@ %c %@ = %@", [firstFraction stringRepresentation], operator, [secondFraction stringRepresentation], [thirdFraction stringRepresentation]);
			firstEqualLabel.text = @"=";
			if (thirdFraction.sign == -1) {
				thirdSignLabel.text = @"-";
			}
			if (thirdFraction.denominator == 1) {
				thirdIntegerLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.numerator];
			} else {
				thirdNumeratorLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.numerator];
				thirdDenominatorLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.denominator];
				thirdVinculumView.hidden = NO;
			}
		}
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
		|| fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		NSArray *buttonTitles = @[@"AC",@"AC",	@"±",
								  @"C",	@"×",	@"÷",
								  @"C",	@"+",	@"-",
								  @"7",	@"8",	@"9",
								  @"4",	@"5",	@"6",
								  @"1",	@"2",	@"3",
								  @"0",	@"分の",	@"="];
		NSString *outCharacters = @"aasc*/c+-7894561230b=";
		[keyboard updateButtonsWithRow:7 column:3 titles:buttonTitles outCharacters:outCharacters style:COINSKeyboardStylePinkCircle];
		NSArray *mergeInfo = @[@[@0, @1], @[@3, @6]];
		[keyboard mergeButtons:mergeInfo];
	} else {
		NSArray *buttonTitles = @[@"AC",@"C",	@"±",	@"÷",
								  @"7",	@"8",	@"9",	@"×",
								  @"4",	@"5",	@"6",	@"-",
								  @"1",	@"2",	@"3",	@"+",
								  @"0",	@"分の",	@"分の",	@"="];
		NSString *outCharacters = @"acs/789*456-123+0bb=";
		[keyboard updateButtonsWithRow:5 column:4 titles:buttonTitles outCharacters:outCharacters style:COINSKeyboardStyleDefault];
		NSArray *mergeInfo = @[@[@17, @18]];
		[keyboard mergeButtons:mergeInfo];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end