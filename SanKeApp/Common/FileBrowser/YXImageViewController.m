//
//  YXImageViewController.m
//  YanXiuApp
//
//  Created by Lei Cai on 6/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXImageViewController.h"
#import "NavigationBarController.h"

@interface YXImageViewController()
@end

@implementation YXImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftBack];
    self.navigationItem.rightBarButtonItems = [NavigationBarController barButtonItemsForView:self.favorWrapper.favorButton];

    UIImageView *imageView = [[UIImageView alloc] init];
    
    if (self.image) {
        imageView.image = self.image;
    }
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.left.right.mas_equalTo(@0);
    }];
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
