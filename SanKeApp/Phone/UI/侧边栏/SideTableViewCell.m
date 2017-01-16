//
//  SideTableViewCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SideTableViewCell.h"
#import "SideTableViewModel.h"

@interface SideTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *sideLabel;

@end


@implementation SideTableViewCell

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
    }
    return self;
}

- (void)setupUI {
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.selectedBackgroundView = selectedBgView;
    
    self.iconImageView = [[UIImageView alloc] init];
    
    self.sideLabel = [[UILabel alloc] init];
    self.sideLabel.font = [UIFont systemFontOfSize:15];
    self.sideLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.sideLabel];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.sideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(self.iconImageView);
    }];
}

- (void)setModel:(SideTableViewModel *)model {
    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.icon];
    self.sideLabel.text = model.title;
}
@end
