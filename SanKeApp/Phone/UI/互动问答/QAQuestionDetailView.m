//
//  QAQuestionDetailView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionDetailView.h"

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
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 2;
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
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
    
    self.replyDescLabel = [[UILabel alloc]init];
    self.replyDescLabel.font = [UIFont boldSystemFontOfSize:12];
    self.replyDescLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.replyDescLabel];
    [self.replyDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self setupMockData];
    self.headImageView.backgroundColor = [UIColor redColor];
    self.attachmentButton.backgroundColor = [UIColor redColor];
}

- (void)setupMockData {
    
    self.nameLabel.text = @"你瞅啥";
    self.titleLabel.text = @"学生的阅读能力提高很慢，该怎么办？";
    self.descLabel.text = @"我在阅读教学中，已经很认真了，每篇课文都讲的很细，可是学生的阅读能力提高的还是很慢，甚至不愿意学习，问题究竟出在哪里呢？";
    self.replyCountLabel.text = @"566.6万";
    self.browseCountLabel.text = @"88787";
    self.timeLabel.text = @"提问时间：2017-03-09";
    self.replyDescLabel.text = @"回答（100）";
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (type == 0) {
        [self.attachmentButton removeFromSuperview];
    }else if (type == 1) {
        [self.attachmentButton setImage:[UIImage imageNamed:@"_等待坊主点评-弹窗"] forState:UIControlStateNormal];
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
    }else if (type == 2) {
        self.attachmentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.attachmentButton.backgroundColor = [UIColor clearColor];
        [self.attachmentButton setTitle:@"@这是附件" forState:UIControlStateNormal];
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

- (void)btnAction {
    BLOCK_EXEC(self.AttachmentClickAction)
}

+ (CGFloat)heightForWidth:(CGFloat)width {
    QAQuestionDetailView *v = [[QAQuestionDetailView alloc]init];
    v.type = 1;
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [v addConstraint:widthFenceConstraint];
    // Auto layout engine does its math
    CGSize fittingSize = [v systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [v removeConstraint:widthFenceConstraint];
    return ceilf(fittingSize.height);
}

@end
