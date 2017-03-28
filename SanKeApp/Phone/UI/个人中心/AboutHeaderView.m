//
//  AboutHeaderView.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AboutHeaderView.h"

@interface AboutHeaderView ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, strong) UIImageView *versionImageView;
@end

@implementation AboutHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    
    self.shadowView = [[UIView alloc]init];
    self.shadowView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    
    self.signImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"i教研"]];
    
    self.versionImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"v1.2"]];
}

- (void)setupLayout {
    [self addSubview:self.shadowView];
    [self addSubview:self.logoImageView];
    [self addSubview:self.signImageView];
    [self addSubview:self.versionImageView];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(10.0f);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shadowView).offset(69.0f);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(78, 78));
    }];
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(25.0f);
        make.centerX.equalTo(self.logoImageView);
        make.size.mas_equalTo(CGSizeMake(55, 23));
    }];
    
    [self.versionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signImageView.mas_bottom).offset(11.0f);
        make.centerX.equalTo(self.signImageView);
        make.bottom.equalTo(self);
    }];
}

@end
