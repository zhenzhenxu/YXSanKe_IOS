//
//  InfoInputView.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "InfoInputView.h"

@interface InfoInputView ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIImageView *frontImageView;
@end


@implementation InfoInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.clearButton = [[UIButton alloc]init];
    self.clearButton.backgroundColor = [UIColor redColor];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    self.clearButton.hidden = YES;
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.tintColor = [UIColor colorWithHexString:@"333333"];
    self.textField.font = [UIFont systemFontOfSize:14.0f];
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-10);
    }];
}
- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [self.textField resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    return [self.textField becomeFirstResponder];
}

#pragma mark - getter & setter

- (void)setText:(NSString *)text
{
    self.textField.text = text;
    self.clearButton.hidden = ![text yx_isValidString];
    [self textEditingChanged:self.textField];
}

- (NSString *)text
{
    return [self.textField.text yx_stringByTrimmingCharacters];
}

- (NSString *)originalText {
    return self.textField.text;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    if (![placeholder yx_isValidString]) {
        return;
    }
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"c6c9cc"]};
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
}

- (NSString *)placeholder
{
    return self.textField.placeholder;
}

- (void)setEnabled:(BOOL)enabled
{
    self.textField.enabled = enabled;
}

- (BOOL)enabled
{
    return self.textField.enabled;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    self.textField.keyboardType = keyboardType;
}

- (UIKeyboardType)keyboardType
{
    return self.textField.keyboardType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    self.textField.secureTextEntry = secureTextEntry;
}

- (BOOL)secureTextEntry
{
    return self.textField.secureTextEntry;
}

#pragma mark -

- (void)clearAction
{
    self.textField.text = @"";
    self.clearButton.hidden = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - text change

- (void)textEditingChanged:(UITextField *)sender
{
    self.clearButton.hidden = ![self.text yx_isValidString];
    if (self.textChangeBlock) {
        self.textChangeBlock(self.text);
    }
}


@end
