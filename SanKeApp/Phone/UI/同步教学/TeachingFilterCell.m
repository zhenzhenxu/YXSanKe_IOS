//
//  TeachingFilterCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingFilterCell.h"

@interface TeachingFilterCell()
@property (nonatomic, strong) UILabel *filterLabel;
@end


@implementation TeachingFilterCell

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

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.selectedBackgroundView = selectedBgView;
    self.filterLabel = [[UILabel alloc]init];
    self.filterLabel.font = [UIFont systemFontOfSize:13];
    self.filterLabel.numberOfLines = 0;
    [self.contentView addSubview:self.filterLabel];
    [self.filterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-20);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setFilterName:(NSString *)filterName{
    _filterName = filterName;
    self.filterLabel.text = filterName;
}

- (void)setIsCurrent:(BOOL)isCurrent{
    _isCurrent = isCurrent;
    if (isCurrent) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
