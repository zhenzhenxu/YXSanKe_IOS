//
//  TeachingContentsCell.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingContentsCell.h"

@interface TeachingContentsCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLineView;

@end

@implementation TeachingContentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setupUI
- (void)setupUI {
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.topLineView.mas_bottom).offset(18);
        make.bottom.mas_equalTo(-18);
    }];
}

#pragma mark - setters
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsIndented:(BOOL)isIndented {
    _isIndented = isIndented;
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(isIndented ? 15 : 0);
        make.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(isIndented ? 41 : 15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.topLineView.mas_bottom).offset(18);
        make.bottom.mas_equalTo(-18);
    }];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"4691a6"];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    } else {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    }
}

@end
