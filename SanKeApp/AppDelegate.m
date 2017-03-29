//
//  AppDelegate.m
//  SanKeApp
//
//  Created by niuzhaowang on 2016/12/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegate.h"
#import "YXTestViewController.h"
#import "YXDrawerViewController.h"
#import "ProjectMainViewController.h"
#import "LoginViewController.h"
#import "StageSubjectSelectViewController.h"
#import "YXRecordManager.h"
#import "SKTabBarController.h"
#import "QAMainViewController.h"
#import "TeachingMainViewController.h"
#import "YXSSOAuthManager.h"
#import "PersonalCenterViewController.h"

@interface AppDelegate ()
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setSignalReportEnabled:YES];
    [TalkingData sessionStarted:[SKConfigManager sharedInstance].TalkingDataAppID withChannelId:[SKConfigManager sharedInstance].channel];
    
    [GlobalUtils setupCore];
    [[YXSSOAuthManager sharedManager] registerWXApp];
    [[YXSSOAuthManager sharedManager] registerQQApp];
    //    [UpgradeManager checkForUpgrade];//当前版本暂不做升级界面
    //    [StageSubjectDataManager updateToLatestData];//当前版本的学科学段从本地取,不更新
    [self registerNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([SKConfigManager sharedInstance].testFrameworkOn.boolValue) {
        YXTestViewController *vc = [[YXTestViewController alloc] init];
        self.window.rootViewController = [[SKNavigationController alloc] initWithRootViewController:vc];
    }else{
        [self setupUI];
    }
    [self.window makeKeyAndVisible];
    [YXRecordManager startRegularReport];
    return YES;
}

- (void)setupUI {
    [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    if ([UserManager sharedInstance].loginStatus) {
        if (![UserManager sharedInstance].userModel.isTaged) {
            StageSubjectSelectViewController *selectVC = [[StageSubjectSelectViewController alloc]init];
            SKNavigationController *selectNavi = [[SKNavigationController alloc]initWithRootViewController:selectVC];
            self.window.rootViewController = selectNavi;
        }else {
            ProjectMainViewController *mainVC = [[ProjectMainViewController alloc]init];
            SKNavigationController *mainNavi = [[SKNavigationController alloc]initWithRootViewController:mainVC];
            mainNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"跟进教研" image:[UIImage imageNamed:@"跟进教研"] selectedImage:[UIImage imageNamed:@"跟进教研-点击"]];
            
            QAMainViewController *qaVC = [[QAMainViewController alloc]init];
            SKNavigationController *qaNavi = [[SKNavigationController alloc]initWithRootViewController:qaVC];
            qaNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"互动答疑" image:[UIImage imageNamed:@"互动问答"] selectedImage:[UIImage imageNamed:@"互动问答-点击"]];
            
            TeachingMainViewController *teachingVC = [[TeachingMainViewController alloc]init];
            SKNavigationController *teachingNavi = [[SKNavigationController alloc]initWithRootViewController:teachingVC];
            teachingNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"同步教学" image:[UIImage imageNamed:@"同步教学"] selectedImage:[UIImage imageNamed:@"同步教学-点击"]];
            
            PersonalCenterViewController *personalVC = [[PersonalCenterViewController alloc]init];
            SKNavigationController *personalNavi = [[SKNavigationController alloc]initWithRootViewController:personalVC];
            personalNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"个人中心" image:[UIImage imageNamed:@"个人中心"] selectedImage:[UIImage imageNamed:@"个人中心-点击"]];
            
            [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} forState:UIControlStateNormal];
            [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"4691a6"]} forState:UIControlStateSelected];
            [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
            
            SKTabBarController *tabBarVC = [[SKTabBarController alloc]init];
            tabBarVC.viewControllers = @[mainNavi,qaNavi,teachingNavi,personalNavi];
            tabBarVC.tabBar.tintColor = [UIColor colorWithHexString:@"4691a6"];
            self.window.rootViewController = tabBarVC;
        }
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        SKNavigationController *loginNavi = [[SKNavigationController alloc]initWithRootViewController:loginVC];
        if (self.window.rootViewController) {
            [self.window.rootViewController presentViewController:loginNavi animated:YES completion:^{
                self.window.rootViewController.view.hidden = YES;
            }];
        }else {
            self.window.rootViewController = loginNavi;
        }
    }
}

- (void)registerNotifications {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUserDidLoginNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupUI];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUserDidLogoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupUI];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([RecordManager sharedInstance].isActive) {
        WEAK_SELF
        self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^(void) {
            STRONG_SELF
            [self.backgroundTimer invalidate];
            self.backgroundTimer = nil;
            [self endBackgroundTask];
        }];
        [self.backgroundTimer invalidate];
        self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kRecordReportCompleteNotification object:nil]subscribeNext:^(id x) {
            STRONG_SELF
            [self.backgroundTimer invalidate];
            self.backgroundTimer = nil;
            if (self.backgroundTaskIdentifier) {
                [self endBackgroundTask];
            }
        }];
    }
}

- (void)endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    @weakify(self);
    dispatch_async(mainQueue, ^(void) {
        @strongify(self);
        if (self != nil){
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            // 销毁后台任务标识符
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

- (void)timerMethod:(NSTimer *)paramSender{
    // backgroundTimeRemaining 属性包含了程序留给的我们的时间
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX){
        DDLogDebug(@"Background Time Remaining = Undetermined");
    } else {
        DDLogDebug(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [GlobalUtils clearCore];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [YXSSOAuthManager handleOpenURL:url];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

// 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [YXSSOAuthManager handleOpenURL:url];
}

@end
