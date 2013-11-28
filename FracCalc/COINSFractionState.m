//
//  COINSFractionState.m
//  FracCalc
//
//  Created by Yusuke Iwama on 10/31/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import "COINSFractionState.h"
#import "COINSFractionContext.h"

@implementation COINSFractionState

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	return [[COINSFractionState alloc] init];
}

@end

@implementation COINSFractionStateBadInput

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	return self;
}

@end

@implementation COINSFractionStateFirstSign

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '0':
			return [[COINSFractionStateFirstIntegerZero alloc] init];
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateFirstNumber alloc] init];
		case 's':
			return [[COINSFractionStateFirstSign alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateFirstNumber

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateFirstNumber alloc] init];
		case 'b':
			return [[COINSFractionStateFirstVinculum alloc] init];
		case '+':
		case '-':
		case '*':
			return [[COINSFractionStateOperatorButDivision alloc] init];
		case '/':
			return [[COINSFractionStateOperatorDivision alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateFirstVinculum

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '0':
            return [[COINSFractionStateFirstNumeratorZero alloc] init];
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateFirstNumerator alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateFirstNumerator

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateFirstNumerator alloc] init];
		case '+':
		case '-':
		case '*':
			return [[COINSFractionStateOperatorButDivision alloc] init];
		case '/':
			return [[COINSFractionStateOperatorDivision alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateFirstIntegerZero

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '+':
		case '-':
		case '*':
			return [[COINSFractionStateOperatorButDivision alloc] init];
		case '/':
			return [[COINSFractionStateOperatorDivision alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateFirstNumeratorZero

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '+':
		case '-':
		case '*':
			return [[COINSFractionStateOperatorButDivision alloc] init];
		case '/':
			return [[COINSFractionStateOperatorDivision alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateOperatorButDivision

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '0':
			return [[COINSFractionStateSecondIntegerZero alloc] init];
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumber alloc] init];
		case 's':
			return [[COINSFractionStateSecondSign alloc] init];
        case '+':
        case '-':
        case '*':
            return [[COINSFractionStateOperatorButDivision alloc] init];
        case '/':
            return [[COINSFractionStateOperatorDivision alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateOperatorDivision

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumberDivision alloc] init];
		case 's':
			return [[COINSFractionStateSecondSignDivision alloc] init];
        case '+':
        case '-':
        case '*':
            return [[COINSFractionStateOperatorButDivision alloc] init];
        case '/':
            return [[COINSFractionStateOperatorDivision alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end


@implementation COINSFractionStateSecondSign

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '0':
			return [[COINSFractionStateSecondIntegerZero alloc] init];
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumber alloc] init];
		case 's':
			return [[COINSFractionStateSecondSign alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateSecondNumber

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumber alloc] init];
		case 'b':
			return [[COINSFractionStateSecondVinculum alloc] init];
		case '=':
			return [[COINSFractionStateEnd alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateSecondVinculum

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
        case '0':
            return [[COINSFractionStateSecondNumeratorZero alloc] init];
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumerator alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateSecondNumerator;

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumerator alloc] init];
		case '=':
			return [[COINSFractionStateEnd alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateSecondIntegerZero

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '=':
			return [[COINSFractionStateEnd alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateSecondNumeratorZero

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
    switch (c) {
        case '=':
            return [[COINSFractionStateEnd alloc] init];
        default:
            return [[COINSFractionStateBadInput alloc] init];
    }
}
@end



@implementation COINSFractionStateSecondSignDivision

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	switch (c) {
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumberDivision alloc] init];
		case 's':
			return [[COINSFractionStateSecondSignDivision alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}
}

@end

@implementation COINSFractionStateSecondNumberDivision

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
    switch (c) {
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumberDivision alloc] init];
		case 'b':
			return [[COINSFractionStateSecondVinculumDivision alloc] init];
		case '=':
			return [[COINSFractionStateEnd alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}

}

@end

@implementation COINSFractionStateSecondVinculumDivision

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
    switch (c) {
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumeratorDivision alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
	}

}

@end

@implementation COINSFractionStateSecondNumeratorDivision

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
    switch (c) {
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return [[COINSFractionStateSecondNumeratorDivision alloc] init];
		case '=':
			return [[COINSFractionStateEnd alloc] init];
		default:
			return [[COINSFractionStateBadInput alloc] init];
   
    }
}
@end

@implementation COINSFractionStateEnd

- (COINSFractionState *)nextStateWithInput:(unichar)c
{
	return [[COINSFractionStateFirstSign alloc] init];
}

@end
