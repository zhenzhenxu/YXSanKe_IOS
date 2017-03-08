//
//  VerifyCodeInputView.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoInputView;
typedef void(^VerifyCodeBlock)(void);

@interface VerifyCodeInputView : UIView

@property (nonatomic, strong) InfoInputView *codeInputView;


- (void)setRightButtonText:(NSString *)text;

- (void)resetRightButtonText:(NSString *)text;

- (void)setRightButtonEnabled:(BOOL)enabled;

- (void)setVerifyCodeBlock:(VerifyCodeBlock)block;

- (void)startTimer;
- (void)stopTimer;
@end
