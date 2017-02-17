//
//  AppDelegate.m
//  SanKeApp
//
//  Created by niuzhaowang on 2016/12/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegate.h"
#import "YXTestViewController.h"
#import "SideMenuViewController.h"
#import "YXDrawerViewController.h"
#import "ProjectMainViewController.h"
#import "LoginViewController.h"
#import "StageSubjectSelectViewController.h"
#import "YXRecordManager.h"

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
    [UpgradeManager checkForUpgrade];
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
    
    [YXRecordManager addRecordWithType:YXRecordPlateType];
    return YES;
}

- (void)setupUI {
    if ([UserManager sharedInstance].loginStatus) {
        if (![UserManager sharedInstance].userModel.isTaged) {
            StageSubjectSelectViewController *selectVC = [[StageSubjectSelectViewController alloc]init];
            SKNavigationController *selectNavi = [[SKNavigationController alloc]initWithRootViewController:selectVC];
            self.window.rootViewController = selectNavi;
        }else {
            SideMenuViewController *menuVC = [[SideMenuViewController alloc]init];
            ProjectMainViewController *mainVC = [[ProjectMainViewController alloc]init];
            SKNavigationController *mainNavi = [[SKNavigationController alloc]initWithRootViewController:mainVC];
            
            YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
            drawerVC.drawerViewController = menuVC;
            drawerVC.paneViewController = mainNavi;
            drawerVC.drawerWidth = [UIScreen mainScreen].bounds.size.width * 600/750.0f;
            self.window.rootViewController = drawerVC;
        }
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        SKNavigationController *loginNavi = [[SKNavigationController alloc]initWithRootViewController:loginVC];
        if (self.window.rootViewController) {
            [self.window.rootViewController presentViewController:loginNavi animated:YES completion:nil];
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


@end
