//
//  COINSFraction.m
//  FracCalc
//
//  Created by Yusuke Iwama on 9/14/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import "COINSFraction.h"

// Calc Greatest Common Devider with Euclidean algorithm.
static int gcd(int a, int b)
{
	if (a < b) {
		return gcd(b, a);
	}
	if (b == 0) {
		return a;
	}
	return gcd(b, a % b);
}

@implementation COINSFraction

@synthesize numerator;
@synthesize denominator;
@synthesize sign;

- (id)initWith:(NSUInteger)s numerator:(NSInteger)n denominator:(NSInteger)d
{
	self = [super init];
	
	if (self) {
		if (d == 0) {
			NSLog(@"Divided by zero.");
			return nil;
		}
		if (n == 0) {
			sign = 1;
		} else {
			sign = s;
		}
		numerator = n;
		denominator = d;
		[COINSFraction reduction:self];
	}
	
	return self;
}

+ (id)fractionWith:(NSInteger)sign numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator
{
	return [[COINSFraction alloc] initWith:sign numerator:numerator denominator:denominator];
}

+ (id)fractionWithString:(NSString *)string
{
	NSUInteger s;
	NSInteger n, d;
	
	// Remove white space.
	string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	// Get the minus operator if exists.
	unichar c = [string characterAtIndex:0];
	if (c == '-') {
		s = -1;
		string = [string substringFromIndex:1];
	} else {
		s = 1;
	}
	
    
	// Get the numerator and the denominator.
    NSRange search = [string rangeOfString:@"b"];
    if (search.location == NSNotFound) {
        n = [string integerValue];
        d = 1;
    } else {
        NSArray *components = [string componentsSeparatedByString:@"b"];
        if (components.count == 2) {
            n = [((NSString *)(components[1])) integerValue];
            d = [((NSString *)(components[0])) integerValue];
        } else {
            return nil;
        }
    }

	return [COINSFraction fractionWith:s numerator:n denominator:d];
}


+ (id)MixedfractionWithString:(NSString *)string
{
	NSUInteger s;
	NSInteger n, d;
	
    // Get the minus operator if exists.
	unichar c = [string characterAtIndex:0];
	if (c == '-') {
		s = -1;
		string = [string substringFromIndex:1];
	} else {
		s = 1;
	}
	
    NSArray *frac = [string componentsSeparatedByString:@"m"];
    NSString *mixed = frac[0];
    NSUInteger m = [mixed integerValue];
    string = frac[1];
    
	// Get the numerator and the denominator.
    NSRange search = [string rangeOfString:@"b"];
    if (search.location == NSNotFound) {
        n = [string integerValue];
        d = 1;
    } else {
        NSArray *components = [string componentsSeparatedByString:@"b"];
        if (components.count == 2) {
            n = [((NSString *)(components[1])) integerValue];
            d = [((NSString *)(components[0])) integerValue];
            n = n + m * d;
        } else {
            return nil;
        }
    }
    
	return [COINSFraction fractionWith:s numerator:n denominator:d];
}

+ (void)reduction:(COINSFraction *)A
{
	NSUInteger g = gcd(A.numerator, A.denominator);
	A.numerator /= g;
	A.denominator /= g;
}

+ (COINSFraction *)add:(COINSFraction *)A to:(COINSFraction *)B
{
	NSUInteger s;
	NSInteger n, d;
	
	// Calc the numerator and the sign.
	n = A.sign * A.numerator * B.denominator + B.sign * B.numerator * A.denominator;
	(n < 0) ? (s = -1) : (s = 1);
	n = abs(n);

	// Calc the denominator.
	d = A.denominator * B.denominator;
	
	return [COINSFraction fractionWith:s numerator:n denominator:d];
}

+ (COINSFraction *)subtract:(COINSFraction *)A from:(COINSFraction *)B
{
	COINSFraction *minusA = [COINSFraction fractionWith:A.sign * -1 numerator:A.numerator denominator:A.denominator];
	return [COINSFraction add:minusA to:B];
}

+ (COINSFraction *)multiply:(COINSFraction *)A by:(COINSFraction *)B
{
	return [COINSFraction fractionWith:A.sign * B.sign
							 numerator:A.numerator * B.numerator
						   denominator:A.denominator * B.denominator];
}

+ (COINSFraction *)divide:(COINSFraction *)A by:(COINSFraction *)B
{
	return [COINSFraction fractionWith:A.sign * B.sign
							 numerator:A.numerator * B.denominator
						   denominator:A.denominator * B.numerator];
}

- (COINSFraction *)add:(COINSFraction *)A
{
	return [COINSFraction add:A to:self];
}

- (COINSFraction *)sub:(COINSFraction *)A
{
	return [COINSFraction subtract:A from:self];
}

- (COINSFraction *)mul:(COINSFraction *)A
{
	return [COINSFraction multiply:self by:A];
}

- (COINSFraction *)div:(COINSFraction *)A
{
	return [COINSFraction divide:self by:A];
}

- (NSString *)stringRepresentation
{
	return (denominator == 1)
	? [NSString stringWithFormat:@"%d", sign * numerator]
	: [NSString stringWithFormat:@"%db%d", sign *numerator, denominator];
}

+ (id)fractionWithInteger:(NSInteger)i
{
	return [COINSFraction fractionWith:i / abs(i) numerator:i denominator:1];
}


@end