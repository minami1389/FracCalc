//
//  COINSFraction.h
//  FracCalc
//
//  Created by Yusuke Iwama on 9/14/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COINSFraction : NSObject

@property NSUInteger numerator;
@property NSUInteger denominator;
@property NSInteger	 sign; // 1 or -1

/* Create fraction */
/// Designated initializer
- (id)initWithSign:(NSUInteger)s numerator:(NSInteger)n denominator:(NSInteger)d;
+ (id)fractionWithSign:(NSInteger)sign numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator;
+ (id)fractionWithString:(NSString *)string; // string may be like -2/3, 8/9 etc.
+ (id)MixedfractionWithString:(NSString *)string;


/* Process fractions */
+ (void)reduction:(COINSFraction *)A;

+ (COINSFraction *)add:(COINSFraction *)A to:(COINSFraction *)B;
+ (COINSFraction *)subtract:(COINSFraction *)A from:(COINSFraction *)B;
+ (COINSFraction *)multiply:(COINSFraction *)A by:(COINSFraction *)B;
+ (COINSFraction *)divide:(COINSFraction *)A by:(COINSFraction *)B;

- (COINSFraction *)add:(COINSFraction *)A;
- (COINSFraction *)sub:(COINSFraction *)A;
- (COINSFraction *)mul:(COINSFraction *)A;
- (COINSFraction *)div:(COINSFraction *)A;

- (NSString *)stringRepresentation;

/* Convert primitive data type into COINSFraction */
+ (id)fractionWithInteger:(NSInteger)i;
//+ (id)fractionWithRecurringDecimal:(float)f;

@end

