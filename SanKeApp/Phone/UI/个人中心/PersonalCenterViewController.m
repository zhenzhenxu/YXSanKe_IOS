//
//  PersonalCenterViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterModel.h"
#import "PersonalCenterCell.h"
#import "AboutViewController.h"
#import "ChangePasswordViewController.h"
#import "SettingViewController.h"
#import "PersonalHeaderView.h"
#import "YXImagePickerController.h"
#import "MenuSelectionView.h"

@interface PersonalCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PersonalHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)setupNavgationBar {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"ffffff"]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}
- (void)setupUI {
    self.headerView = [[PersonalHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 260.f * kScreenHeightScale(1.0f))];
    self.headerView.model = [UserManager sharedInstance].userModel;
    WEAK_SELF
    [self.headerView setEditBlock:^{
        STRONG_SELF
        [self.view endEditing:YES];
        DDLogDebug(@"%@修改头像",[self class]);
        [self changeHeadPortrait];
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"PersonalCenterCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    self.imagePickerController = [[YXImagePickerController alloc] init];
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

- (void)setupObserver {
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUpdateHeadPortraitSuccessNotification object:nil]subscribeNext:^(id x) {
        DDLogDebug(@"%@修改头像",[self class]);
        self.headerView.model = [UserManager sharedInstance].userModel;
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUpdateUserNameSuccessNotification object:nil]subscribeNext:^(id x) {
        DDLogDebug(@"%@更新用户名",[self class]);
        self.headerView.model = [UserManager sharedInstance].userModel;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCenterCell" forIndexPath:indexPath];
    PersonalCenterModel *model = self.dataArray[indexPath.row];
    [cell configTitle:model.title hasButton:model.hasButton];
    WEAK_SELF
    [cell setSelectedButtonActionBlock:^{
        STRONG_SELF
        if ([model.title isEqualToString:@"修改密码"]) {
            ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([model.title isEqualToString:@"清空缓存"]) {
            // 清sdwebimage
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            
            // 清缓存
            NSString *dp = [BaseDownloader downloadFolderPath];
            [[NSFileManager defaultManager] removeItemAtPath:dp error:nil];
            [self showToast:@"清除缓存成功"];
        }
        if ([model.title isEqualToString:@"去AppStore打分"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1207703516"]];
        }
        if ([model.title isEqualToString:@"关于我们"]) {
            AboutViewController *vc = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([model.title isEqualToString:@"设置"]) {
            SettingViewController *vc = [[SettingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([model.title isEqualToString:@"退出"]) {
            [UserManager sharedInstance].loginStatus = NO;
        }
    }];
    return cell;
}

#pragma mark - TabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - change HeadPortrait
- (void)changeHeadPortrait {
    self.menuSelectionView = [[MenuSelectionView alloc]init];
    self.menuSelectionView.dataArray = @[
                                         @"拍照",
                                         @"从相册选择",
                                         @"取消"
                                         ];
    CGFloat height = [self.menuSelectionView totalHeight];
    [self.view addSubview:self.menuSelectionView];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
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
            WEAK_SELF
            [self.imagePickerController presentFromViewController:self pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage *selectedImage) {
                STRONG_SELF
                [self updateHeadPortrait:selectedImage];
            }];
        }
            break;
        case 1:{
            WEAK_SELF
            [self.imagePickerController presentFromViewController:self pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
                STRONG_SELF
                [self updateHeadPortrait:selectedImage];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateHeadPortrait:(UIImage *)image {
    DDLogDebug(@"更新头像%@",image);
    if (!image) {
        return;
    }
    [self startLoading];
    WEAK_SELF
    [MineDataManager updateHeadPortrait:image completeBlock:^(NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        }
        self.headerView.model = [UserManager sharedInstance].userModel;
    }];
}

@end
