//
//  UpgradeView.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpgradeView.h"

@interface UpgradeView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *upgradeLabel;

@property (nonatomic, copy) UpgradeButtonActionBlock upgradeBlock;
@end

@implementation UpgradeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"新版本"];
    imageView.userInteractionEnabled = YES;
    self.imageView = imageView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateHighlighted];
    cancelButton.layer.cornerRadius = 5;
    cancelButton.clipsToBounds = YES;
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancelButton;
    
    UILabel *upgradeLabel = [[UILabel alloc]init];
    upgradeLabel.layer.cornerRadius = 2;
    upgradeLabel.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    upgradeLabel.layer.borderWidth = 1;
    upgradeLabel.layer.masksToBounds = YES;
    upgradeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upgradeLabelClick)];
    [upgradeLabel addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    upgradeLabel.textColor= [UIColor colorWithHexString:@"ffffff"];
    upgradeLabel.text = @"立即升级";
    upgradeLabel.textAlignment = NSTextAlignmentCenter;
    upgradeLabel.font = [UIFont systemFontOfSize:12];
    self.upgradeLabel = upgradeLabel;
}

- (void)cancelButtonAction:(UIButton *)sender {
    DDLogDebug(@"取消升级按钮点击");
    [self.superview removeFromSuperview];
}

- (void)upgradeLabelClick {
    DDLogDebug(@"升级");
    BLOCK_EXEC(self.upgradeBlock);
}
- (void)setupLayout {
    [self addSubview:self.imageView];
    [self.imageView addSubview:self.cancelButton];
    [self.imageView addSubview:self.upgradeLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(256, 379));
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView).offset(45);
        make.right.equalTo(self.imageView).offset(-6);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.upgradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView).offset(-35);
        make.size.mas_equalTo(CGSizeMake(128, 30));
    }];
}

- (void)setIsForce:(BOOL)isForce {
    _isForce = isForce;
    if (isForce) {
        self.cancelButton.hidden = YES;
    }else {
        self.cancelButton.hidden = NO;
    }
}
- (void)setUpgradeButtonActionBlock:(UpgradeButtonActionBlock)block {
    self.upgradeBlock = block;
}
@end
