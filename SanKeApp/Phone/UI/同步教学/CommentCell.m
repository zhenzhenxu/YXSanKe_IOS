//
//  CommentCell.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentTimeLabel;
@property (nonatomic, strong) UILabel *commentContentLabel;

@end

@implementation CommentCell

- (void)setupUI {
    [super setupUI];
    self.seperatorHeight = 5.0f;
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = 7.5f;
    self.avatarImageView.clipsToBounds = YES;
    [self.containerView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10.0f);
        make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.containerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10.0f);
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
        make.right.mas_lessThanOrEqualTo(-10.0f);
    }];
    
    self.commentTimeLabel = [self.nameLabel clone];
    self.commentTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.commentTimeLabel];
    [self.commentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.0f);
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
    }];
    
    self.commentContentLabel = [[UILabel alloc] init];
    self.commentContentLabel.font = [UIFont systemFontOfSize:12.0f];
    self.commentContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.commentContentLabel.numberOfLines = 0;
    [self.containerView addSubview:self.commentContentLabel];
    [self.commentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_left);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(10.0f);
        make.right.bottom.mas_equalTo(-10.0f);
    }];
}

- (void)setItem:(ResourceAskListItem_Element *)item {
    _item = item;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:item.userIcon] placeholderImage:[UIImage imageNamed:@"大头像"]];
    self.nameLabel.text = item.userTrueName;
    self.commentTimeLabel.text = [QAUtils formatTimeWithOriginal:item.BuildDate];
    self.commentContentLabel.text = item.content;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
