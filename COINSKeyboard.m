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
	NSArray *titles;
	NSString *outCharacters;
	CGSize buttonSize;
}

@synthesize delegate;
@synthesize buttonInset;

// Super class's designated initializer
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		buttons = [NSMutableArray array];
    }
    return self;
}

- (id)initWithDelegate:(id<COINSKeyboardDelegate>)d Frame:(CGRect)frame row:(NSUInteger)r column:(NSUInteger)c titles:(NSArray *)t outCharacters:(NSString *)s
{
	self = [self initWithFrame:frame];
	
	if (self) {
		if (t.count != s.length) {
			return nil;
		}
		
		self.frame = frame;
		delegate = d;
		row = r;
		column = c;
		titles = t;
		outCharacters = s;
		
		buttonSize = CGSizeMake(self.frame.size.width / column, self.frame.size.height / row);
		for (int i = 0; i < titles.count; i++) {
			UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			aButton.frame = CGRectMake((i % column) * buttonSize.width,
									   (i / column) * buttonSize.height,
									   buttonSize.width,
									   buttonSize.height);
			[aButton setTitle:titles[i] forState:UIControlStateNormal];
			[aButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			aButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:buttonSize.width / 2];
			aButton.titleLabel.adjustsFontSizeToFitWidth = YES;

			[buttons addObject:aButton];
			
			[self addSubview:aButton];
		}
	}
	
	return self;
}

+ (COINSKeyboard *)keyboardWithDelegate:(id<COINSKeyboardDelegate>)d Frame:(CGRect)f row:(NSUInteger)r column:(NSUInteger)c titles:(NSArray *)t outCharacters:(NSString *)s
{
	return [[COINSKeyboard alloc] initWithDelegate:d Frame:f row:r column:c titles:t outCharacters:s];
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
