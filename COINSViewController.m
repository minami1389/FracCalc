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
	
	NSMutableString *inputHistory;
	NSMutableString *inString;
    NSMutableString *check;

    
	CGSize appSize;
    
    UILabel *label;
    

    
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
    turn = 0;
    [super viewDidLoad];
	inputString = [NSMutableString string];
    
    inString = [NSMutableString string];
    check = [NSMutableString string];
    lde = [NSMutableString string];
    lnu = [NSMutableString string];
    rde = [NSMutableString string];
    rnu = [NSMutableString string];

    
	appSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width,
						 [UIScreen mainScreen].applicationFrame.size.height);
	
	COINSFraction *x = [COINSFraction fractionWithString:@"-1/7"];
	COINSFraction *y = [COINSFraction fractionWith:1 numerator:1 denominator:7];

	NSLog(@"%@ + %@ = %@", x.stringRepresentation, y.stringRepresentation, [x add:y].stringRepresentation);
	NSLog(@"%@ - %@ = %@", x.stringRepresentation, y.stringRepresentation, [x sub:y].stringRepresentation);
	NSLog(@"%@ * %@ = %@", x.stringRepresentation, y.stringRepresentation, [x mul:y].stringRepresentation);
	NSLog(@"%@ / %@ = %@", x.stringRepresentation, y.stringRepresentation, [x div:y].stringRepresentation);
	
	NSLog(@"%@ + %@ / %@ = %@", x.stringRepresentation, x.stringRepresentation, y.stringRepresentation, [x add:[x div:y]].stringRepresentation);
	
	NSArray *buttonTitles = @[@"AC", @"AC",	@"C",	@"÷",
						   @"7",	@"8",	@"9",	@"×",
						   @"4",	@"5",	@"6",	@"-",
						   @"1",	@"2",	@"3",	@"+",
						   @"0",	@"=",	@"=",	@"=",
						   @"分の",	@"分の",	@"分の",	@"分の"];
	NSString *outCharacters = @"aac/789*456-123+0===bbbb";
	COINSKeyboard *keyboard = [COINSKeyboard keyboardWithDelegate:self Frame:CGRectMake(600, 45, 400, 700) row:6 column:4 titles:buttonTitles outCharacters:outCharacters];
	NSArray *mergeInfo = @[@[@0, @1], @[@17, @18, @19], @[@20, @21, @22, @23]];
	[keyboard mergeButtons:mergeInfo];
	[self.view addSubview:keyboard];
	
    turn = 0;
	
	inputHistory = [NSMutableString string];
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
    if (turn == 4 && c != 'a') {
        label.text = @"ACを押してね";
    } else {
    
    label.text = @"";
    COINSFraction *z;
   
    [inputString appendFormat:@"%c",c];
    [inString appendFormat:@"%c",c];
    [check appendFormat:@"%c", c];
    NSRange allclear = NSMakeRange(0, inputString.length);
    
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
            center3.text = inputString;
            ain = inputString;
        } else {
            NSArray *answer = [inputString componentsSeparatedByString:@"b"];
            NSString *n = answer[0];
            NSString *d = answer[1];
            ae.text = n;
            be.text = d;
            c3.backgroundColor = [UIColor blackColor];
        }
    }

    
// 計算過程の表示
    
    NSCharacterSet *signalset = [NSCharacterSet characterSetWithCharactersInString:@"+-*/b="];
    NSRange signal = [inString rangeOfCharacterFromSet:signalset];
    NSRange inStringRange = NSMakeRange(0, inString.length);
    
