//
//  PrivacyPolicyView.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PrivacyPolicyView.h"


@interface PrivacyPolicyView ()
@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *chooseButton;

@property (nonatomic, copy) ChooseBlock block;
@property (nonatomic, copy) MarkBlock markActionBlock;
@end


@implementation PrivacyPolicyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.markButton addTarget:self action:@selector(markButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.markButton setImage:[UIImage imageNamed:@"同意"] forState:UIControlStateNormal];
//    [self.markButton setImage:[UIImage imageNamed:@"同意点击"] forState:UIControlStateHighlighted];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.font = [UIFont systemFontOfSize:13.0f];
    self.tipLabel.text = @"我已阅读并接受";
    self.tipLabel.textColor = [UIColor colorWithHexString:@"999999"];
   
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.chooseButton setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    [self.chooseButton setTitle:@"隐私保护的条款" forState:UIControlStateNormal];
    [self.chooseButton addTarget:self action:@selector(chooseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupLayout {
    [self addSubview:self.markButton];
    [self addSubview:self.tipLabel];
    [self addSubview:self.chooseButton];
    
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.markButton.mas_right).offset(5.0f);
        make.centerY.equalTo(self.markButton);
    }];
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.tipLabel);
    }];
}

- (void)markButtonAction {
    self.isMark = !self.isMark;
    BLOCK_EXEC(self.markActionBlock);
}

-(void)setMarkBlock:(MarkBlock)block {
    self.markActionBlock = block;
}
- (void)chooseButtonAction {
    BLOCK_EXEC(self.block);
}

- (void)setChooseBlock:(ChooseBlock)block {
    self.block = block;
}

- (void)setIsMark:(BOOL)isMark {
    _isMark = isMark;
    if (isMark) {
         [self.markButton setImage:[UIImage imageNamed:@"同意点击"] forState:UIControlStateNormal];
    }else {
        [self.markButton setImage:[UIImage imageNamed:@"同意"] forState:UIControlStateNormal];
    }
}
@end






