//
//  PlayImageView.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PlayImageView.h"

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
    
    UIImageView *playImageView = [[UIImageView alloc] init];
    playImageView.image = [UIImage imageNamed:@"播放"];
    playImageView.alpha = 0.7f;
    [self addSubview:playImageView];
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
        make.center.equalTo(self);
    }];
}
@end
