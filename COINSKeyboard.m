//
//  COINSKeyboard.m
//  FracCalc
//
//  Created by Yusuke IWAMA on 9/16/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import "COINSKeyboard.h"

@implementation COINSKeyboard {
	NSMutableArray *buttons;
	NSUInteger row;
	NSUInteger column;
	CGSize buttonSize;
}

@synthesize delegate;
@synthesize buttonInset;
@synthesize titles;
@synthesize outCharacters;

- (void)updateButtonsWithRow:(NSUInteger)r column:(NSUInteger)c titles:(NSArray *)t outCharacters:(NSString *)s
{
	// check if number of buttons and titles match
	if (t.count != s.length) {
		NSLog(@"button title count and out characters don't match!");
		return;
	}

	// remove all buttons from view and array
	if (buttons) {
		for (UIButton *aButton in buttons) {
			[aButton removeFromSuperview];
		}
		[buttons removeAllObjects];
	} else {
		buttons = [NSMutableArray array];
	}
	
	UIColor *backgroundColor = [UIColor blackColor];
	UIColor *keyColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
	self.backgroundColor = backgroundColor;
	row = r;
	column = c;
	titles = t;
	outCharacters = s;
	
	CGFloat buttonBorderWidth = 0.5;
	UIEdgeInsets keyboardInset = UIEdgeInsetsMake(1.0 - buttonBorderWidth, // top
												  1.0 - buttonBorderWidth, // left
												  1.0 - buttonBorderWidth, // bottom
												  1.0 - buttonBorderWidth); // right
	buttonSize = CGSizeMake((self.frame.size.width - keyboardInset.left - keyboardInset.right) / column,
							(self.frame.size.height - keyboardInset.top - keyboardInset.bottom) / row);
	for (int i = 0; i < titles.count; i++) {
		UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		aButton.frame = CGRectMake((i % column) * buttonSize.width + keyboardInset.left,
								   (i / column) * buttonSize.height + keyboardInset.top,
								   buttonSize.width,
								   buttonSize.height);
		[aButton setTitle:titles[i] forState:UIControlStateNormal];
		[aButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		aButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:buttonSize.width / 2];
		aButton.titleLabel.adjustsFontSizeToFitWidth = YES;
		// set key color
		NSCharacterSet *operators = [NSCharacterSet characterSetWithCharactersInString:@"+-×÷="];
		NSRange operatorsRange = [aButton.titleLabel.text rangeOfCharacterFromSet:operators];
		if (operatorsRange.location == NSNotFound) {
			NSCharacterSet *numerals = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
			NSRange numeralRange = [aButton.titleLabel.text rangeOfCharacterFromSet:numerals];
			if (numeralRange.location == NSNotFound) { // others
				[aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				aButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
			} else { // numeral
				[aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				aButton.backgroundColor = keyColor;
			}
		} else { // four arithmetic operator or equal
			[aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			aButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.56 blue:0.0 alpha:1.0];
		}
		aButton.layer.borderWidth = buttonBorderWidth;
		aButton.layer.borderColor = [backgroundColor CGColor];
		
		[buttons addObject:aButton];
	
		[self addSubview:aButton];
	}
}

- (void)buttonPressed:(id)sender
{
	NSUInteger i = [buttons indexOfObject:sender];
	[delegate input:[outCharacters characterAtIndex:i]];
    
}

- (void)mergeButtons:(NSArray *)mergeInfo
{
	for (NSArray *anArray in mergeInfo) {
		UIButton *topButton, *rightButton, *bottomButton, *leftButton;
		NSUInteger top = NSUIntegerMax, right = 0, bottom = 0, left = NSUIntegerMax; // indexes of the buttons
		for (NSNumber *n in anArray) {
			// Find the most top-left corner and the bottom-right corner.
			NSUInteger i = n.integerValue;
			UIButton *aButton = buttons[i];
			NSUInteger r = i / column;
			NSUInteger c = i % column;
			if (r < top) {
				top = r;
				topButton = aButton;
			}
			if (c > right) {
				right = c;
				rightButton = aButton;
			}
			if (r > bottom) {
				bottom = r;
				bottomButton = aButton;
			}
			if (c < left) {
				left = c;
				leftButton = aButton;
			}
			aButton.hidden = YES;
		}
		NSNumber *n = [anArray objectAtIndex:0];
		NSUInteger representativeIndex = n.integerValue;
		UIButton *representativeButton = buttons[representativeIndex];
		representativeButton.hidden = NO;
		representativeButton.frame = CGRectMake(leftButton.frame.origin.x,
												topButton.frame.origin.y,
												rightButton.frame.origin.x + buttonSize.width - leftButton.frame.origin.x,
												bottomButton.frame.origin.y + buttonSize.height - topButton.frame.origin.y);
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
