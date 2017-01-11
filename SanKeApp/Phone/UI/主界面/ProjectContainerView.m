//
//  ProjectContainerView.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectContainerView.h"
#import "CourseViewController.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
static const NSUInteger kTagBase = 10086;
@interface ProjectContainerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@end

@implementation ProjectContainerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
#pragma mark
- (void)setupUI {
    self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.topScrollView.backgroundColor = [UIColor colorWithHexString:@"d65b4b"];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.topScrollView];
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topScrollView.frame.origin.y+self.topScrollView.frame.size.height, self.frame.size.width, self.frame.size.height-self.topScrollView.frame.size.height)];
    self.bottomScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    [self addSubview:self.bottomScrollView];
}

- (void)setChildViewControllers:(NSArray<__kindof CourseViewController *> *)childViewControllers {
    _childViewControllers = childViewControllers;
    for (UIView *v in self.topScrollView.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in self.bottomScrollView.subviews) {
        [v removeFromSuperview];
    }
    
    [_childViewControllers enumerateObjectsUsingBlock:^(CourseViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = [self buttonWithTitle:obj.tabItem.name];
        CGFloat btnWidth = kScreenWidth / 4.0f;
        b.frame = CGRectMake(btnWidth*idx, 0, btnWidth, self.topScrollView.frame.size.height);
        b.tag = kTagBase + idx;
        [self.topScrollView addSubview:b];
        if (idx == 0) {
            obj.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*idx, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
            obj.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.bottomScrollView addSubview:obj.view];
            b.selected = YES;
        }
        if (idx < _childViewControllers.count - 1) {
            CGFloat lineHeight = 9.0f;  CGFloat lineWidth = 1.0f;
            CGFloat y = (self.topScrollView.bounds.size.height - lineHeight) / 2.0f;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(b.frame.origin.x+b.frame.size.width - lineWidth, y, lineWidth, lineHeight)];
            line.backgroundColor = [UIColor colorWithHexString:@"999999"];
            [self.topScrollView addSubview:line];
        }
    }];
}
- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"fda89d"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [b addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}


- (void)chooseButtonAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *b in self.topScrollView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
        }
    }
    sender.selected = YES;
    NSInteger index = sender.tag - kTagBase;
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
    CourseViewController *newsVc = self.childViewControllers[index];
    if (newsVc.view.superview) return;
    newsVc.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*index, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
    newsVc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.bottomScrollView addSubview:newsVc.view];
}

- (void)layoutSubviews{
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.childViewControllers.count, self.bottomScrollView.frame.size.height);
    self.topScrollView.contentSize = CGSizeMake( kScreenWidth / 4.0f * self.childViewControllers.count, 44);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    CGFloat offsetx = 0.0f;
    for (UIButton *b in self.topScrollView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
            if (b.tag-kTagBase == index) {
                b.selected = YES;
               offsetx = b.center.x - self.topScrollView.frame.size.width * 0.5;
            }
        }
    }
    CGFloat offsetMax = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.topScrollView.contentOffset.y);
    [self.topScrollView setContentOffset:offset animated:YES];
    
    CourseViewController *newsVc = self.childViewControllers[index];
    if (newsVc.view.superview) return;
    newsVc.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*index, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
    newsVc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.bottomScrollView addSubview:newsVc.view];    
}




@end
