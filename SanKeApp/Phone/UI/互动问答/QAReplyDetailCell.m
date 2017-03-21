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
@property (nonatomic, strong) UILabel *favorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation QAReplyDetailCell

- (void)setupUI {
    [super setupUI];
    self.headImageView = [[UIImageView alloc]init];
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
    
    self.headImageView.backgroundColor = [UIColor redColor];
    [self setupMock];
}

- (void)setupMock {
    self.nameLabel.text = @"你瞅啥";
    self.commentLabel.text = @"北京市规划国土委相关负责人介绍，同时存在上述三个方面问题，又无法提供合法审批证明文件的，不动产登记部门停止办理不动产登记手续。也就是说，擅自将不具有实际居住意义的异常形态房屋进行交易并要求按“住宅”用途进行转移登记，属于擅自改变规划用途，不符合登记要求，因此不予办理不动产登记。";
    self.favorLabel.text = @"123";
    self.timeLabel.text = @"2017-03-09 11:03:30";
}

@end
