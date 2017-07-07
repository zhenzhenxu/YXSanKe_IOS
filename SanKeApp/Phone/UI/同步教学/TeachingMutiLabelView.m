//
//  TeachingMutiLabelView.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingMutiLabelView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
static const NSUInteger kTagBase = 10086;
static const CGFloat margin = 10;


@interface TeachingMutiLabelView ()
@property (nonatomic, copy) ClickTabButtonBlock buttonActionBlock;
@end


@implementation TeachingMutiLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
}

- (void)setTabArray:(NSArray<GetBookInfoRequestItem_Label *> *)tabArray {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    _tabArray = tabArray;
    
    __block CGFloat x = margin;
    
    [tabArray enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Label *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = [self buttonWithTitle:obj.name];
        [b sizeToFit];
        CGFloat btnWidth = b.width;
        b.frame = CGRectMake(x, 0, btnWidth, self.frame.size.height);
        x = CGRectGetMaxX(b.frame) + margin;
        b.tag = kTagBase + idx;
        [self addSubview:b];
        if (idx == 0) {
            self.contentOffset = CGPointMake(0, 0);
        }
        CGFloat lineHeight = 9.0f;  CGFloat lineWidth = 1.0f;
        CGFloat y = (self.bounds.size.height - lineHeight) / 2.0f;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(b.frame) + margin -lineWidth, y, lineWidth, lineHeight)];
        line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        x = CGRectGetMaxX(line.frame) + margin;
        if (idx < tabArray.count - 1 || x < self.bounds.size.width) {
            [self addSubview:line];
        } else {
            x = CGRectGetMinX(line.frame);
        }
    }];
    self.contentSize = CGSizeMake( x, 44);
}

- (void)setCurrentTabIndex:(NSInteger)currentTabIndex {
    _currentTabIndex = currentTabIndex;
    [self scrollTitleWithIndex:currentTabIndex];
}
- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateHighlighted];
    b.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [b addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)chooseButtonAction:(UIButton *)sender {
    NSInteger index = sender.tag - kTagBase;
    [self scrollTitleWithIndex:index];
    self.currentTabIndex = index;
    BLOCK_EXEC(self.buttonActionBlock);
}

- (void)scrollTitleWithIndex:(NSInteger)index{
    CGFloat offsetx = 0.0f;
    for (UIButton *b in self.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
            if (b.tag-kTagBase == index) {
                offsetx = b.center.x - self.frame.size.width * 0.5;
            }
        }
    }
    if ((self.contentSize.width - kScreenWidth) >= margin * 2 * self.tabArray.count) {
        CGFloat offsetMax = self.contentSize.width - self.frame.size.width;
        if (offsetx < 0) {
            offsetx = 0;
        }else if (offsetx > offsetMax){
            offsetx = offsetMax;
        }
        CGPoint offset = CGPointMake(offsetx, self.contentOffset.y);
        [self setContentOffset:offset animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self scrollTitleWithIndex:index];
}

-(void)setClickTabButtonBlock:(ClickTabButtonBlock)block {
    self.buttonActionBlock = block;
}


@end
