//
//  TeachingPhotoBrowser.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingPhotoBrowser.h"
#import "NavigationBarController.h"

NSString * const kTeachingPhotoBrowserExitNotification = @"kTeachingPhotoBrowserExitNotification";
NSString * const kPhotoIndexKey = @"kPhotoIndexKey";

@interface TeachingPhotoBrowser ()
@property(nonatomic, assign) BOOL deleteHidden;

@end

@implementation TeachingPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBack];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //设置导航栏文字颜色
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithHexString:@"ffffff"], NSForegroundColorAttributeName,
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navi Left
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
    // 标题样式
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithHexString:@"333333"], NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                     nil]];
    NSDictionary *infoDic = @{kPhotoIndexKey:@(self.currentIndex)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kTeachingPhotoBrowserExitNotification object:nil userInfo:infoDic];
}
@end
