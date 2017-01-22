//
//  UserInfoTableViewCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@interface UserInfoTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) SelectedButtonActionBlock buttonActionBlock;
@end


@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
    
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedButton setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    [self.selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
}

- (void)setupLayout {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.selectedButton];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectedButton.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.contentLabel);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
    }];
}

- (void)configTitle:(NSString *)title content:(NSString *)content {
    self.titleLabel.text = title;
    self.contentLabel.text = content;
}

- (void)selectedButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.buttonActionBlock);
}

- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block {
    self.buttonActionBlock = block;
}
@end
