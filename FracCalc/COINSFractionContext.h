//
//  COINSFractionStateContext.h
//  FracCalc
//
//  Created by Yusuke Iwama on 10/31/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COINSFractionState.h"

@interface COINSFractionContext : NSObject

@property COINSFractionState* currentState;

- (void)inputChar:(unichar)c;

@end
