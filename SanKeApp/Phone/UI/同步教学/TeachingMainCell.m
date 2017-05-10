//
//  TeachingMainCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingMainCell.h"

@interface TeachingMainCell ()
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, copy) SelectedButtonActionBlock buttonActionBlock;
@end

@implementation TeachingMainCell

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
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];

    self.contentImageView = [[UIImageView alloc]init];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.contentImageView];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedAction)];
    [self.contentView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    
    
    self.errorLabel = [[UILabel alloc]init];
    self.errorLabel.text = @"图片加载失败";
    [self.contentImageView addSubview:self.errorLabel];
    self.errorLabel.hidden = YES;
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentImageView.mas_centerX);
        make.centerY.equalTo(self.contentImageView.mas_centerY);
    }];
}
- (void)selectedAction {
    BLOCK_EXEC(self.buttonActionBlock);;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.errorLabel.hidden = NO;
        }else {
            self.errorLabel.hidden = YES;
        }
    }];
}

- (void)setIndex:(NSInteger *)index {
    _index = index;
}
- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block {
    self.buttonActionBlock = block;
}

@end
