//
//  KeyResponce.m
//  FracCalc
//
//  Created by minami on 2013/11/29.
//  Copyright (c) 2013年 COINS Project AID. All rights reserved.
//

#import "KeyResponce.h"
#import <QuartzCore/QuartzCore.h>


@implementation KeyResponce

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state buttonframe:(CGRect)size {
    UIView *view = [[UIView alloc] initWithFrame:size];
    view.layer.cornerRadius = 2.0f;
    view.clipsToBounds = YES;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -view.frame.origin.x, -view.frame.origin.y);
    [view.layer renderInContext:context];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:renderedImage forState:UIControlStateHighlighted];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
