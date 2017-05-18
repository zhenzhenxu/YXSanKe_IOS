//
//  TeachingPhotoBrowser.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingPhotoBrowser.h"
#import "NavigationBarController.h"
#import "MenuSelectionView.h"
#import "MWPhotoBrowserPrivate.h"
#import "YXPromtController.h"

NSString * const kTeachingPhotoBrowserExitNotification = @"kTeachingPhotoBrowserExitNotification";
NSString * const kPhotoIndexKey = @"kPhotoIndexKey";

@interface TeachingPhotoBrowser ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;
@end

@implementation TeachingPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBack];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithHexString:@"ffffff"], NSForegroundColorAttributeName,
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   nil];
    [self addLongPressToSaveImage];
}

- (void)setupLeftBack{
    [self setupLeftWithImageNamed:@"返回按钮" highlightImageNamed:@"返回按钮"];
}

- (void)setupLeftWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName{
    WEAK_SELF
    [NavigationBarController setLeftWithNavigationItem:self.navigationItem imageName:imageName highlightImageName:highlightImageName action:^{
        STRONG_SELF
        [self naviLeftAction];
    }];
}

- (void)naviLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithHexString:@"333333"], NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                     nil]];
    NSDictionary *infoDic = @{kPhotoIndexKey:@(self.currentIndex)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kTeachingPhotoBrowserExitNotification object:nil userInfo:infoDic];
}

#pragma mark - LongPressToSaveImage
- (void)addLongPressToSaveImage
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToSaveImage:)];
    longPressGesture.delegate = self;
    [self.view addGestureRecognizer:longPressGesture];
}

- (void)longPressToSaveImage:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self handleSaveImage];
    }
}

- (void)handleSaveImage {
    self.menuSelectionView = [[MenuSelectionView alloc]init];
    self.menuSelectionView.dataArray = @[
                                         @"保存图片",
                                         @"取消"
                                         ];
    CGFloat height = [self.menuSelectionView totalHeight];
    [self.view addSubview:self.menuSelectionView];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    alert.contentView = self.menuSelectionView;
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.top.equalTo(view.mas_bottom).offset(0);
                make.height.mas_equalTo(height);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.equalTo(view.mas_bottom).offset(0);
            make.height.mas_equalTo(height);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.height.mas_equalTo(height);
                make.bottom.equalTo(view);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [self.menuSelectionView setChooseMenuBlock:^(NSInteger index) {
        STRONG_SELF
        [alert hide];
        [self chooseMenuWithIndex:index];
    }];
}

- (void)chooseMenuWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            id <MWPhoto> photo = [self photoAtIndex:self.currentIndex];
            UIImage *img = [self imageForPhoto:photo];
            [self saveImage:img];
        }
            break;
        case 1:{
            return;
        }
            break;
            
        default:
            break;
    }
}

- (void)saveImage:(UIImage *)image {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            [YXPromtController showToast:@"相册权限受限\n请在设置-隐私-相册中开启" inView:self.view];
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                    {
                        [YXPromtController showToast:@"相册权限受限\n请在设置-隐私-相册中开启" inView:self.view];
                    }
                    else if (status == PHAuthorizationStatusAuthorized)
                    {
                        [self loadImageFinished:image];
                    }
                });
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:
            [self loadImageFinished:image];
            break;
        default:
            break;
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    if (image == nil) {
        [YXPromtController showToast:@"保存失败" inView:self.view];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [YXPromtController showToast:@"保存失败" inView:self.view];
    }else{
        [YXPromtController showToast:@"已经保存成功" inView:self.view];
    }
}

@end
