//
//  TeachingFilterBackgroundView.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingFilterBackgroundView.h"

@interface TeachingFilterBackgroundView()
@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, assign) CGFloat triangleX;
@end

@implementation TeachingFilterBackgroundView

- (instancetype)initWithFrame:(CGRect)frame triangleX:(CGFloat)x{
    if (self = [super initWithFrame:frame]) {
        self.triangleX = x;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"切换项目名称的弹窗-尖角"];
    imageView.frame = CGRectMake(self.triangleX-9, 0, 18, 8);
    [self addSubview:imageView];
    
    self.contentBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, self.bounds.size.width, self.bounds.size.height-8)];
    self.contentBgView.backgroundColor = [UIColor whiteColor];
    self.contentBgView.layer.cornerRadius = 2.0f;
    self.contentBgView.clipsToBounds = YES;
    [self addSubview:self.contentBgView];
}

@end
