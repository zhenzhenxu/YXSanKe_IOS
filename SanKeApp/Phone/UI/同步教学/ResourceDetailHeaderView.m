//
//  ResourceDetailHeaderView.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceDetailHeaderView.h"
#import "ResourceDetailRequest.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface ResourceDetailHeaderView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UILabel *browseCountLabel;
@property (nonatomic, strong) UILabel *publishTimeLabel;
@property (nonatomic, strong) UILabel *availableCountLabel;
@property (nonatomic, strong) UIButton *resourceButton;

@end

@implementation ResourceDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 2.0f;
    [self addSubview:self.containerView];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = 7.5f;
    self.avatarImageView.clipsToBounds = YES;
    [self.containerView addSubview:self.avatarImageView];
    
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.usernameLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.containerView addSubview:self.usernameLabel];
    
    self.titlelabel = [[UILabel alloc] init];
    self.titlelabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titlelabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titlelabel.numberOfLines = 0;
    [self.containerView addSubview:self.titlelabel];
    
    self.browseCountLabel = [self.usernameLabel clone];
    [self.containerView addSubview:self.browseCountLabel];
    
    self.publishTimeLabel = [self.usernameLabel clone];
    self.publishTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview: self.publishTimeLabel];
    
    self.availableCountLabel = [[UILabel alloc] init];
    self.availableCountLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.availableCountLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.availableCountLabel];
    
    self.resourceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resourceButton addTarget:self action:@selector(attachmentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.resourceButton];
}

- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0f);
        make.left.mas_equalTo(10.0f);
        make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10.0f);
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
        make.right.mas_lessThanOrEqualTo(-10.0f);
    }];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_left);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(10.0f);
        make.right.mas_lessThanOrEqualTo(-10.0f);
    }];
    
    [self.browseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_left);
        make.bottom.mas_equalTo(-12.0f);
        make.right.mas_lessThanOrEqualTo(self.publishTimeLabel.mas_left).offset(-10.0f);
    }];
    
    [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.0f);
        make.centerY.mas_equalTo(self.browseCountLabel.mas_centerY);
    }];
    
    [self.availableCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(10.0f);
        make.left.mas_equalTo(10.0f);
        make.bottom.mas_equalTo(-10.0f);
    }];
}

- (void)attachmentButtonAction {
    BLOCK_EXEC(self.resourceButtonBlock)
}

- (void)setItem:(ResourceDetailRequestItem_Data *)item {
    _item = item;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"大头像"]];
    self.usernameLabel.text = item.userName;
    self.titlelabel.text = item.resName;
    self.browseCountLabel.text = [NSString stringWithFormat:@"浏览 %@", item.readNum];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:item.createTime / 1000.0f];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    NSString *createTime = [dateFormatter stringFromDate:date];
    self.publishTimeLabel.text = createTime;
    self.availableCountLabel.text = @"评论";
    
    [self setupAttachmentButton];
}

- (void)setupAttachmentButton {
    CGFloat widgetHeight = 0.0f;
    YXFileType fileType = [QAFileTypeMappingTable fileTypeWithString:self.item.resType];
    if (fileType == YXFileTypePhoto) {
        widgetHeight = (SCREENWIDTH - 40.0f) * 524.0f / 670.0f;
        [self.resourceButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.item.resPreviewUrl] forState:UIControlStateNormal];
    } else if (fileType == YXFileTypeVideo) {
        widgetHeight = (SCREENWIDTH - 40.0f) * 400.0f / 670.0f;
        [self.resourceButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.item.resPreviewUrl] forState:UIControlStateNormal];
        [self.resourceButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    } else if (fileType == YXFileTypeDoc) {
        widgetHeight = 14.0f;
        NSMutableAttributedString *textUrlStr = [[NSMutableAttributedString alloc] initWithString:self.item.resName];
        [textUrlStr setAttributes:@{
                                    NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"4691a6"],
                                    NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                    } range:NSMakeRange(0, textUrlStr.length)];
        [self.resourceButton setAttributedTitle:textUrlStr forState:UIControlStateNormal];
    } else {
        // 不支持的格式
        widgetHeight = 0.0f;
    }
    
    self.frame = CGRectMake(0.0f, 0.0f, SCREENWIDTH, widgetHeight + 137.0f);
    [self.containerView addSubview:self.resourceButton];
    
    [self.resourceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_left).offset(10.0f);
        make.top.mas_equalTo(self.containerView.mas_top).offset(59.0f);
        if (fileType == YXFileTypeDoc) {
            make.right.mas_lessThanOrEqualTo(self.containerView.mas_right).offset(-10.0f);
        } else {
            make.right.mas_equalTo(self.containerView.mas_right).offset(-10.0f);
        }
        make.height.mas_equalTo(widgetHeight);
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
