//
//  StageSubjectHeaderView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StageSubjectHeaderView.h"

@interface StageSubjectHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *seperatorView;
@end

@implementation StageSubjectHeaderView
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
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setType:(StageSubjectType)type {
    _type = type;
    if (type == StageSubject_Stage) {
        self.titleLabel.text = @"学段";
    }else if (type == StageSubject_Subject) {
        self.titleLabel.text = @"学科";
    }
}

- (void)setSeperatorHidden:(BOOL)seperatorHidden {
    _seperatorHidden = seperatorHidden;
    self.seperatorView.hidden = seperatorHidden;
}

@end
