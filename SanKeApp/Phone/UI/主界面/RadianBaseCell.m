//
//  RadianBaseCell.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianBaseCell.h"
@interface RadianBaseCell ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation RadianBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBaseUI];
        [self setupBaseLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupBaseUI {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:self.topView];
    
    self.middleView = [[UIView alloc] init];
    self.middleView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:self.middleView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:self.bottomView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:self.lineView];
}

- (void)setupBaseLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.middleView.mas_top).offset(2.0f);
        make.height.mas_offset(7.0f);
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top).offset(2.0f);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(7.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
}

- (void)setCellStatus:(RadianBaseCellStatus)cellStatus {
    _cellStatus = cellStatus;
    self.lineView.hidden = YES;
    if (_cellStatus == RadianBaseCellStatus_Top) {
        self.topView.layer.cornerRadius = 2.0f;
        self.bottomView.layer.cornerRadius = 0.0f;
        self.lineView.hidden = NO;
    }else if (_cellStatus == RadianBaseCellStatus_Middle) {
        self.topView.layer.cornerRadius = 0.0f;
        self.bottomView.layer.cornerRadius = 0.0f;
        self.lineView.hidden = NO;
    }else if (_cellStatus == RadianBaseCellStatus_Bottom){
        self.topView.layer.cornerRadius = 0.0f;
        self.bottomView.layer.cornerRadius = 2.0f;
        self.lineView.hidden = YES;
    }else if (_cellStatus == (RadianBaseCellStatus_Top|RadianBaseCellStatus_Bottom)){
        self.topView.layer.cornerRadius = 2.0f;
        self.bottomView.layer.cornerRadius = 2.0f;
        self.lineView.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
