//
//  COINSStateContext.m
//  FracCalc
//
//  Created by Yusuke Iwama on 10/30/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import "COINSStateContext.h"

@implementation COINSStateContext

@synthesize state;

- (void)changeStateWithChar:(char)c
{
	state = [state changeStateWithChar:c];
}

@end
