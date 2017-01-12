//
//  LoginActionView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginActionView.h"

@interface LoginActionView()
@property (nonatomic, strong) UIButton *button;
@end

@implementation LoginActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIButton *b = [[UIButton alloc]init];
    UIImage *normalImage = [UIImage yx_imageWithColor:[UIColor whiteColor]];
    UIImage *highlightImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"d65b4b"]];
    [b setBackgroundImage:normalImage forState:UIControlStateNormal];
    [b setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [b setTitleColor:[UIColor colorWithHexString:@"d65b4b"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    b.titleLabel.font = [UIFont systemFontOfSize:14];
    b.layer.borderColor = [UIColor colorWithHexString:@"d65b4b"].CGColor;
    b.layer.borderWidth = 1;
    b.layer.cornerRadius = 2;
    b.clipsToBounds = YES;
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.button = b;
}

- (void)btnAction {
    BLOCK_EXEC(self.actionBlock);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.button setTitle:title forState:UIControlStateNormal];
}

@end
