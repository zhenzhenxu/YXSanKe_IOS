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

@interface YXImageViewController()
@property (nonatomic, strong) ImageZoomView *imageView;
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


@end
