//
//  RadianCornerBaseCell.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianCornerBaseCell.h"

@interface RadianCornerBaseCell()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation RadianCornerBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 2;
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
    }];
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:topView];
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(topView.mas_height);
    }];
    self.topView = topView;
    self.bottomView = bottomView;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
}

- (void)updateWithCurrentIndex:(NSInteger)index total:(NSInteger)total {
    if (index==0 && total==1) {
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
    }else if (index==0 && total>1) {
        self.topView.hidden = YES;
        self.bottomView.hidden = NO;
    }else if (index==total-1 && total>1) {
        self.topView.hidden = NO;
        self.bottomView.hidden = YES;
    }else {
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
    }
}

- (void)setSeperatorHeight:(CGFloat)seperatorHeight {
    _seperatorHeight = seperatorHeight;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-seperatorHeight);
    }];
}
@end
