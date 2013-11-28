//
//  COINSFractionState.h
//  FracCalc
//
//  Created by Yusuke Iwama on 10/31/13.
//  Copyright (c) 2013 COINS Project AID. All rights reserved.
//

#import <Foundation/Foundation.h>

enum COINSFractionBadInput {
	COINSFractionBadInputUnsupportedInput = 0,
	COINSFractionBadInputDivisionByZero,
	};

// abstruct class for state design pattern
@interface COINSFractionState : NSObject
- (COINSFractionState *)nextStateWithInput:(unichar)c;
@end

@interface COINSFractionStateBadInput : COINSFractionState;
@end

@interface COINSFractionStateFirstSign : COINSFractionState;
@end
@interface COINSFractionStateFirstNumber : COINSFractionState;
@end
@interface COINSFractionStateFirstVinculum : COINSFractionState;
@end
@interface COINSFractionStateFirstNumerator : COINSFractionState;
@end
@interface COINSFractionStateFirstIntegerZero : COINSFractionState;
@end
@interface COINSFractionStateFirstNumeratorZero : COINSFractionState;
@end

@interface COINSFractionStateOperatorButDivision : COINSFractionState;
@end
@interface COINSFractionStateOperatorDivision : COINSFractionState;
@end
@interface COINSFractionStateOperatorButDivisiondash : COINSFractionState;
@end
@interface COINSFractionStateOperatorDivisiondash : COINSFractionState;
@end


@interface COINSFractionStateSecondSign : COINSFractionState;
@end
@interface COINSFractionStateSecondNumber : COINSFractionState;
@end
@interface COINSFractionStateSecondVinculum : COINSFractionState;
@end
@interface COINSFractionStateSecondNumerator : COINSFractionState;
@end
@interface COINSFractionStateSecondIntegerZero : COINSFractionState;
@end
@interface COINSFractionStateSecondNumeratorZero : COINSFractionState;
@end

@interface COINSFractionStateSecondSignDivision : COINSFractionState;
@end
@interface COINSFractionStateSecondNumberDivision : COINSFractionState;
@end
@interface COINSFractionStateSecondVinculumDivision : COINSFractionState;
@end
@interface  COINSFractionStateSecondNumeratorDivision: COINSFractionState;
@end

@interface COINSFractionStateEnd : COINSFractionState;
@end
