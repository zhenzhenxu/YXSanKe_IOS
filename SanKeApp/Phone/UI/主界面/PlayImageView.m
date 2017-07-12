//
//  PlayImageView.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PlayImageView.h"

@interface PlayImageView ()

@property (nonatomic, strong) UIImageView *playImageView;

@end

@implementation PlayImageView
- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    UIView *shadeView = [[UIView alloc] init];
    shadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    [self addSubview:shadeView];
    [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.playImageView = [[UIImageView alloc] init];
    self.playImageView.image = [UIImage imageNamed:@"播放-小"];
    self.playImageView.alpha = 0.7f;
    [self addSubview:self.playImageView];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
        make.center.equalTo(self);
    }];
}

- (void)setIsBiggerPlayIcon:(BOOL)isBiggerPlayIcon {
    _isBiggerPlayIcon = isBiggerPlayIcon;
    self.playImageView.image = [UIImage imageNamed:@"播放-大"];
}
@end
