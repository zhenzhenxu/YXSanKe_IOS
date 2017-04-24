//
//  QAQuestionDetailView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionDetailView.h"

typedef NS_ENUM(NSUInteger, QAAttachmentType) {
    QAAttachmentType_None,
    QAAttachmentType_Image,
    QAAttachmentType_Other
};

@interface QAQuestionDetailView()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *replyImageView;
@property (nonatomic, strong) UILabel *replyCountLabel;
@property (nonatomic, strong) UILabel *browseCountLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *replyDescLabel;
@property (nonatomic, strong) UIButton *attachmentButton;
@end

@implementation QAQuestionDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 2;
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.numberOfLines = 0;
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(8);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.descLabel.numberOfLines = 0;
    [self.containerView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(-10);
    }];
    
    self.attachmentButton = [[UIButton alloc]init];
    [self.attachmentButton setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    self.attachmentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.attachmentButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.attachmentButton];
    
    UIImageView *replyImageView = [[UIImageView alloc]init];
    replyImageView.image = [UIImage imageNamed:@"回复"];
    self.replyImageView = replyImageView;
    [self.containerView addSubview:replyImageView];
    [replyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(8);
    }];
    self.replyCountLabel = [[UILabel alloc]init];
    self.replyCountLabel.font = [UIFont systemFontOfSize:11];
    self.replyCountLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.containerView addSubview:self.replyCountLabel];
    [self.replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(replyImageView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(replyImageView.mas_centerY);
        make.width.mas_equalTo(40);
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
    
    self.replyDescLabel = [[UILabel alloc]init];
    self.replyDescLabel.font = [UIFont boldSystemFontOfSize:12];
    self.replyDescLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.replyDescLabel];
    [self.replyDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)setItem:(QAQuestionDetailRequestItem_Ask *)item {
    _item = item;
    self.nameLabel.text = item.showUserName;
    self.titleLabel.text = item.title;
    self.descLabel.text = item.content;
    
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
    self.replyDescLabel.text = [NSString stringWithFormat:@"回答（%@）",item.answerNum];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"大头像"]];
    
    QAAttachmentType type;
    if (isEmpty(item.attachmentList)) {
        type = QAAttachmentType_None;
    }else {
        QAQuestionDetailRequestItem_Attachment *attach = item.attachmentList.firstObject;
        YXFileType fileType = [QAFileTypeMappingTable fileTypeWithString:attach.fileType];
        if (fileType == YXFileTypePhoto) {
            type = QAAttachmentType_Image;
        }else {
            type = QAAttachmentType_Other;
        }
    }
    [self relayoutAttachmentViewWithType:type];
}

- (void)relayoutAttachmentViewWithType:(QAAttachmentType)type {
    if (type == QAAttachmentType_None) {
        [self.attachmentButton removeFromSuperview];
    }else if (type == QAAttachmentType_Image) {
        QAQuestionDetailRequestItem_Attachment *attach = self.item.attachmentList.firstObject;
        [self.attachmentButton sd_setImageWithURL:[NSURL URLWithString:attach.thumbnail] forState:UIControlStateNormal placeholderImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f2f2"]]];
        self.attachmentButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.attachmentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        self.attachmentButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
        [self.attachmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        [self.replyImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.top.mas_equalTo(self.attachmentButton.mas_bottom).mas_offset(8);
        }];
    }else {
        QAQuestionDetailRequestItem_Attachment *attach = self.item.attachmentList.firstObject;
        NSString *title = [NSString stringWithFormat:@"%@",attach.resName];
        self.attachmentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.attachmentButton.backgroundColor = [UIColor clearColor];
        [self.attachmentButton setTitle:title forState:UIControlStateNormal];
        [self.attachmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(2);
        }];
        [self.replyImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.top.mas_equalTo(self.attachmentButton.mas_bottom).mas_offset(2);
        }];
    }
}

- (void)updateWithReplyCount:(NSString *)replyCount browseCount:(NSString *)browseCount updateTime:(NSString *)updateTime{
    if (!isEmpty(replyCount)) {
        if (replyCount.integerValue >= 10000) {
            replyCount = @"9999+";
        }
        self.replyCountLabel.text = replyCount;
        self.replyDescLabel.text = [NSString stringWithFormat:@"回答（%@）",replyCount];
    }
    if (!isEmpty(browseCount)) {
        if (browseCount.integerValue >= 10000) {
            browseCount = @"9999+";
        }
        self.browseCountLabel.text = browseCount;
    }
    if (!isEmpty(updateTime)) {
        NSString *time = [QAUtils formatTimeWithOriginal:updateTime];
        self.timeLabel.text = [NSString stringWithFormat:@"更新时间：%@",time];
    }
}

- (void)btnAction {
    BLOCK_EXEC(self.AttachmentClickAction)
}

+ (CGFloat)heightForWidth:(CGFloat)width item:(QAQuestionDetailRequestItem_Ask *)item {
    QAQuestionDetailView *v = [[QAQuestionDetailView alloc]init];
    v.item = item;
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [v addConstraint:widthFenceConstraint];
    // Auto layout engine does its math
    CGSize fittingSize = [v systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [v removeConstraint:widthFenceConstraint];
    return ceilf(fittingSize.height);
}

@end
