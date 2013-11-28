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

@property (weak, nonatomic) IBOutlet COINSKeyboard *keyboard;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *expressionView;

@property (weak, nonatomic) IBOutlet UILabel *firstSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNumeratorLabel;
@property (weak, nonatomic) IBOutlet UIView *firstVinculumView;
@property (weak, nonatomic) IBOutlet UILabel *firstDenominatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstIntegerLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstOperatorLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNumeratorLabel;
@property (weak, nonatomic) IBOutlet UIView *secondVinculumView;
@property (weak, nonatomic) IBOutlet UILabel *secondDenominatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondIntegerLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftParenthesisLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightParenthesisLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstEqualLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdNumeratorLabel;
@property (weak, nonatomic) IBOutlet UIView *thirdVinculumView;
@property (weak, nonatomic) IBOutlet UILabel *thirdDenominatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdIntegerLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end


/*
・問題

岩間
 コメント
 ・手と目、どちらのコントロールが難しいか→手→計算式のフォントサイズよりキーの大きさを優先
 ・キー配列はこれでいいか（四則演算が並んでいない
 ・if文で拾いきれない例外が大量にあるため、Stateデザインパターンを使用してバグを減らす
 ・純粋に状態を返すだけであれば、クラスはいらず、表で済む。

 ToDo（馬場)
 ！ACを介さずにはじめに戻る
 ・桁あふれ
 ・キーのレスポンス
 ・プラマイのタイミング
 ！イコールを押した後の見えない入力
 ・演算子の入力の変更(cを介さない)
*/