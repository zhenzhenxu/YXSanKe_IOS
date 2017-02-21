//
//  DataErrorView.m
//  TrainApp
//
//  Created by ZLL on 2016/11/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "DataErrorView.h"

@interface DataErrorView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *retryLabel;
@end

@implementation DataErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"哭脸"]];
    
    self.retryLabel = [[UILabel alloc]init];
    self.retryLabel.font = [UIFont systemFontOfSize:14];
    self.retryLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.retryLabel.text = @"数据错误";
    
    [self addSubview:self.contentView];
    [self addSubview:self.iconView];
    [self addSubview:self.retryLabel];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-55);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    [self.retryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconView.mas_bottom).offset(10);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.retryLabel.text = title;
}
@end
