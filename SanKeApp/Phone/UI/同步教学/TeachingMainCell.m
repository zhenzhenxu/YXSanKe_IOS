//
//  TeachingMainCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingMainCell.h"

@interface TeachingMainCell ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, copy) SelectedButtonActionBlock buttonActionBlock;
@end

@implementation TeachingMainCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.contentImageView = [[UIImageView alloc]init];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentImageView.backgroundColor = [UIColor whiteColor];
    self.contentImageView.userInteractionEnabled = YES;
    [self addSubview:self.contentImageView];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedAction)];
    [self addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    
    self.markView = [[MarkView alloc] init];
    [self.contentImageView addSubview:self.markView];
    self.contentImageView.clipsToBounds = YES;
}

- (void)selectedAction {
    BLOCK_EXEC(self.buttonActionBlock);
}

- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block {
    self.buttonActionBlock = block;
}

- (void)setModel:(TeachingPageModel *)model {
    _model = model;
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.pageUrl] placeholderImage:[UIImage imageNamed:@"图片加载中"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.contentImageView.image = [UIImage imageNamed:@"图片加载失败"];
        }else {
            self.contentImageView.contentMode = UIViewContentModeScaleToFill;
            self.contentImageView.image = image;
            self.markView.mark = model.mark;
            [self setNeedsLayout];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.markView.frame = self.contentImageView.bounds;
}

@end