//AllClear
    if (c == 'a') {
    
        [inputString replaceCharactersInRange:allclear withString:@""];
        [inString replaceCharactersInRange:inStringRange withString:@""];
        aa.text = @"";
        ab.text = @"";
        ac.text = @"";
        ad.text = @"";
        ae.text = @"";
        ba.text = @"";
        bc.text = @"";
        be.text = @"";
        center3.text = @"";
        c1.backgroundColor = [UIColor whiteColor];
        c2.backgroundColor = [UIColor whiteColor];
        c3.backgroundColor = [UIColor whiteColor];
        turn = 0;
        [lde deleteCharactersInRange:NSMakeRange(0, lde.length)];
        [lnu deleteCharactersInRange:NSMakeRange(0, lde.length)];
        [rde deleteCharactersInRange:NSMakeRange(0, lde.length)];
        [rnu deleteCharactersInRange:NSMakeRange(0, lde.length)];
    
    } else if (c == 'c') {
        
        if (inputString.length > 1) {
            
            NSRange c = NSMakeRange(inputString.length-2, 2);
            [inputString replaceCharactersInRange:c withString:@""];

            if (turn == 0 && inString.length > 1) {
                [inString deleteCharactersInRange:NSMakeRange(inString.length-2, 2)];
                ba.text = inString;
            } else if (turn ==  1 && inString.length == 1) {
                c1.backgroundColor = [UIColor whiteColor];
                [inString deleteCharactersInRange:NSMakeRange(0, 1)];
                turn--;
                [inString appendString:lde];
                NSRange ldeRan = NSMakeRange(0, lde.length);
                [lde deleteCharactersInRange:ldeRan];
            } else if (turn == 1 && inString.length > 1) {
                [inString deleteCharactersInRange:NSMakeRange(inString.length-2, 2)];
                aa.text = inString;
            } else if (turn == 2 && inString.length == 1) {
                ab.text = @"";
                [inString deleteCharactersInRange:NSMakeRange(0, 1)];
                turn--;
                [inString appendString:lnu];
                NSRange lnuRan = NSMakeRange(0, lnu.length);
                [lnu deleteCharactersInRange:lnuRan];
            } else if (turn == 2 && inString.length > 1) {
                [inString deleteCharactersInRange:NSMakeRange(inString.length-2, 2)];
                bc.text = inString;
            } else if (turn == 3 && inString.length == 1) {
                c2.backgroundColor = [UIColor whiteColor];
                [inString deleteCharactersInRange:NSMakeRange(0, 1)];
                turn--;
                [inString appendString:rde];
                NSRange rdeRan = NSMakeRange(0, rde.length);
                [rde deleteCharactersInRange:rdeRan];
        
            } else if (turn == 3 && inString.length > 1) {
                [inString deleteCharactersInRange:NSMakeRange(inString.length-2, 2)];
                ac.text = inString;
            }
            
        } else {
            label.text = @"未入力";
        }
        
        
    } else if (turn == 0 && signal.location == NSNotFound && c != '0') {   //左分母
        ba.text = inString;
        
    } else if (c == 'b' && turn == 0 && inputString.length > 1) {   //左括線
        c1.backgroundColor = [UIColor blackColor];
        [inString deleteCharactersInRange:NSMakeRange(inString.length-1, 1)];
        [lde appendString:inString];
        NSRange inStRan = NSMakeRange(0, inString.length);
        [inString replaceCharactersInRange:inStRan withString:@""];
        turn++;
        
    } else if (turn == 1 && signal.location == NSNotFound) {   //左分子
        aa.text = inString;
        
    } else if (c == '+' && turn == 1 && inStringRange.length > 1) {   //演算子
        ab.text = @"+";
        [inString deleteCharactersInRange:NSMakeRange(inString.length-1, 1)];
        [lnu appendString:inString];
        inStringRange = NSMakeRange(0, inString.length);
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
    } else if (c == '-' && turn == 1 && inStringRange.length > 1) {
        ab.text = @"-";
        [inString deleteCharactersInRange:NSMakeRange(inString.length-1, 1)];
        [lnu appendString:inString];
        inStringRange = NSMakeRange(0, inString.length);
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
    } else if (c == '*' && turn == 1 && inStringRange.length > 1) {
        ab.text = @"×";
        [inString deleteCharactersInRange:NSMakeRange(inString.length-1, 1)];
        [lnu appendString:inString];
        inStringRange = NSMakeRange(0, inString.length);
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
    } else if (c == '/' && turn == 1 && inStringRange.length > 1) {
        ab.text = @"÷";
        [inString deleteCharactersInRange:NSMakeRange(inString.length-1, 1)];
        [lnu appendString:inString];
        inStringRange = NSMakeRange(0, inString.length);
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
        
    } else if (turn == 2 && signal.location == NSNotFound && c != '0') {   //右分母
        bc.text = inString;
        
    } else if (c == 'b' && turn == 2) {   //右括線
        c2.backgroundColor = [UIColor blackColor];
        [inString deleteCharactersInRange:NSMakeRange(inString.length-1, 1)];
        [rde appendString:inString];
        inStringRange = NSMakeRange(0, inString.length);
        [inString replaceCharactersInRange:inStringRange withString:@""];
        turn++;
        
    } else if (turn == 3 && signal.location == NSNotFound) {   //右分子
        ac.text = inString;
        
    } else if (c == '=' && turn == 3) {   //イコール
        ad.text = @"=";
        [inString deleteCharactersInRange:NSMakeRange(inString.length-1, 1)];
        lnu = inString;
        turn++;
        
    }else {   //その他
        label.text = @"入力ミスです";
        NSRange inputStRange = NSMakeRange(inputString.length-1, 1);
        NSRange inStRange = NSMakeRange(inString.length-1, 1);
        [inputString deleteCharactersInRange:inputStRange];
        [inString deleteCharactersInRange:inStRange];
    }
    }

    NSLog(@"inputString: %@", inputString);
    NSLog(@"inString: %@", inString);
    NSLog(@"check: %@", check);
    NSLog(@"turn: %d", turn);
    NSLog(@"lde: %@",lde);
    NSLog(@"lnu: %@",lnu);
    NSLog(@"rde: %@",rde);
    NSLog(@"rnu: %@",rnu);



	// １番目の数の符号を取得する
	// 先頭から読んでいって、符号以外の文字が来るまで文字を取得し続ける
	NSUInteger targetIndex;
	char signChar;
	for (targetIndex = 0; targetIndex < inputHistory.length; targetIndex++) {
		signChar = [inputHistory characterAtIndex:targetIndex];
		if (signChar != 's') {
			break;
		}
	} // この時点で、targetIndexには's'の個数が格納されている
	
	// 符号文字が奇数個あったら負とする
	if (targetIndex % 2) {
		firstSignLabel.text = @"-";
	} else {
		firstSignLabel.text = @"";
	}
	if (targetIndex >= inputHistory.length) {
		return;
	}
	
	// １番目の数の分数を取得する
	NSError *error = NULL;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[1-9]+[0-9]*(b*[0-9]+)?"
																		   options:NSRegularExpressionCaseInsensitive error:&error];
	NSRange rangeOfFirstFraction = [regex rangeOfFirstMatchInString:inputHistory options:0 range:NSMakeRange(0, inputHistory.length)];
	if (rangeOfFirstFraction.location == NSNotFound) {
		return;
	}
	NSString *firstFractionString = [inputHistory substringWithRange:rangeOfFirstFraction];
	NSArray *firstFractionComponents = [firstFractionString componentsSeparatedByString:@"b"];
	if (firstFractionComponents.count == 1) {
		firstIntegerLabel.text = firstFractionComponents[0];
	} else if (firstFractionComponents.count == 2) {
		firstDenominatorLabel.text = firstFractionComponents[0];
		firstNumeratorLabel.text = firstFractionComponents[1];
		firstVinculumView.hidden = NO;
	}
	
	
	
