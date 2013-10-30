//
//  COINSStateContext.h
//  FracCalc
//
//  Created by Yusuke Iwama on 10/30/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COINSStateContextProtocol <NSObject>

- (id<COINSStateContextProtocol>)changeStateWithChar:(char)c;

@end



@interface COINSStateContext : NSObject

@property (readonly) id<COINSStateContextProtocol> state;

- (void)changeStateWithChar:(char)c;

@end
