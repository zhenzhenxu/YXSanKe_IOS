//
//  InfoInputView.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoInputView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *originalText;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL secureTextEntry;

@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);

@end
