//
//  CourseResCell.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseResCell.h"

@interface CourseResCell ()
@property (nonatomic, strong) UIImageView *expandIcon;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *contentBgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@end

@implementation CourseResCell

- (void)setupUI {
    [super setupUI];
    
    self.contentBgButton = [[UIButton alloc]init];
    self.contentBgButton.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.contentBgButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentBgButton addSubview:self.titleLabel];
}

#pragma mark - Setters
- (void)setTitle:(NSString *)title {
    _title = title;
    if (self.level == 0) {
        self.titleLabel.text = title;
        [self setupUIForFirstLevel];
        return;
    } else {
        [self setupUIForSecondLevel];
    }
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(kScreenWidth - 86, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    CGFloat labelHeight = titleSize.height;
    if (labelHeight / self.titleLabel.font.lineHeight > 1) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5.f];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
        self.titleLabel.attributedText = attributedString1;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-23-10-35);
        }];
    }else {
        self.titleLabel.text = title;
    }
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
}

- (void)setupUIForFirstLevel {
    [self.accessoryImageView removeFromSuperview];
    [self.containerView addSubview:self.expandIcon];
    [self.containerView addSubview:self.lineView];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(46);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.expandIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView.mas_left).mas_offset(-8);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-2);
        make.left.mas_equalTo(self.lineView.mas_right).mas_offset(1);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.right.mas_equalTo(-35);
        make.centerY.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
    }];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setupUIForSecondLevel {
    [self.expandIcon removeFromSuperview];
    [self.lineView removeFromSuperview];
    [self.contentBgButton addSubview:self.accessoryImageView];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-20-10-35);
    }];
    
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.contentBgButton.layer.cornerRadius = 2.0f;
    self.contentBgButton.clipsToBounds = YES;
}

#pragma mark - Getters
- (UIImageView *)expandIcon {
    if (_expandIcon == nil) {
        _expandIcon = [[UIImageView alloc]init];
        _expandIcon.image = [UIImage imageNamed:@"收回"];
    }
    return _expandIcon;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    }
    return _lineView;
}

- (UIImageView *)accessoryImageView {
    if (_accessoryImageView == nil) {
        _accessoryImageView = [[UIImageView alloc] init];
        _accessoryImageView.contentMode = UIViewContentModeScaleAspectFill;
        _accessoryImageView.image = [UIImage imageNamed:@"单元解读icon"];
    }
    return _accessoryImageView;
}

#pragma mark - Actions
- (void)contentBgButtonAction {
    if (self.level == 0) {
        return;
    }
    BLOCK_EXEC(self.clickBlock, self);
}

@end
