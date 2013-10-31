//
//  COINSFractionStateContext.m
//  FracCalc
//
//  Created by Yusuke Iwama on 10/31/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import "COINSFractionContext.h"

@implementation COINSFractionContext {
	COINSFractionState *previousState;
}

@synthesize currentState;

- (id)init
{
	if (self = [super init]) {
		currentState = [[COINSFractionStateFirstSign alloc] init];
	}
	
	return self;
}

- (void)inputChar:(unichar)c
{
	if ([currentState class] == [COINSFractionStateBadInput class]) {
		currentState = previousState;
	}
	previousState = currentState;
	currentState = [currentState nextStateWithInput:c];
}

@end
