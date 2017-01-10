//
//  YXShowWebMenuTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXShowWebMenuTableViewCell.h"

@interface YXShowWebMenuTableViewCell ()

@property (nonatomic, strong) UIImageView *menuImageView;
@property (nonatomic, strong) UILabel *menuTitleLabel;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, copy) NSString *normalImage;
@property (nonatomic, copy) NSString *highlightImage;

@end

@implementation YXShowWebMenuTableViewCell

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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        if (self.highlightImage) {
            self.menuImageView.image = [UIImage imageNamed:self.highlightImage];
            self.menuTitleLabel.textColor = [UIColor colorWithHexString:@"0067be"];
        }
    }
    else{
        if (self.normalImage) {
            self.menuImageView.image = [UIImage imageNamed:self.normalImage];
            self.menuTitleLabel.textColor = [UIColor colorWithHexString:@"334466"];
        }
    }
}

- (void)setupUI {
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.menuImageView = [[UIImageView alloc] init];
    //self.menuImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.menuImageView];
    
    self.menuTitleLabel = [[UILabel alloc] init];
    self.menuTitleLabel.text= @"双薪";
    self.menuTitleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.menuTitleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.menuTitleLabel];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"eeecf2"];
    [self.contentView addSubview:self.bottomView];
    
    [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.menuTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.menuImageView.mas_right).offset(7);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(self.menuTitleLabel.mas_left);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)configCellWithTitle:(NSString *)title imageString:(NSString *)imageName highLightImage:(NSString *)highLightImage isLastOne:(BOOL)isLastOne {
    self.menuTitleLabel.text = title;
    self.normalImage = imageName;
    self.highlightImage = highLightImage;
    self.menuImageView.image = [UIImage imageNamed:imageName];
    if (isLastOne) {
        self.bottomView.hidden = YES;
    } else {
        self.bottomView.hidden = NO;
    }
}

@end
