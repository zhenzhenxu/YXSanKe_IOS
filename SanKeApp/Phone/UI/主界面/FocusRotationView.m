//
//  FocusRotationView.m
//  SanKeApp
//
//  Created by 郑小龙 on 2018/1/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "FocusRotationView.h"
#import <StyledPageControl/StyledPageControl.h>
@interface FocusRotationView () <UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) StyledPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation FocusRotationView
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.currentPage = 0;
        self.widthFloat = [UIScreen mainScreen].bounds.size.width;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setItemViewArray:(NSArray *)itemViewArray {
    _itemViewArray = itemViewArray;
    [self.timer invalidate];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(self.widthFloat);
    }];
    self.scrollView.contentSize = CGSizeMake(3 * self.widthFloat, 20);
    self.scrollView.contentOffset = CGPointMake(self.widthFloat, 0);
    [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(14.0f * 20.0f * itemViewArray.count);
    }];
    self.pageControl.numberOfPages = (int)self.itemViewArray.count;
    self.pageControl.hidden = NO;
    self.currentPage = 0;
    [self reconfigScrollContent];
}
#pragma mark - setupUI
- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    self.pageControl = [[StyledPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.userInteractionEnabled = NO;
    [self.pageControl setPageControlStyle:PageControlStyleDefault];
    [self.pageControl setCoreNormalColor:[UIColor colorWithHexString:@"4691a6"]];
    [self.pageControl setCoreSelectedColor:[UIColor blackColor]];
    self.pageControl.hidden = YES;
    [self addSubview:self.pageControl];
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] init];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    WEAK_SELF
    [[tapGestureRecognize rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *sender) {
        STRONG_SELF
        if (self.currentPage < self.itemViewArray.count) {
            BLOCK_EXEC(self.focusRotationClickBlock,self.currentPage);
        }
    }];
    [self.scrollView addGestureRecognizer:tapGestureRecognize];
}
- (void)setupLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(self.widthFloat);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10.0f);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(20.0f);
    }];
}
- (void)reconfigScrollContent {
    if (isEmpty(self.itemViewArray)) {
        return;
    }
    NSInteger index = (self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    if (0 == index) {
        self.currentPage = [self previousPage];
    }
    if (2 == index) {
        self.currentPage = [self nextPage];
    }
    self.pageControl.currentPage = (int)self.currentPage;

    for (UIView *v in self.scrollView.subviews) {
        [v removeFromSuperview];
    }
    
    UIView *preView = [self.itemViewArray objectAtIndex:[self previousPage]];
    UIView *curView = [self.itemViewArray objectAtIndex:self.currentPage];
    UIView *nextView = [self.itemViewArray objectAtIndex:[self nextPage]];
    if (self.itemViewArray.count < 2) {
        preView = [self copyView:curView];
        nextView = [self copyView:curView];
    }
    if (self.itemViewArray.count < 3) {
        preView = [self copyView:nextView];
    }
    [self.scrollView addSubview:preView];
    [self.scrollView addSubview:curView];
    [self.scrollView addSubview:nextView];
    
    [preView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_offset(self.widthFloat);
    }];
    [curView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(self.widthFloat);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_offset(self.widthFloat);
    }];
    [nextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(self.widthFloat * 2);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_offset(self.widthFloat);
    }];
    self.scrollView.contentOffset = CGPointMake(self.widthFloat, 0);
    [self retimer];
}
- (void)timerAction {
    [self.scrollView setContentOffset:CGPointMake(2*_scrollView.bounds.size.width, 0) animated:YES];
    [self reconfigScrollContent];
}

- (void)retimer {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
}

- (NSInteger)previousPage {
    return (self.currentPage - 1 + (int)[self.itemViewArray count]) % [self.itemViewArray count];
}

- (NSInteger)nextPage {
    return (self.currentPage + 1 + (int)[self.itemViewArray count]) % [self.itemViewArray count];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reconfigScrollContent];
    DDLogDebug(@"%@",NSStringFromCGPoint(self.scrollView.contentOffset));
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self reconfigScrollContent];
}
- (UIView*)copyView:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end
