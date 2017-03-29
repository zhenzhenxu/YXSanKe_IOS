//
//  LoginInputView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginInputView.h"

@interface LoginInputView()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation LoginInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    
    self.clearButton = [[UIButton alloc]init];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    self.clearButton.hidden = YES;
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.textField = [[UITextField alloc]init];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-10);
    }];
}

- (void)clearAction {
    self.textField.text = @"";
    self.clearButton.hidden = YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.backgroundColor = [UIColor colorWithHexString:@"999999"];
    self.clearButton.hidden = textField.text.length==0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.clearButton.hidden = YES;
    if (textField.text.length > 0) {
        self.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }else {
        self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.clearButton.hidden = text.length==0;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 
- (NSString *)text {
    return [self.textField.text yx_stringByTrimmingCharacters];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    self.textField.keyboardType = keyboardType;
}

- (UIKeyboardType)keyboardType
{
    return self.textField.keyboardType;
}

@end