//    COINSFraction *thirdFraction;
//    messageLabel.text = @"";
//    NSRange wholeRange;
//	
//    [inputHistory appendFormat:@"%c",c];
//	NSLog(@"inputString:%@", inputHistory);
//    wholeRange = NSMakeRange(0, inputHistory.length);
//	
//    
//	// AllClear, Clear
//    if (c == 'a') {
//        [inputHistory deleteCharactersInRange:wholeRange];
//    } else if (c == 'c') {
//        NSRange clearRange = NSMakeRange(inputHistory.length - 2, 2);
//        [inputHistory deleteCharactersInRange:clearRange];
//    }
//    
//	// 最終計算
//    if (c == '=' && turn == 3) {
//        
//		// 左、演算子、右の分割
//        NSMutableString *firstFractionString;
//        NSMutableString *secondFractionString;
//        NSArray *components = [inputHistory componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-*/"]];
//		firstFractionString = components[0];
//		secondFractionString = components[1];
//        
//		
//        
//		// 演算子の識別
//		char op;
//        NSRange operatorRange = [inputHistory rangeOfString:@"+"];
//        if (operatorRange.length == 1) {
//            op = '+';
//        }
//        operatorRange = [inputHistory rangeOfString:@"-"];
//        if (operatorRange.length == 1) {
//			op = '-';
//        }
//        operatorRange = [inputHistory rangeOfString:@"*"];
//        if (operatorRange.length == 1) {
//            op = '*';
//        }
//        operatorRange = [inputHistory rangeOfString:@"/"];
//        if (operatorRange.length == 1) {
//			op = '/';
//        }
//        
//        
//		// Stringから分数を作成(帯分数とそれ以外を場合分け)
//        COINSFraction *firstFraction;
//        COINSFraction *secondFraction;
//		
//        NSRange s = [firstFractionString rangeOfString:@"m"];
//        if (s.location == NSNotFound) {
//            firstFraction = [COINSFraction fractionWithString:firstFractionString];
//        } else {
//            firstFraction = [COINSFraction MixedfractionWithString:firstFractionString];
//        }
//		
//        s = [secondFractionString rangeOfString:@"m"];
//        if (s.location == NSNotFound) {
//            secondFraction = [COINSFraction fractionWithString:secondFractionString];
//        } else {
//            secondFraction = [COINSFraction MixedfractionWithString:secondFractionString];
//        }
//        
//        
//		// 計算(演算子によって場合分け)
//        switch (op) {
//            case '+':
//                thirdFraction = [COINSFraction add:firstFraction to:secondFraction];
//                break;
//            case '-':
//                thirdFraction = [COINSFraction subtract:secondFraction from:firstFraction];
//                break;
//            case '*':
//                thirdFraction = [COINSFraction multiply:firstFraction by:secondFraction];
//                break;
//            case '/':
//                thirdFraction = [COINSFraction divide:firstFraction by:secondFraction];
//                break;
//            default:
//				NSLog(@"Unknown operator!");
//                break;
//		}
//        
////		wholeRange = NSMakeRange(0, inputString.length);
////        [inputString replaceCharactersInRange:wholeRange withString:thirdFraction.stringRepresentation];
//        
//		// 計算結果の表示(整数値かどうかによって場合分け)
//		if (thirdFraction.denominator == 1) { // thirdFraction is an integer
//			thirdIntegerLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.numerator];
//		} else {
//			thirdNumeratorLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.numerator];
//			thirdDenominatorLabel.text = [NSString stringWithFormat:@"%d", thirdFraction.denominator];
//			thirdVinculumView.hidden = NO;
//		}
//		if (thirdFraction.sign == -1) {
//			thirdSignLabel.text = @"-";
//		}
//	}
//	
//    
//	// 計算過程の表示
//    [inString appendFormat:@"%c",c];
//    
//    NSCharacterSet *operators = [NSCharacterSet characterSetWithCharactersInString:@"+-*/b=()"];
//    NSRange operatorRange = [inString rangeOfCharacterFromSet:operators];
//    NSRange inStringRange = NSMakeRange(0, inString.length);
//    
//	//AllClear
//    if (c == 'a') {
//        [inString replaceCharactersInRange:inStringRange withString:@""];
//		firstSignLabel.text = @"";
//        firstNumeratorLabel.text = @"";
//		firstDenominatorLabel.text = @"";
//		firstIntegerLabel.text = @"";
//        
//		firstOperatorLabel.text = @"";
//        
//		secondSignLabel.text = @"";
//		secondNumeratorLabel.text = @"";
//		secondDenominatorLabel.text = @"";
//		secondIntegerLabel.text = @"";
//		
//        firstEqualLabel.text = @"";
//		
//		thirdSignLabel.text = @"";
//        thirdNumeratorLabel.text = @"";
//        thirdDenominatorLabel.text = @"";
//        thirdIntegerLabel.text = @"";
//		
//		firstVinculumView.hidden = YES;
//		secondVinculumView.hidden = YES;
//		thirdVinculumView.hidden = YES;
//
//        turn = 0;
//    } else if (turn == 0 && operatorRange.location == NSNotFound) {   //左分母
//        firstDenominatorLabel.text = inString;
//        
//    } else if (c == 'b' && turn == 0 && inStringRange.length > 1) {   //左括線
//        firstVinculumView.hidden = NO;
//        [inString replaceCharactersInRange:inStringRange withString:@""];
//        turn++;
//        
//    } else if (turn == 1 && operatorRange.location == NSNotFound) {   //左分子
//        firstNumeratorLabel.text = inString;
//        
//    } else if (c == '+' && turn == 1 && inStringRange.length > 1) {   //演算子
//        firstOperatorLabel.text = @"+";
//        [inString replaceCharactersInRange:inStringRange withString:@""];
//        turn++;
//    } else if (c == '-' && turn == 1 && inStringRange.length > 1) {
//        firstOperatorLabel.text = @"-";
//        [inString replaceCharactersInRange:inStringRange withString:@""];
//        turn++;
//    } else if (c == '*' && turn == 1 && inStringRange.length > 1) {
//        firstOperatorLabel.text = @"×";
//        [inString replaceCharactersInRange:inStringRange withString:@""];
//        turn++;
//    } else if (c == '/' && turn == 1 && inStringRange.length > 1) {
//        firstOperatorLabel.text = @"÷";
//        [inString replaceCharactersInRange:inStringRange withString:@""];
//        turn++;
//        
//    } else if (turn == 2 && operatorRange.location == NSNotFound) {   //右分母
//        secondDenominatorLabel.text = inString;
//        
//    } else if (c == 'b' && turn == 2) {   //右括線
//        secondVinculumView.hidden = NO;
//        [inString replaceCharactersInRange:inStringRange withString:@""];
//        turn++;
//        
//    } else if (turn == 3 && operatorRange.location == NSNotFound) {   //右分子
//        secondNumeratorLabel.text = inString;
//        
//    } else if (c == '=' && turn == 3) {   //イコール
//        firstEqualLabel.text = @"=";
//        
//    } else if (c == '(' && turn == 3) {
//        firstEqualLabel.text = @"=";
//        turn++;
//    } else {   //その他
//        messageLabel.text = @"入力ミスです";
//    }
//	
//    NSLog(@"inputString: %@", inputHistory);
//    NSLog(@"inString: %@", inString);
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
		[keyboard updateButtonsWithRow:7 column:3 titles:buttonTitles outCharacters:outCharacters];
		NSArray *mergeInfo = @[@[@0, @1], @[@3, @6]];
		[keyboard mergeButtons:mergeInfo];
	} else {
		NSArray *buttonTitles = @[@"AC",@"C",	@"±",	@"÷",
								  @"7",	@"8",	@"9",	@"×",
								  @"4",	@"5",	@"6",	@"-",
								  @"1",	@"2",	@"3",	@"+",
								  @"0",	@"分の",	@"分の",	@"="];
		NSString *outCharacters = @"acs/789*456-123+0bb=";
		[keyboard updateButtonsWithRow:5 column:4 titles:buttonTitles outCharacters:outCharacters];
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