//
//  UserInfoHeaderView.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoHeaderView.h"

@interface UserInfoHeaderView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
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
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.userInteractionEnabled = YES;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.9;
    
    UIView *maskView = [[UIView alloc]init];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.cornerRadius = 36.5;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.userInteractionEnabled = YES;
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:maskView];
    [self.backgroundImageView addSubview:self.iconImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(73, 73));
    }];
}

- (void)setModel:(UserModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.portraitUrl] placeholderImage:[UIImage imageNamed:@"大头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.backgroundImageView.image = image;
    }];
}


@end
