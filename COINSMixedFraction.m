//
//  COINSMixedFraction.m
//  FracCalc
//
//  Created by Yusuke IWAMA on 9/16/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import "COINSMixedFraction.h"

@implementation COINSMixedFraction

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
	
    NSArray *frac = [string componentsSeparatedByString:@" "];
    NSString *mixed = frac[0];
    NSUInteger m = [mixed integerValue];
    string = frac[1];
    
	// Get the numerator and the denominator.
    NSRange search = [string rangeOfString:@"\\"];
    if (search.location == NSNotFound) {
        n = [string integerValue];
        d = 1;
    } else {
        NSArray *components = [string componentsSeparatedByString:@"\\"];
        if (components.count == 2) {
            n = [((NSString *)(components[0])) integerValue];
            d = [((NSString *)(components[1])) integerValue];
            n = n + m * d;
        } else {
            return nil;
        }
    }
    
	return [COINSFraction fractionWith:s numerator:n denominator:d];
}


@end
