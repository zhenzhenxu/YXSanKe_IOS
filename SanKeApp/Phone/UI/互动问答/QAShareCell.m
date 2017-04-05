//
//  QAShareCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAShareCell.h"

@interface QAShareCell ()
@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic, copy) ActionBlock buttonActionBlock;
@end

@implementation QAShareCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [[UIButton alloc]init];
    self.itemButton.layer.cornerRadius = 4;
    self.itemButton.clipsToBounds = YES;
    [self.itemButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)btnAction:(UIButton *)button {
    BLOCK_EXEC(self.buttonActionBlock);
}

- (void)setActionBlock:(ActionBlock)block {
    self.buttonActionBlock = block;
}

- (void)setType:(YXShareType)type {
    _type = type;
    switch (type) {
        case YXShareType_WeChat:
        {
           [self.itemButton setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        }
            break;
        case YXShareType_WeChatFriend:
        {
             [self.itemButton setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        }
            break;
        case YXShareType_TcQQ:
        {
             [self.itemButton setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        }
            break;
        case YXShareType_TcZone:
        {
             [self.itemButton setImage:[UIImage imageNamed:@"空间"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

@end
