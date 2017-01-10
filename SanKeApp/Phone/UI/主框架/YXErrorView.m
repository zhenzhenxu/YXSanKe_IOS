//
//  YXErrorView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXErrorView.h"

@interface YXErrorView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *retryButton;
@end

@implementation YXErrorView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"网络异常"];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-110);
        make.size.mas_equalTo(CGSizeMake(202, 202));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"网络异常";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(5);
    }];
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.text = @"刷新重试";
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
    }];
    self.retryButton = [[UIButton alloc]init];
    self.retryButton.backgroundColor = [UIColor colorWithHexString:@"2585d6"];
    [self.retryButton setTitle:@"刷新" forState:UIControlStateNormal];
    self.retryButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.retryButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    self.retryButton.layer.cornerRadius = 2;
    self.retryButton.clipsToBounds = YES;
    [self addSubview:self.retryButton];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(115, 33));
    }];
}

- (void)btnAction{
    BLOCK_EXEC(self.retryBlock);
}
- (void)setIsActivityVideo:(BOOL)isActivityVideo {
    _isActivityVideo = isActivityVideo;
    if (_isActivityVideo) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView.hidden = YES;
        self.subTitleLabel.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-27.5);
        }];
        [self.retryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(18.5);
            make.size.mas_equalTo(CGSizeMake(115, 33));
        }];
    }
}
@end
