//
//  QAReplyDetailMenuItemView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyDetailMenuItemView.h"

@interface QAReplyDetailMenuItemView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *menuButton;
@end

@implementation QAReplyDetailMenuItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.menuButton = [[UIButton alloc]init];
    [self.menuButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.menuButton setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateHighlighted];
    self.menuButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.menuButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.menuButton];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)updateWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title {
    [self.menuButton setImage:image forState:UIControlStateNormal];
    [self.menuButton setImage:highlightImage forState:UIControlStateHighlighted];
    [self.menuButton setTitle:title forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize imageSize = self.menuButton.imageView.frame.size;
    CGSize titleSize = self.menuButton.titleLabel.frame.size;
    self.menuButton.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height/2, titleSize.width/2, titleSize.height/2, -titleSize.width/2);
    self.menuButton.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height/2, -imageSize.width/2, -imageSize.height/2, imageSize.width/2);
}

- (void)btnAction {
    BLOCK_EXEC(self.ActionBlock)
}

@end
