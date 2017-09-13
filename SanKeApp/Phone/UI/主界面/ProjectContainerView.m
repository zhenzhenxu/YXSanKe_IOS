//
//  ProjectContainerView.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectContainerView.h"
#import "CourseViewController.h"
#import "YXRecordManager.h"
#import "YXProblemItem.h"

static const NSUInteger kTagBase = 10086;
static const CGFloat margin = 0;
@interface ProjectContainerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *topSegmentView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@end

@implementation ProjectContainerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    }
    return self;
}
#pragma mark
- (void)setupUI {
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1/[UIScreen mainScreen].scale)];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self addSubview:topLineView];
    CGFloat y = CGRectGetMaxY(topLineView.frame);
    self.topSegmentView = [[UIView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 44)];
    self.topSegmentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topSegmentView];
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topSegmentView.frame), self.frame.size.width, self.frame.size.height-CGRectGetMaxY(self.topSegmentView.frame))];
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
    for (UIView *v in self.topSegmentView.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in self.bottomScrollView.subviews) {
        [v removeFromSuperview];
    }
    _childViewControllers = childViewControllers;
    
    __block CGFloat x = margin;
    
    [_childViewControllers enumerateObjectsUsingBlock:^(CourseViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = [self buttonWithTitle:obj.videoItem.name];
        [b sizeToFit];
        CGFloat btnWidth = (kScreenWidth - 2) / 3.0f;
        b.frame = CGRectMake(x, 0, btnWidth, self.topSegmentView.frame.size.height);
        x = CGRectGetMaxX(b.frame) + margin;
        b.tag = kTagBase + idx;
        [self.topSegmentView addSubview:b];
        if (idx == 0) {
            obj.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*idx, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
            obj.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.bottomScrollView addSubview:obj.view];
            self.bottomScrollView.contentOffset = CGPointMake(0, 0);
            b.selected = YES;
            b.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            self.chooseViewController = obj;
        }
        if (idx < _childViewControllers.count - 1) {
            CGFloat lineHeight = 9.0f;  CGFloat lineWidth = 1.0f;
            CGFloat y = (self.topSegmentView.bounds.size.height - lineHeight) / 2.0f;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(b.frame) + margin -lineWidth, y, lineWidth, lineHeight)];
            line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
            x = CGRectGetMaxX(line.frame) + margin;
            [self.topSegmentView addSubview:line];
        }
    }];
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.childViewControllers.count, self.bottomScrollView.frame.size.height);
}
- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateSelected];
    b.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [b addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}


- (void)chooseButtonAction:(UIButton *)sender {
    if (sender.selected) {
        BLOCK_EXEC(self.ClickTabButtonBlock);
    }
    for (UIButton *b in self.topSegmentView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
            b.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        }
    }
    
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    NSInteger index = sender.tag - kTagBase;
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
    self.chooseViewController = self.childViewControllers[index];
    
    [self recordUp];
    [self changeSelectedTitleWithIndex:index];
    
    if (self.chooseViewController.view.superview)
        return;
    self.chooseViewController.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*index, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
    self.chooseViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.bottomScrollView addSubview:self.chooseViewController.view];
    
}

- (void)recordUp{
    YXProblemItem *item = [YXProblemItem new];
    item.objType = @"section";
    item.grade = [UserManager sharedInstance].userModel.stageID;
    item.subject = [UserManager sharedInstance].userModel.subjectID;
    item.section_id = self.chooseViewController.videoItem.catID;
    item.volume_id = self.chooseViewController.recordItem.volume_id ?self.chooseViewController.recordItem.volume_id : [NSString string];
    item.type = YXRecordClickType;
    [YXRecordManager addRecord:item];
}

- (void)changeSelectedTitleWithIndex:(NSInteger)index{
    for (UIButton *b in self.topSegmentView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
            b.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            if (b.tag-kTagBase == index) {
                b.selected = YES;
                b.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self changeSelectedTitleWithIndex:index];
    
    self.chooseViewController = self.childViewControllers[index];
    [self recordUp];
    if (self.chooseViewController.view.superview) return;
    self.chooseViewController.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*index, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
    self.chooseViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.bottomScrollView addSubview:self.chooseViewController.view];
}

@end
