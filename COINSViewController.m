//
//  COINSViewController.m
//  FracCalc
//
//  Created by Yusuke Iwama on 9/14/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import "COINSViewController.h"
#import "COINSFraction.h"

@interface COINSViewController ()

@end

@implementation COINSViewController {
	NSInteger turn;
	
	NSMutableString *inputString;
	NSMutableString *inString;
}

@synthesize keyboard;

@synthesize firstSignLabel, firstNumeratorLabel, firstVinculumView, firstDenominatorLabel, firstIntegerLabel;
@synthesize firstOperatorLabel;
@synthesize secondSignLabel, secondNumeratorLabel, secondVinculumView, secondDenominatorLabel, secondIntegerLabel;
@synthesize firstEqualLabel;
@synthesize thirdSignLabel, thirdNumeratorLabel, thirdVinculumView, thirdDenominatorLabel, thirdIntegerLabel;
@synthesize messageLabel;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setNeedsStatusBarAppearanceUpdate];
	
    turn = 0;
	
	inputString = [NSMutableString string];
    inString = [NSMutableString string];
	
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
{
    COINSFraction *thirdFraction;
    messageLabel.text = @"";
    NSRange wholeRange;
	
    [inputString appendFormat:@"%c",c];
	NSLog(@"inputString:%@", inputString);
    wholeRange = NSMakeRange(0, inputString.length);
	
    
	// AllClear, Clear
    if (c == 'a') {
        [inputString deleteCharactersInRange:wholeRange];
    } else if (c == 'c') {
        NSRange clearRange = NSMakeRange(inputString.length - 2, 2);
        [inputString deleteCharactersInRange:clearRange];
    }
    
	// 最終計算
    if (c == '=' && turn == 3) {
        
		// 左、演算子、右の分割
        NSMutableString *firstFractionString;
        NSMutableString *secondFractionString;
        NSArray *components = [inputString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-*/"]];
		firstFractionString = components[0];
		secondFractionString = components[1];
        
		
        
		// 演算子の識別
		char op;
        NSRange operatorRange = [inputString rangeOfString:@"+"];
        if (operatorRange.length == 1) {
            op = '+';
        }
        operatorRange = [inputString rangeOfString:@"-"];
        if (operatorRange.length == 1) {
			op = '-';
        }
        operatorRange = [inputString rangeOfString:@"*"];
        if (operatorRange.length == 1) {
            op = '*';
        }
        operatorRange = [inputString rangeOfString:@"/"];
        if (operatorRange.length == 1) {
			op = '/';
        }
        
        
		// Stringから分数を作成(帯分数とそれ以外を場合分け)
        COINSFraction *firstFraction;
        COINSFraction *secondFraction;
		
        NSRange s = [firstFractionString rangeOfString:@"m"];
        if (s.location == NSNotFound) {
            firstFraction = [COINSFraction fractionWithString:firstFractionString];
        } else {
            firstFraction = [COINSFraction MixedfractionWithString:firstFractionString];
        }
		
        s = [secondFractionString rangeOfString:@"m"];
        if (s.location == NSNotFound) {
            secondFraction = [COINSFraction fractionWithString:secondFractionString];
        } else {
            secondFraction = [COINSFraction MixedfractionWithString:secondFractionString];
        }
        
        
		// 計算(演算子によって場合分け)
        switch (op) {
            case '+':
                thirdFraction = [COINSFraction add:firstFraction to:secondFraction];
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
				NSLog(@"Unknown operator!");
                break;
		}
        
//		wholeRange = NSMakeRange(0, inputString.length);
//        [inputString replaceCharactersInRange:wholeRange withString:thirdFraction.stringRepresentation];
        
		// 計算結果の表示(整数値かどうかによって場合分け)
		if (thirdFraction.denominator == 1) { // thirdFraction is an integer
			thirdIntegerLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.numerator];
		} else {
			thirdNumeratorLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.numerator];
			thirdDenominatorLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.denominator];
			thirdVinculumView.hidden = NO;
		}
		if (thirdFraction.sign == -1) {
			thirdSignLabel.text = @"-";
		}
	}
	
    
	// 計算過程の表示
    [inString appendFormat:@"%c",c];
    
    NSCharacterSet *operators = [NSCharacterSet characterSetWithCharactersInString:@"+-*/b=()"];
    NSRange operatorRange = [inString rangeOfCharacterFromSet:operators];
    NSRange inStringRange = NSMakeRange(0, inString.length);
    
	//AllClear
    if (c == 'a') {
        [inString replaceCharactersInRange:inStringRange withString:@""];
		firstSignLabel.text = @"";
        firstNumeratorLabel.text = @"";
		firstDenominatorLabel.text = @"";
		firstIntegerLabel.text = @"";
        
		firstOperatorLabel.text = @"";
        
		secondSignLabel.text = @"";
		secondNumeratorLabel.text = @"";
		secondDenominatorLabel.text = @"";
		secondIntegerLabel.text = @"";
		
        firstEqualLabel.text = @"";
		
		thirdSignLabel.text = @"";
        thirdNumeratorLabel.text = @"";
        thirdDenominatorLabel.text = @"";
        thirdIntegerLabel.text = @"";
		
		firstVinculumView.hidden = YES;
		secondVinculumView.hidden = YES;
		thirdVinculumView.hidden = YES;

        turn = 0;
    } else if (turn == 0 && operatorRange.location == NSNotFound) {   //左分母
        firstDenominatorLabel.text = inString;
        
    } else if (c == 'b' && turn == 0 && inStringRange.length > 1) {   //左括線
        firstVinculumView.hidden = NO;
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
        
    } else if (turn == 1 && operatorRange.location == NSNotFound) {   //左分子
        firstNumeratorLabel.text = inString;
        
    } else if (c == '+' && turn == 1 && inStringRange.length > 1) {   //演算子
        firstOperatorLabel.text = @"+";
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
    } else if (c == '-' && turn == 1 && inStringRange.length > 1) {
        firstOperatorLabel.text = @"-";
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
    } else if (c == '*' && turn == 1 && inStringRange.length > 1) {
        firstOperatorLabel.text = @"×";
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
    } else if (c == '/' && turn == 1 && inStringRange.length > 1) {
        firstOperatorLabel.text = @"÷";
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
        
    } else if (turn == 2 && operatorRange.location == NSNotFound) {   //右分母
        secondDenominatorLabel.text = inString;
        
    } else if (c == 'b' && turn == 2) {   //右括線
        secondVinculumView.hidden = NO;
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
        
    } else if (turn == 3 && operatorRange.location == NSNotFound) {   //右分子
        secondNumeratorLabel.text = inString;
        
    } else if (c == '=' && turn == 3) {   //イコール
        firstEqualLabel.text = @"=";
        
    } else if (c == '(' && turn == 3) {
        firstEqualLabel.text = @"=";
        turn++;
    } else {   //その他
        messageLabel.text = @"入力ミスです";
    }
	
    NSLog(@"inputString: %@", inputString);
    NSLog(@"inString: %@", inString);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
		|| fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		NSArray *buttonTitles = @[@"仮・帯", @"仮・帯",	@"±",
								  @"(",	@")",	@"±",
								  @"AC",@"×",	@"÷",
								  @"C",	@"+",	@"-",
								  @"7",	@"8",	@"9",
								  @"4",	@"5",	@"6",
								  @"1",	@"2",	@"3",
								  @"0",	@"分の",	@"="];
		NSString *outCharacters = @"mms()sa*/c+-7894561230b=";
		[keyboard updateButtonsWithRow:8 column:3 titles:buttonTitles outCharacters:outCharacters];
		NSArray *mergeInfo = @[@[@0, @1], @[@2, @5]];
		[keyboard mergeButtons:mergeInfo];
	} else {
		NSArray *buttonTitles = @[@"AC", @"(",	@")",	@"±",
								  @"C",	@"仮・帯",	@"仮・帯",	@"÷",
								  @"7",	@"8",	@"9",	@"×",
								  @"4",	@"5",	@"6",	@"-",
								  @"1",	@"2",	@"3",	@"+",
								  @"0",	@"分の",	@"分の",	@"="];
		NSString *outCharacters = @"a()scmm/789*456-123+0bb=";
		[keyboard updateButtonsWithRow:6 column:4 titles:buttonTitles outCharacters:outCharacters];
		NSArray *mergeInfo = @[@[@5, @6],@[@21, @22]];
		[keyboard mergeButtons:mergeInfo];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end