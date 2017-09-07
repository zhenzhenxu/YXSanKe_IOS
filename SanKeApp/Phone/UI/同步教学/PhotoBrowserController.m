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
#import "GetMarkDetailRequest.h"
#import "MarkDetailView.h"

NSString * const kPhotoBrowserExitNotification = @"kPhotoBrowserExitNotification";
NSString * const kPhotoBrowserIndexKey = @"kPhotoBrowserIndexKey";

@interface PhotoBrowserController ()<QASlideViewDataSource, QASlideViewDelegate>

@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;
@property (nonatomic, strong) NSTimer *hideBarTimer;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, assign) BOOL barHidden;

@property (nonatomic, strong) GetMarkDetailRequest *request;

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
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoBrowserExitNotification object:nil userInfo:@{kPhotoBrowserIndexKey : @(self.currentIndex)}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
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
    }
}

- (void)setupHideBarTimer {
    [self invalidateTimer];
    self.hideBarTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(controlNavigationBarHidden) userInfo:nil repeats:NO];
    self.barHidden = NO;
}

- (void)controlNavigationBarHidden {
    self.barHidden = !self.barHidden;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:self.barHidden animated:NO];
    if (self.barHidden) {
        [self invalidateTimer];
    } else {
        [self setupHideBarTimer];
    }
}

- (BOOL)prefersStatusBarHidden {
    return self.barHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark - showMarkerDetail
- (void)fetchMarkDetailWithMarkBtn:(UIButton *)markBtn isLineBtn:(BOOL)isLineBtn currentModel:(TeachingPageModel *)model {
    GetBookInfoRequestItem_Marker *marker = model.mark.marker[markBtn.tag - markBtn.tag / 1000 * 1000];
    GetBookInfoRequestItem_Marker_Item *currentMark = isLineBtn ? marker.lines[markBtn.tag / 1000] : marker.icons[markBtn.tag / 1000];
    
    if (isEmpty(currentMark.textInfo)) {
        [self.request stopRequest];
        self.request = [[GetMarkDetailRequest alloc]init];
        self.request.marker_id = marker.markerID;
        if (isLineBtn) {
            self.request.line_id = currentMark.itemID;
        } else {
            self.request.icon_id = currentMark.itemID;
        }
        [self startLoading];
        WEAK_SELF
        [self.request startRequestWithRetClass:[GetMarkDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            if (error) {
                [self showToast:error.localizedDescription];
                return ;
            }
            GetMarkDetailRequestItem *item = (GetMarkDetailRequestItem *)retItem;
            if (isEmpty(item.data)) {
                [self showToast:@"暂无内容"];
                return;
            }
            currentMark.textInfo = item.data.textInfo;
            [self showMarkerDetailWithTextInfo:currentMark.textInfo markBtn:markBtn];
        }];
    } else {
        [self showMarkerDetailWithTextInfo:currentMark.textInfo markBtn:markBtn];
    }
}

- (void)showMarkerDetailWithTextInfo:(NSString *)textInfo markBtn:(UIButton *)markBtn {
    MarkDetailView *markDetailView = [[MarkDetailView alloc] init];
    markDetailView.textInfo = textInfo;
    markDetailView.markBtn = markBtn;

    AlertView *alert = [[AlertView alloc] init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = markDetailView;
    [alert showWithLayout:nil];
}

#pragma mark - QASlideViewDataSource & QASlideViewDelegate
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.currentVolumDataArray.count;
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    SlideImageView *imageView = [[SlideImageView alloc] init];
    imageView.model = self.currentVolumDataArray[index];
    imageView.markView.markerBtnBlock = ^(UIButton *markBtn, BOOL isLineBtn) {
        [self fetchMarkDetailWithMarkBtn:markBtn isLineBtn:isLineBtn currentModel:self.currentVolumDataArray[index]];
    };
    return (QASlideItemBaseView *)imageView;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSlideViewDidSlide" object:nil];
    self.title = [NSString stringWithFormat:@"%@/%@", @(to + 1), @(self.currentVolumDataArray.count)];
    self.currentIndex = to;
    SlideImageView *slideImageView = [slideView itemViewAtIndex:to];
    if (slideImageView) {
        [self.singleTap requireGestureRecognizerToFail:slideImageView.doubleTap];
    }
}

- (void)slideViewDidReachMostLeft:(QASlideView *)slideView {
    [self showToast:@"已翻到首页"];
}

- (void)slideViewDidReachMostRight:(QASlideView *)slideView {
    [self showToast:@"已翻到末页"];
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
