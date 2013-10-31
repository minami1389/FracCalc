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
	NSMutableString *inputString;
	NSMutableString *inString;
    NSMutableString *check;

    
	CGSize appSize;
    
    UILabel *label;
    

    
}

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
	
	
    label = [UILabel alloc];
    label = [label initWithFrame:CGRectMake(0, 500, 600, 100)];
    label.font = [UIFont systemFontOfSize:70];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 200)];
    [self.view addSubview:title];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor lightGrayColor];
    title.shadowColor = [UIColor blackColor];
    title.shadowOffset = CGSizeMake(1, 1);
    title.font = [UIFont fontWithName:@"Optima-ExtraBlack" size:50];
    title.text = @"Fraction Calculator";
	
    
    
    aa = [[UILabel alloc] initWithFrame:CGRectMake(4, 200, 120, 120)];
    [self.view addSubview:aa];
    aa.textAlignment = NSTextAlignmentCenter;
    aa.font = [UIFont systemFontOfSize:90];
    aa.adjustsFontSizeToFitWidth = YES;

    ab = [[UILabel alloc] initWithFrame:CGRectMake(120, 260, 120, 120)];
    [self.view addSubview:ab];
    ab.textAlignment = NSTextAlignmentCenter;
    ab.font = [UIFont systemFontOfSize:90];

    ac = [[UILabel alloc] initWithFrame:CGRectMake(236, 200, 120, 120)];
    [self.view addSubview:ac];
    ac.textAlignment = NSTextAlignmentCenter;
    ac.font = [UIFont systemFontOfSize:90];
    ac.adjustsFontSizeToFitWidth = YES;

    ad = [[UILabel alloc] initWithFrame:CGRectMake(356, 260, 120, 120)];
    [self.view addSubview:ad];
    ad.textAlignment = NSTextAlignmentCenter;
    ad.font = [UIFont systemFontOfSize:90];

    ae = [[UILabel alloc] initWithFrame:CGRectMake(476, 200, 120, 120)];
    [self.view addSubview:ae];
    ae.textAlignment = NSTextAlignmentCenter;
    ae.font = [UIFont systemFontOfSize:90];
    ae.adjustsFontSizeToFitWidth = YES;
    
    ba = [[UILabel alloc] initWithFrame:CGRectMake(4, 320, 120, 120)];
    [self.view addSubview:ba];
    ba.textAlignment = NSTextAlignmentCenter;
    ba.font = [UIFont systemFontOfSize:90];
    ba.adjustsFontSizeToFitWidth = YES;
    
    bc = [[UILabel alloc] initWithFrame:CGRectMake(236, 320, 120, 120)];
    [self.view addSubview:bc];
    bc.textAlignment = NSTextAlignmentCenter;
    bc.font = [UIFont systemFontOfSize:90];
    bc.adjustsFontSizeToFitWidth = YES;

    
    be = [[UILabel alloc] initWithFrame:CGRectMake(476, 320, 120, 120)];
    [self.view addSubview:be];
    be.textAlignment = NSTextAlignmentCenter;
    be.font = [UIFont systemFontOfSize:90];
    be.adjustsFontSizeToFitWidth = YES;
    
    c1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 318, 120, 4)];
    [self.view addSubview:c1];
    
    c2 = [[UILabel alloc] initWithFrame:CGRectMake(236, 318, 120, 4)];
    [self.view addSubview:c2];
    
    c3 = [[UILabel alloc] initWithFrame:CGRectMake(476, 318, 120, 4)];
    [self.view addSubview:c3];
    
    center1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 260, 120, 120)];
    [self.view addSubview:center1];
    center1.textAlignment = NSTextAlignmentCenter;
    center1.font = [UIFont systemFontOfSize:90];
    center1.adjustsFontSizeToFitWidth = YES;
    center1.backgroundColor = [UIColor clearColor];

    center2 = [[UILabel alloc] initWithFrame:CGRectMake(236, 260, 120, 120)];
    [self.view addSubview:center2];
    center2.textAlignment = NSTextAlignmentCenter;
    center2.font = [UIFont systemFontOfSize:90];
    center2.adjustsFontSizeToFitWidth = YES;
    center2.backgroundColor = [UIColor clearColor];
    
    center3 = [[UILabel alloc] initWithFrame:CGRectMake(460, 265, 120, 120)];
    [self.view addSubview:center3];
    center3.textAlignment = NSTextAlignmentCenter;
    center3.font = [UIFont systemFontOfSize:90];
    center3.adjustsFontSizeToFitWidth = YES;
    center3.backgroundColor = [UIColor clearColor];
    
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




}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end