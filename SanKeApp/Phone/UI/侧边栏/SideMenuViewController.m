//
//  SideMenuViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SideHeaderView.h"
#import "MineViewController.h"
#import "SideTableViewCell.h"
#import "SideTableViewModel.h"

@interface SideMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SideHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SideMenuViewController

- (void)dealloc {
    DDLogDebug(@"%@释放啦",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupLayout];
    [self setupTabeleViewData];
}

- (void)setupUI {
    self.headerView = [[SideHeaderView alloc]init];
    self.headerView.model = [UserManager sharedInstance].userModel;
    WEAK_SELF
    [self.headerView setEditButtonActionBlock:^{
        STRONG_SELF
        DDLogDebug(@"点击跳转到个人信息设置");
        MineViewController *mineVc = [[MineViewController alloc]init];
        [self.navigationController pushViewController:mineVc animated:YES];
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 45;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[SideTableViewCell class] forCellReuseIdentifier:@"SideTableViewCell"];
}

- (void)setupLayout {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(88);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setupTabeleViewData {
    NSMutableArray *dataArray = [NSMutableArray array];
    SideTableViewModel *model1 = [SideTableViewModel modelWithIcon:@"清除缓存" title:@"清空缓存"];
    SideTableViewModel *model2 = [SideTableViewModel modelWithIcon:@"app-store" title:@"去AppStore打分"];
    SideTableViewModel *model3 = [SideTableViewModel modelWithIcon:@"退出" title:@"退出"];
    [dataArray addObject:model1];
    [dataArray addObject:model2];
    [dataArray addObject:model3];
    
    self.dataArray = dataArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            // 清sdwebimage
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            
            // 清缓存
            NSString *dp = [BaseDownloader downloadFolderPath];
            [[NSFileManager defaultManager] removeItemAtPath:dp error:nil];
            [self showToast:@"清除缓存成功"];
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1207703516"]];
        }
            break;
        case 2:
        {
            [UserManager sharedInstance].loginStatus = NO;
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 26.5;
    } else {
        return 19;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
