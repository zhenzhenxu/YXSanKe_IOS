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

@property (nonatomic, copy) TextChangeBlock Block;
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
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除-拷贝"] forState:UIControlStateNormal];
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


- (NSString *)text
{
    return [self.textField.text yx_stringByTrimmingCharacters];
}

#pragma mark -

- (void)clearAction
{
    self.textField.text = @"";
    [self textEditingChanged:self.textField];
    self.clearButton.hidden = YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.clearButton.hidden = textField.text.length==0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.clearButton.hidden = YES;
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

#pragma mark - text change

- (void)textEditingChanged:(UITextField *)sender
{
    self.clearButton.hidden = ![self.text yx_isValidString];
    BLOCK_EXEC(self.Block,self.text)
}

- (void)setTextChangeBlock:(TextChangeBlock)block {
    self.Block = block;
}

@end
