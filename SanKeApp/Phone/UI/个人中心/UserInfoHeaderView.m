//
//  UserInfoHeaderView.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoHeaderView.h"

@interface UserInfoHeaderView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *editLabel;
@property (nonatomic, copy) EditBlock block;
@end

@implementation UserInfoHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundImageView = [[UIImageView alloc]init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.userInteractionEnabled = YES;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.cornerRadius = 36.5;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editIconAction)];
    [self.iconImageView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    
    self.editLabel = [[UILabel alloc]init];
    self.editLabel.font = [UIFont systemFontOfSize:12.0f];
    self.editLabel.textColor = [UIColor colorWithHexString:@"4691a6"];
    self.editLabel.text = @"编辑头像";
    self.editLabel.userInteractionEnabled = YES;
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:self.iconImageView];
    [self.backgroundImageView addSubview:self.editLabel];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.backgroundImageView);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-12.0f);
        make.size.mas_equalTo(CGSizeMake(73, 73));
    }];
    [self.editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImageView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12.0f);
    }];
}

- (void)editIconAction {
    BLOCK_EXEC(self.block);
}
- (void)setEditBlock:(EditBlock)block {
    self.block = block;
}

- (void)setModel:(UserModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.portraitUrl] placeholderImage:[UIImage imageNamed:@"大头像"]];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.portraitUrl] placeholderImage:[UIImage imageNamed:@"大头像"]];
    if (model.isAnonymous) {
        self.editLabel.hidden = YES;
        self.iconImageView.userInteractionEnabled = NO;
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(73, 73));
        }];
    }else {
        self.editLabel.hidden = NO;
        self.iconImageView.userInteractionEnabled = YES;
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-12.0f);
            make.size.mas_equalTo(CGSizeMake(73, 73));
        }];
    }
}


@end
