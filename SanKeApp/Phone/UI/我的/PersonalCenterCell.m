//
//  PersonalCenterCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PersonalCenterCell.h"


@interface PersonalCenterCell ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) SelectedButtonActionBlock buttonActionBlock;
@end

@implementation PersonalCenterCell

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
    
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedButton setImage:[UIImage imageNamed:@"学科"] forState:UIControlStateNormal];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedAction)];
    [self.contentView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}
- (void)selectedAction {
    BLOCK_EXEC(self.buttonActionBlock);;
}
- (void)setupLayout {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectedButton];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
    }];
}

- (void)configTitle:(NSString *)title hasButton:(BOOL)hasButton {
     self.titleLabel.text = title;
    if (hasButton) {
        self.selectedButton.hidden = NO;
    }else {
        self.selectedButton.hidden = YES;
    }
}

- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block {
    self.buttonActionBlock = block;
}

@end
