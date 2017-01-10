//
//  YXEmptyView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXEmptyView.h"

@interface YXEmptyView()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation YXEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _title = @"无内容";
        _imageName = @"无内容";
        [self setupUI];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setupUI{
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    
    self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"无内容"];
    [self.containerView addSubview:self.imageView];

    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"无内容";
    [self.containerView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.numberOfLines = 0;
    [self.containerView addSubview:self.subTitleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(202, 202));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.imageView.mas_bottom).mas_offset(2);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-32.0f);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)setIsActivityVideo:(BOOL)isActivityVideo {
    _isActivityVideo = isActivityVideo;
    if (_isActivityVideo) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.containerView);
        }];
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
}
@end
