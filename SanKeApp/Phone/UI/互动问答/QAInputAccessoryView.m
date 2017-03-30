//
//  QAInputAccessoryView.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAInputAccessoryView.h"

@interface QAInputAccessoryView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *albumButton;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, copy) HideBlock hideButtonBlock;
@property (nonatomic, copy) CameraBlock carmeraButtonBlock;
@property (nonatomic, copy) AlbumBlock albumButtonBlock;

@end


@implementation QAInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.topLine = [[UIView alloc]init];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hideButton setImage:[UIImage imageNamed:@"收起键盘"] forState:UIControlStateNormal];
    [self.hideButton addTarget:self action:@selector(hideButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraButton setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(cameraButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.albumButton setImage:[UIImage imageNamed:@"图片"] forState:UIControlStateNormal];
    [self.albumButton addTarget:self action:@selector(albumButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomLine = [self.topLine clone];
}

- (void)setupLayout {
    [self addSubview:self.topLine];
    [self addSubview:self.hideButton];
    [self addSubview:self.cameraButton];
    [self addSubview:self.albumButton];
    [self addSubview:self.bottomLine];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(1.0f);
    }];
    [self.hideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.albumButton.mas_left).offset(-10.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(1.0f);
    }];
}


- (void)hideButtonAction {
    BLOCK_EXEC(self.hideButtonBlock);
}

- (void)cameraButtonAction {
    BLOCK_EXEC(self.carmeraButtonBlock);
}

- (void)albumButtonAction {
    BLOCK_EXEC(self.albumButtonBlock);
}

- (void)setHideBlock:(HideBlock)block {
    self.hideButtonBlock = block;
}

- (void)setCameraBlock:(CameraBlock)block {
    self.carmeraButtonBlock = block;
}

- (void)setAlbumBlock:(AlbumBlock)block {
    self.albumButtonBlock = block;
}
@end
