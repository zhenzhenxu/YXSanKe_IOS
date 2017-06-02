//
//  YXImageViewController.m
//  YanXiuApp
//
//  Created by Lei Cai on 6/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXImageViewController.h"
#import "NavigationBarController.h"
#import "ImageZoomView.h"
#import "MenuSelectionView.h"
#import "YXPromtController.h"

@interface YXImageViewController()
@property (nonatomic, strong) ImageZoomView *imageView;
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;
@end

@implementation YXImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftBack];
    self.navigationItem.rightBarButtonItems = [NavigationBarController barButtonItemsForView:self.favorWrapper.favorButton];

    ImageZoomView *imageView = [[ImageZoomView alloc] init];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.left.right.mas_equalTo(@0);
    }];
    
    if (self.image) {
        imageView.image = self.image;
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToSaveImage:)];
    [imageView addGestureRecognizer:longPress];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)naviLeftAction{
    [self dismissViewControllerAnimated:NO completion:nil];
    SAFE_CALL(self.exitDelegate, browserExit);
}

#pragma mark - longPress & saveImage
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
            [self saveImage:self.image];
            break;
        case 1:
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
