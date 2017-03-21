//
//  QAQuestionCell.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionCell.h"

@interface QAQuestionCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *replyCountLabel;
@property (nonatomic, strong) UILabel *browseCountLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation QAQuestionCell

- (void)setupUI {
    [super setupUI];
    self.seperatorHeight = 5.f;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.descLabel.numberOfLines = 3;
    [self.containerView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(-10);
    }];
    
    UIImageView *replyImageView = [[UIImageView alloc]init];
    replyImageView.image = [UIImage imageNamed:@"回复"];
    [self.containerView addSubview:replyImageView];
    [replyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    self.replyCountLabel = [[UILabel alloc]init];
    self.replyCountLabel.font = [UIFont systemFontOfSize:11];
    self.replyCountLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.containerView addSubview:self.replyCountLabel];
    [self.replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(replyImageView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(replyImageView.mas_centerY);
        make.width.mas_equalTo(45);
    }];
    
    UIImageView *browseImageView = [[UIImageView alloc]init];
    browseImageView.image = [UIImage imageNamed:@"浏览"];
    [self.containerView addSubview:browseImageView];
    [browseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.replyCountLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(replyImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    self.browseCountLabel = [self.replyCountLabel clone];
    [self.containerView addSubview:self.browseCountLabel];
    [self.browseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(browseImageView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(replyImageView.mas_centerY);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(replyImageView.mas_centerY);
    }];
    
    [self setupMockData];
}

- (void)setupMockData {
    
    self.titleLabel.text = @"学生的阅读能力提高很慢，该怎么办？";
    self.descLabel.text = @"我在阅读教学中，已经很认真了，每篇课文都讲的很细，可是学生的阅读能力提高的还是很慢，甚至不愿意学习，问题究竟出在哪里呢？";
    self.replyCountLabel.text = @"566.6万";
    self.browseCountLabel.text = @"88787";
    self.timeLabel.text = @"提问时间：2017-03-09";
}

@end
