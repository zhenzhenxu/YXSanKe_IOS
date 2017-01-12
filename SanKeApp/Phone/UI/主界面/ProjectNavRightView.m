//
//  ProjectNavRightView.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectNavRightView.h"
@interface ProjectNavRightView ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@end
@implementation ProjectNavRightView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, 70.0f, 30.0f);
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, 30.0f, 30.0f);
    [self.leftButton setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
    WEAK_SELF
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.ProjectNavButtonLeftBlock);
    }];
    [self addSubview:self.leftButton];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(40.0f, 0.0f, 30.0f, 30.0f);
    [self.rightButton setImage:[UIImage imageNamed:@"历史记录-2"] forState:UIControlStateNormal];
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.ProjectNavButtonRightBlock);
    }];
    [self addSubview:self.rightButton];
}

@end
