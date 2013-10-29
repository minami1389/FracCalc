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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark COINSKeyboardDelegate

- (void)input:(unichar)c;
{
    COINSFraction *z;
    messageLabel.text = @"";
    NSRange allclear;

    [inputString appendFormat:@"%c",c];
    allclear = NSMakeRange(0, inputString.length);
        
    
// AllClear,Clear
    if (c == 'a') {
        [inputString replaceCharactersInRange:allclear withString:@""];
    } else if (c == 'c') {
        NSRange c = NSMakeRange(inputString.length-2, 2);
        [inputString replaceCharactersInRange:c withString:@""];
    }
    
    
// 最終計算
    if (c == '=' && turn == 3) {
        
// 左、演算子、右の分割
        NSMutableString *left;
        NSMutableString *right;
        NSArray *com = [inputString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-*/"]];
                left = com[0];
                right = com[1];
        
       
        
// 演算子の識別
        NSInteger number;
        NSRange symbol = [inputString rangeOfString:@"+"];
        if (symbol.length == 1) {
            number = 1;
        }
        symbol = [inputString rangeOfString:@"-"];
        if (symbol.length == 1) {
            number = 2;
        }
        symbol = [inputString rangeOfString:@"*"];
        if (symbol.length == 1) {
            number = 3;
        }
        symbol = [inputString rangeOfString:@"/"];
        if (symbol.length == 1) {
            number = 4;
        }
        
        
// Stringから分数を作成(帯分数とそれ以外を場合分け)
        COINSFraction *l;
        COINSFraction *r;
            
        NSRange s = [left rangeOfString:@"m"];
        if (s.location == NSNotFound) {
            l = [COINSFraction fractionWithString:left];
        } else {
            l = [COINSFraction MixedfractionWithString:left];
        }
            
        s = [right rangeOfString:@"m"];
        if (s.location == NSNotFound) {
            r = [COINSFraction fractionWithString:right];
        } else {
            r = [COINSFraction MixedfractionWithString:right];
        }
        
        
// 計算(演算子によって場合分け)
        switch (number) {
            case 1:
                z = [COINSFraction add:l to:r];
                break;
                
            case 2:
                z = [COINSFraction subtract:r from:l];
                break;
                    
            case 3:
                z = [COINSFraction multiply:l by:r];
                break;
                
            case 4:
                z = [COINSFraction divide:l by:r];
                break;
                
            default:
                break;
            }
        
        NSRange range = NSMakeRange(0, inputString.length);
        [inputString replaceCharactersInRange:range withString:z.stringRepresentation];
        
        
// 計算結果の表示(整数値かどうかによって場合分け)
        NSRange slash = [inputString rangeOfString:@"b"];
        if (slash.location == NSNotFound) {
            thirdIntegerLabel.text = inputString;
        } else {
            NSArray *answer = [inputString componentsSeparatedByString:@"b"];
            NSString *n = answer[0];
            NSString *d = answer[1];
            thirdNumeratorLabel.text = n;
            thirdDenominatorLabel.text = d;
            thirdVinculumView.hidden = NO;
            }
        }

    
// 計算過程の表示
    [inString appendFormat:@"%c",c];
    
    NSCharacterSet *signalset = [NSCharacterSet characterSetWithCharactersInString:@"+-*/b=()"];
    NSRange signal = [inString rangeOfCharacterFromSet:signalset];
    NSRange inStringRange = NSMakeRange(0, inString.length);
    
//AllClear
    if (c == 'a') {
        [inString replaceCharactersInRange:inStringRange withString:@""];
        firstNumeratorLabel.text = @"";
        firstOperatorLabel.text = @"";
        secondNumeratorLabel.text = @"";
        firstEqualLabel.text = @"";
        thirdNumeratorLabel.text = @"";
        firstDenominatorLabel.text = @"";
        secondDenominatorLabel.text = @"";
        thirdDenominatorLabel.text = @"";
        thirdIntegerLabel.text = @"";
		firstVinculumView.hidden = YES;
		secondVinculumView.hidden = YES;
		thirdVinculumView.hidden = YES;
        turn = 0;
    } else if (turn == 0 && signal.location == NSNotFound) {   //左分母
        firstDenominatorLabel.text = inString;
        
    } else if (c == 'b' && turn == 0 && inStringRange.length > 1) {   //左括線
        firstVinculumView.hidden = NO;
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
        
    } else if (turn == 1 && signal.location == NSNotFound) {   //左分子
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
        
    } else if (turn == 2 && signal.location == NSNotFound) {   //右分母
        secondDenominatorLabel.text = inString;
        
    } else if (c == 'b' && turn == 2) {   //右括線
        secondVinculumView.hidden = NO;
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
        
    } else if (turn == 3 && signal.location == NSNotFound) {   //右分子
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