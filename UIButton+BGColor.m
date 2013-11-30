//
//  UIButton+BGColor.m
//  FracCalc
//
//  Created by minami on 2013/11/30.
//  Copyright (c) 2013年 COINS Project AID. All rights reserved.
//

#import "UIButton+BGColor.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIButton (BGColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    CGRect buttonSize = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *bgView = [[UIView alloc] initWithFrame:buttonSize];
    bgView.layer.cornerRadius = self.frame.size.width / 2.0;
    bgView.clipsToBounds = true;
    bgView.backgroundColor = color;
    UIGraphicsBeginImageContext(self.frame.size);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:screenImage forState:state];
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
