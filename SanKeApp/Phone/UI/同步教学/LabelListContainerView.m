
//
//  LabelListContainerView.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LabelListContainerView.h"
#import "LabelViewController.h"
#import "GetBookInfoRequest.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
static const NSUInteger kTagBase = 10010;
static const CGFloat margin = 10;

@interface LabelListContainerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@end

@implementation LabelListContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    }
    return self;
}
#pragma mark
- (void)setupUI {
    self.topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1/[UIScreen mainScreen].scale)];
    self.topLineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self addSubview:self.topLineView];
    
    CGFloat y = CGRectGetMaxY(self.topLineView.frame);
    self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 44)];
    self.topScrollView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.topScrollView];
    
    y = CGRectGetMaxY(self.topScrollView.frame);
    self.bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, y - 1/[UIScreen mainScreen].scale, kScreenWidth, 1/[UIScreen mainScreen].scale)];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self addSubview:self.bottomLineView];
    
    y = CGRectGetMaxY(self.bottomLineView.frame);
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, self.frame.size.width, self.frame.size.height-self.topScrollView.frame.size.height)];
    self.bottomScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    [self addSubview:self.bottomScrollView];
}

- (void)setChildViewControllers:(NSArray<__kindof LabelViewController *> *)childViewControllers {
    for (UIView *v in self.topScrollView.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in self.bottomScrollView.subviews) {
        [v removeFromSuperview];
    }
    _childViewControllers = childViewControllers;
    
    __block CGFloat x = margin;
    
    [_childViewControllers enumerateObjectsUsingBlock:^(LabelViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = [self buttonWithTitle:obj.label.name];
        [b sizeToFit];
        CGFloat btnWidth = b.width;
        b.frame = CGRectMake(x, 0, btnWidth, self.topScrollView.frame.size.height);
        x = CGRectGetMaxX(b.frame) + margin;
        b.tag = kTagBase + idx;
        [self.topScrollView addSubview:b];
        if (idx < _childViewControllers.count - 1) {
            CGFloat lineHeight = 9.0f;  CGFloat lineWidth = 1.0f;
            CGFloat y = (self.topScrollView.bounds.size.height - lineHeight) / 2.0f;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(b.frame) + margin -lineWidth, y, lineWidth, lineHeight)];
            line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
            x = CGRectGetMaxX(line.frame) + margin;
            [self.topScrollView addSubview:line];
        }
    }];
    self.topScrollView.contentSize = CGSizeMake( x, 44);
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.childViewControllers.count, 0);
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"33333"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateSelected];
    b.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [b addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)chooseButtonAction:(UIButton *)sender {
    if (sender.selected) {
        BLOCK_EXEC(self.ClickTabButtonBlock);
    }
    for (UIButton *b in self.topScrollView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
        }
    }
    
    sender.selected = YES;
    NSInteger index = sender.tag - kTagBase;
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
    self.chooseViewController = self.childViewControllers[index];
    
    [self scrollTitleWithIndex:index];
    
    if (self.chooseViewController.view.superview)
        return;
    self.chooseViewController.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*index, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
    self.chooseViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.bottomScrollView addSubview:self.chooseViewController.view];
    
    YXProblemItem *item = [[YXProblemItem alloc]init];
    item.grade = [UserManager sharedInstance].userModel.stageID;
    item.subject = [UserManager sharedInstance].userModel.subjectID;
    item.volume_id = self.volum.volumID;
    item.unit_id = self.unit.unitID;
    item.course_id = self.course.courseID;
    item.tag_id = self.chooseViewController.label.labelID;
    item.type = YXRecordClickType;
    item.objType = @"filter_tbjx";
    [YXRecordManager addRecord:item];
}

- (void)scrollTitleWithIndex:(NSInteger)index{
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
    if ((self.topScrollView.contentSize.width - kScreenWidth) >= margin * 2 * self.childViewControllers.count) {
        CGFloat offsetMax = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;
        if (offsetx < 0) {
            offsetx = 0;
        }else if (offsetx > offsetMax){
            offsetx = offsetMax;
        }
        CGPoint offset = CGPointMake(offsetx, self.topScrollView.contentOffset.y);
        [self.topScrollView setContentOffset:offset animated:YES];
    }
}

- (void)setChooseIndex:(NSInteger)chooseIndex {
    _chooseIndex = chooseIndex;
    self.chooseViewController = self.childViewControllers[chooseIndex];
    if (chooseIndex < self.childViewControllers.count) {
        [self scrollTitleWithIndex:chooseIndex];
        for (UIButton *b in self.topScrollView.subviews) {
            if ([b isKindOfClass:[UIButton class]]) {
                b.selected = NO;
                if (b.tag-kTagBase == chooseIndex) {
                    [self chooseButtonAction:b];
                }
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self scrollTitleWithIndex:index];
    
    self.chooseViewController = self.childViewControllers[index];
    if (self.chooseViewController.view.superview) return;
    self.chooseViewController.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*index, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
    self.chooseViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.bottomScrollView addSubview:self.chooseViewController.view];
    
}


@end
