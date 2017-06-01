//
//  PhotoBrowserController.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PhotoBrowserController.h"
#import "QASlideView.h"
#import "SlideImageView.h"
#import "MenuSelectionView.h"
#import "YXPromtController.h"

NSString * const kPhotoBrowserExitNotification = @"kPhotoBrowserExitNotification";
NSString * const kPhotoBrowserIndexKey = @"kPhotoBrowserIndexKey";

@interface PhotoBrowserController ()<QASlideViewDataSource, QASlideViewDelegate>

@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;
@property (nonatomic, strong) NSTimer *hideBarTimer;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, assign) BOOL barHidden;

@end

@implementation PhotoBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setupHideBarTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self invalidateTimer];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoBrowserExitNotification object:nil userInfo:@{kPhotoBrowserIndexKey : @(self.currentIndex)}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.slideView = [[QASlideView alloc] init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    self.slideView.currentIndex = self.currentIndex;
    [self.view addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    WEAK_SELF
    self.singleTap = [[UITapGestureRecognizer alloc] init];
    [self.slideView addGestureRecognizer:self.singleTap];
    [[self.singleTap rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self controlNavigationBarHidden];
    }];
}

#pragma mark - barHidden & timer
- (void)invalidateTimer {
    if (self.hideBarTimer) {
        [self.hideBarTimer invalidate];
        self.hideBarTimer = nil;
        self.barHidden = YES;
    }
}

- (void)setupHideBarTimer {
    [self invalidateTimer];
    self.hideBarTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(controlNavigationBarHidden) userInfo:nil repeats:NO];
    self.barHidden = NO;
}

- (void)controlNavigationBarHidden {
    [UIView animateWithDuration:0.35f animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:!self.barHidden withAnimation:UIStatusBarAnimationSlide];
        self.navigationController.navigationBarHidden = !self.barHidden;
    } completion:^(BOOL finished) {
        if (self.barHidden) {
            [self setupHideBarTimer];
        } else {
            [self invalidateTimer];
        }
    }];
}

#pragma mark - QASlideViewDataSource & QASlideViewDelegate
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.imageUrls.count;
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    SlideImageView *imageView = [[SlideImageView alloc] init];
    [imageView.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[index]]];
    return (QASlideItemBaseView *)imageView;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSlideViewDidSlide" object:nil];
    self.title = [NSString stringWithFormat:@"%@/%@",@(to + 1),@(self.imageUrls.count)];
    self.currentIndex = to;
    SlideImageView *slideImageView = (SlideImageView *)[slideView itemViewAtIndex:to];
    if (slideImageView) {
        [self.singleTap requireGestureRecognizerToFail:slideImageView.doubleTap];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
