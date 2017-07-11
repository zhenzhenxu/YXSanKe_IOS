//
//  FilterCell.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FilterCell.h"

@interface FilterCell()
@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation FilterCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [[UIButton alloc]init];
    UIImage *normalImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"e6e6e6"]];
    UIImage *selectedImage = [UIImage yx_imageWithColor:[[UIColor colorWithHexString:@"d65b4b"] colorWithAlphaComponent:0.2]];
    [self.itemButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.itemButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    self.itemButton.layer.cornerRadius = 3;
    self.itemButton.clipsToBounds = YES;
    [self.itemButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.itemButton addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(9, 15, 9, 15));
    }];
}

- (void)btnAction:(UIButton *)button {
    if (button.selected) {
        return;
    }
    BLOCK_EXEC(self.ActionBlock);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    self.itemButton.selected = isCurrent;
}

+ (CGSize)sizeForTitle:(NSString *)title collectionViewWidth:(CGFloat)width {
    CGSize size = [title boundingRectWithSize:CGSizeMake(width - 50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        return CGSizeMake(ceilf(size.width + 30), ceilf(size.height + 18));
}


@end
