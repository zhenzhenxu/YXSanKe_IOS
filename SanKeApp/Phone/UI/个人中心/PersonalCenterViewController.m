//
//  PersonalCenterViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "UserImageTableViewCell.h"
#import "PersonalCenterModel.h"
#import "PersonalCenterCell.h"
#import "AboutViewController.h"
#import "ChangePasswordViewController.h"
#import "SettingViewController.h"

@interface PersonalCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation PersonalCenterViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [UserManager sharedInstance].userModel.truename;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavgationBar];
    [self setupUI];
    [self setupTabeleViewData];
    [self setupObserver];
    // Do any additional setup after loading the view.
}

- (void)setupNavgationBar {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"ffffff"]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UserImageTableViewCell class] forCellReuseIdentifier:@"UserImageTableViewCell"];
    [self.tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"PersonalCenterCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)setupObserver {
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUpdateHeadPortraitSuccessNotification object:nil]subscribeNext:^(id x) {
        DDLogDebug(@"%@修改头像",[self class]);
        UserImageTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setModel:[UserManager sharedInstance].userModel];
        cell.canEdit = NO;
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUpdateUserNameSuccessNotification object:nil]subscribeNext:^(id x) {
        DDLogDebug(@"%@更新用户名",[self class]);
        self.navigationItem.title = [UserManager sharedInstance].userModel.truename;
    }];
}
- (void)setupTabeleViewData {
    PersonalCenterModel *model0 = [PersonalCenterModel modelWithTitle:@"修改密码" hasButton:YES];
    PersonalCenterModel *model1 = [PersonalCenterModel modelWithTitle:@"清空缓存" hasButton:NO];
    PersonalCenterModel *model2 = [PersonalCenterModel modelWithTitle:@"去AppStore打分" hasButton:NO];
    PersonalCenterModel *model3 = [PersonalCenterModel modelWithTitle:@"关于我们" hasButton:YES];
    PersonalCenterModel *model4 = [PersonalCenterModel modelWithTitle:@"设置" hasButton:YES];
    PersonalCenterModel *model5 = [PersonalCenterModel modelWithTitle:@"退出" hasButton:NO];
    
    NSMutableArray *dataArray;
    if ([UserManager sharedInstance].userModel.isAnonymous) {
        dataArray = [NSMutableArray arrayWithObjects:model1,model2,model3,model4,model5, nil];
    }else {
        dataArray = [NSMutableArray arrayWithObjects:model0,model1,model2,model3,model4,model5, nil];
    }
    self.dataArray = dataArray.copy;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UserImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserImageTableViewCell" forIndexPath:indexPath];
        cell.model = [UserManager sharedInstance].userModel;
        cell.canEdit = NO;
        return cell;
    }else {
        PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCenterCell" forIndexPath:indexPath];
        PersonalCenterModel *model = self.dataArray[indexPath.row];
        [cell configTitle:model.title hasButton:model.hasButton];
        WEAK_SELF
        [cell setSelectedButtonActionBlock:^{
            STRONG_SELF
            if ([model.title isEqualToString:@"修改密码"]) {
                DDLogDebug(@"修改密码");
                ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([model.title isEqualToString:@"清空缓存"]) {
                DDLogDebug(@"清空缓存");
                // 清sdwebimage
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                
                // 清缓存
                NSString *dp = [BaseDownloader downloadFolderPath];
                [[NSFileManager defaultManager] removeItemAtPath:dp error:nil];
                [self showToast:@"清除缓存成功"];
            }
            if ([model.title isEqualToString:@"去AppStore打分"]) {
                DDLogDebug(@"去AppStore打分");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1207703516"]];
            }
            if ([model.title isEqualToString:@"关于我们"]) {
                DDLogDebug(@"关于我们");
                AboutViewController *vc = [[AboutViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([model.title isEqualToString:@"设置"]) {
                DDLogDebug(@"设置");
                SettingViewController *vc = [[SettingViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([model.title isEqualToString:@"退出"]) {
                DDLogDebug(@"退出");
                [UserManager sharedInstance].loginStatus = NO;
            }
        }];
        return cell;
    }
}

#pragma mark - TabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    }else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
@end
