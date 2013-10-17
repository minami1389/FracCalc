//
//  COINSViewController.h
//  FracCalc
//
//  Created by Yusuke Iwama on 9/14/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COINSKeyboard.h"

@interface COINSViewController : UIViewController <COINSKeyboardDelegate>
{
    NSInteger turn;
    UILabel *aa;
    UILabel *ab;
    UILabel *ac;
    UILabel *ad;
    UILabel *ae;
    UILabel *ba;
    UILabel *bc;
    UILabel *be;
    UILabel *c1;
    UILabel *c2;
    UILabel *c3;
    UILabel *center1;
    UILabel *center2;
    UILabel *center3;
}

@end
