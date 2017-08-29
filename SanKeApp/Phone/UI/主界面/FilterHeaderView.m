//
//  FilterHeaderView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FilterHeaderView.h"

@interface FilterHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *seperatorView;
@end

@implementation FilterHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.seperatorView = [[UIView alloc]init];
    self.seperatorView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self addSubview:self.seperatorView];
    [self.seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(self.seperatorView.mas_bottom).offset(11);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSeperatorHidden:(BOOL)seperatorHidden {
    _seperatorHidden = seperatorHidden;
    self.seperatorView.hidden = seperatorHidden;
}

@end
