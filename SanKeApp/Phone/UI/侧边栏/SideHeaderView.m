//
//  SideHeaderView.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SideHeaderView.h"
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
const CGFloat kSideLeftDrawerWidth = 600.0f;

@interface SideHeaderView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) EditButtonActionBlock buttonActionBlock;

@end
@implementation SideHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"大头像"];
    self.iconImageView.backgroundColor = [UIColor redColor];
    self.iconImageView.layer.cornerRadius = 20.0f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.text = @"这是用户名字";
    
    self.editButton = [[UIButton alloc] init];
    [self.editButton setImage:[UIImage imageNamed:@"编辑"]
                     forState:UIControlStateNormal];
    [self.editButton setImage:[UIImage imageNamed:@"编辑"]
                     forState:UIControlStateHighlighted];
    self.editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton setImageEdgeInsets:UIEdgeInsetsMake(0,kScreenWidth *kSideLeftDrawerWidth/750.f - 10.0f -30.0f , 0.0f, 0.0f)];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
}
- (void)setupLayout {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.editButton];
    [self addSubview:self.lineView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

- (void)editButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.buttonActionBlock);
}

- (void)setEditButtonActionBlock:(EditButtonActionBlock)block {
    self.buttonActionBlock = block;
}

- (void)setModel:(UserModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.backgroundImageUrl] placeholderImage:[UIImage imageNamed:@"大头像"]];
}
@end
