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
@property (nonatomic, copy) NSString *oldContent;
@end

@implementation QAQuestionCell

- (void)setupUI {
    [super setupUI];
    self.seperatorHeight = 5.f;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.numberOfLines = 2;
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
    
    UILabel *replyLabel = [[UILabel alloc]init];
    replyLabel.font = [UIFont systemFontOfSize:11];
    replyLabel.textColor = [UIColor colorWithHexString:@"999999"];
    replyLabel.text = @"回答";
    [self.containerView addSubview:replyLabel];
    [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    self.replyCountLabel = [[UILabel alloc]init];
    self.replyCountLabel.font = [UIFont systemFontOfSize:11];
    self.replyCountLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.containerView addSubview:self.replyCountLabel];
    [self.replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(replyLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(replyLabel.mas_centerY);
        make.width.mas_equalTo(40);
    }];
    
    UILabel *browseLabel = [replyLabel clone];
    browseLabel.text = @"浏览";
    [self.containerView addSubview:browseLabel];
    [browseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.replyCountLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(replyLabel.mas_centerY);
    }];
    
    self.browseCountLabel = [self.replyCountLabel clone];
    [self.containerView addSubview:self.browseCountLabel];
    [self.browseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(browseLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(replyLabel.mas_centerY);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(replyLabel.mas_centerY);
    }];
}

- (void)setItem:(QAQuestionListRequestItem_Element *)item {
    _item = item;
    self.titleLabel.text = item.title;
    
    if (![item.content isEqualToString:self.oldContent]) {
        NSMutableAttributedString  *attrStr = [[NSMutableAttributedString alloc] initWithData:[item.content?:@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.descLabel.attributedText = attrStr;
        self.descLabel.text = [self.descLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.oldContent = item.content;
    }
    
    if (item.answerNum.integerValue >= 10000) {
        item.answerNum = @"9999+";
    }
    self.replyCountLabel.text = item.answerNum;
    
    if (item.viewNum.integerValue >= 10000) {
        item.viewNum = @"9999+";
    }
    self.browseCountLabel.text = item.viewNum;
    
    NSString *time = [QAUtils formatTimeWithOriginal:item.updateTime];
    self.timeLabel.text = [NSString stringWithFormat:@"更新时间：%@",time];
}

@end
