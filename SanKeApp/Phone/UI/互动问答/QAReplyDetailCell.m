//
//  QAReplyDetailCell.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyDetailCell.h"

@interface QAReplyDetailCell()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *favorImageView;
@property (nonatomic, strong) UILabel *favorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation QAReplyDetailCell

- (void)setupUI {
    [super setupUI];
    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 7.5;
    self.headImageView.clipsToBounds = YES;
    [self.containerView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.containerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.headImageView.mas_centerY);
    }];
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.font = [UIFont systemFontOfSize:14];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.commentLabel.numberOfLines = 0;
    [self.containerView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(10);
    }];
    UIImageView *favorImageView = [[UIImageView alloc]init];
    favorImageView.image = [UIImage imageNamed:@"心"];
    [self.containerView addSubview:favorImageView];
    [favorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.commentLabel.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    self.favorImageView = favorImageView;
    
    self.favorLabel = [[UILabel alloc]init];
    self.favorLabel.font = [UIFont systemFontOfSize:11];
    self.favorLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.containerView addSubview:self.favorLabel];
    [self.favorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(favorImageView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(favorImageView.mas_centerY);
    }];
    self.timeLabel = [self.nameLabel clone];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(favorImageView.mas_centerY);
    }];
}

- (void)setItem:(QAReplyListRequestItem_Element *)item {
    _item = item;
    self.nameLabel.text = item.showUserName;
    self.commentLabel.text = item.answer;
    if (item.likeInfo.isLike.integerValue == 0) {
        self.favorImageView.image = [UIImage imageNamed:@"心"];
    }else {
        self.favorImageView.image = [UIImage imageNamed:@"红心"];
    }
    
    if (item.likeInfo.likeNum.integerValue >= 10000) {
        item.likeInfo.likeNum = @"9999+";
    }
    self.favorLabel.text = item.likeInfo.likeNum;
    
    self.timeLabel.text = item.updateTime;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"大头像"]];
}

@end
