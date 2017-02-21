//
//  ErrorView.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ErrorView.h"

@interface ErrorView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *retryLabel;
@property (nonatomic, copy) RetryBlock block;
@end

@implementation ErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"哭脸"]];
    
    self.retryLabel = [[UILabel alloc]init];
    self.retryLabel.font = [UIFont systemFontOfSize:14];
    self.retryLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.retryLabel.text = @"网络错误,点击后重试";
    self.retryLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(retryLabelClick)];
    [self addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void)retryLabelClick {
    BLOCK_EXEC(self.block);
}
- (void)setupLayout {
    [self addSubview:self.contentView];
    [self addSubview:self.iconView];
    [self addSubview:self.retryLabel];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-55);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    [self.retryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconView.mas_bottom).offset(10);
    }];
}
- (void)setRetryBlock:(RetryBlock)block {
    self.block = block;
}
@end
