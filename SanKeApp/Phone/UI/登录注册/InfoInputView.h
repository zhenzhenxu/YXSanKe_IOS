//
//  InfoInputView.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TextChangeBlock)(NSString *text);

@interface InfoInputView : UIView<UITextFieldDelegate>
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) NSString *text;

- (void)setTextChangeBlock:(TextChangeBlock)block;
@end
