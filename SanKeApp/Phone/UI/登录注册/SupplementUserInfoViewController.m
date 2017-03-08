//
//  SupplementUserInfoViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SupplementUserInfoViewController.h"
#import "UserImageTableViewCell.h"
#import "UserInfoTableViewCell.h"
#import "UserInfoPickerView.h"
#import "UserSubjectStageInfoPicker.h"
#import "UserAreaInfoPicker.h"
#import "ErrorView.h"
#import "EmptyView.h"
#import "MineUserModel.h"
#import "YXRecordManager.h"
#import "YXProblemItem.h"
#import "YXImagePickerController.h"
#import "MenuSelectionView.h"

@interface SupplementUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MineUserModel *userModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UserInfoPickerView *userInfoPickerView;
@property (nonatomic, strong) UserAreaInfoPicker *areaInfoPicker;

@end

@implementation SupplementUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self setupNavgationBar];
    [self setupUI];
    [self setupInfoPicker];
    [self LoadData];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:@"UserInfoTableViewCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 45, 10));
    }];
    
    self.userInfoPickerView = [[UserInfoPickerView alloc]init];
    [self.navigationController.view addSubview:self.userInfoPickerView];
    [self.userInfoPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.userInfoPickerView hidePickerView];
    WEAK_SELF
    [self.userInfoPickerView setConfirmButtonActionBlock:^{
        STRONG_SELF
        [self updateSelectedInfo];
    }];
    
    UIButton *confirmButton = [[UIButton alloc]init];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[[UIColor colorWithHexString:@"d65b4b"] colorWithAlphaComponent:0.2]] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"d65b4b"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ignoreButton = [[UIButton alloc]init];
    ignoreButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [ignoreButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"d65b4b"]] forState:UIControlStateNormal];
    [ignoreButton setTitle:@"忽略" forState:UIControlStateNormal];
    [ignoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ignoreButton addTarget:self action:@selector(ignoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    [self.view addSubview:ignoreButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.top.equalTo(self.tableView.mas_bottom);
        make.bottom.mas_equalTo(-10.0f);
    }];
    [ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton.mas_right);
        make.top.equalTo(confirmButton);
        make.right.equalTo(self.tableView);
        make.bottom.equalTo(confirmButton);
        make.width.mas_equalTo(confirmButton.mas_width);
    }];
    
}

- (void)setupInfoPicker {
    self.areaInfoPicker = [[UserAreaInfoPicker alloc]init];
    self.areaInfoPicker.model = [AreaDataManager areaModel];
}

- (void)LoadData {
    self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
    [self.tableView reloadData];
}

#pragma mark -update Picker Selected Info
- (void)updateSelectedInfo {
    //    WEAK_SELF
    //    if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserSubjectStageInfoPicker class]]) {
    //        [self.subjectStageInfoPicker updateStageWithCompleteBlock:^(NSError *error) {
    //            STRONG_SELF
    //            if (error) {
    //                [self showToast:error.localizedDescription];
    //                return;
    //            }
    //            [self updateStageSubjectInfo];//接入真实数据后用
    //            //            [self updateMockStageSubjectInfo];//mock数据
    //        }];
    //    }else if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserAreaInfoPicker class]]) {
    //        [self.areaInfoPicker updateAreaWithCompleteBlock:^(NSError *error) {
    //            STRONG_SELF
    //            if (error) {
    //                [self showToast:error.localizedDescription];
    //                return;
    //            }
    //            [self updateAreaInfo];//待接入真实数据后使用
    //            //            [self updateMockAreaInfo];//mock数据
    //        }];
    //    }
}

- (void)updateAreaInfo {
    self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
    DDLogDebug(@"最终结果地区:%@-%@-%@",self.userModel.province.name,self.userModel.city.name,self.userModel.district.name);
    NSIndexPath *areaIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[areaIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateMockAreaInfo {
    AreaModel *model = [AreaDataManager areaModel];
    UserAreaSelectedInfoItem *item = [self.areaInfoPicker selectedInfoItem];
    Area *province = [[Area alloc]init];
    Area *city = [[Area alloc]init];
    Area *county = [[Area alloc]init];
    if (model.areas.count > 0) {
        province = model.areas[item.selectedProvinceRow];
        if (province.subAreas.count > 0) {
            city = province.subAreas[item.selectedCityRow];
            if (city.subAreas.count > 0) {
                county = city.subAreas[item.selectedCountyRow];
            }else {
                county = nil;
            }
        }else {
            city = nil;
        }
    }else {
        province = nil;
    }
    UserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *area = [NSString string];
    if (!isEmpty(province)) {
        area = province.name;
        if (!isEmpty(city)) {
            area = [area stringByAppendingString:city.name];
            if (!isEmpty(county)) {
                area = [area stringByAppendingString:county.name];
            }
        }
    }
    [cell configTitle:@"地区" content:area];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        NSString *area = [self configAreaString];
        [cell configTitle:@"地区" content:area];
        WEAK_SELF
        [cell setSelectedButtonActionBlock:^{
            STRONG_SELF
            DDLogDebug(@"点击选择地区");
            self.userInfoPickerView.pickerView.dataSource = self.areaInfoPicker;
            self.userInfoPickerView.pickerView.delegate = self.areaInfoPicker;
            [self.userInfoPickerView showPickerView];
            [self.areaInfoPicker resetSelectedProvinceDataWithUserModel:self.userModel];
            [self showProvinceListPicker];
        }];
    }else if (indexPath.row == 1) {
        [cell configTitle:@"身份" content:self.userModel.stage.name];
        WEAK_SELF
        [cell setSelectedButtonActionBlock:^{
            STRONG_SELF
            DDLogDebug(@"点击选择学段学科");
        }];
    }else if (indexPath.row == 2) {
        [cell configTitle:@"性别" content:self.userModel.stage.name];
        WEAK_SELF
        [cell setSelectedButtonActionBlock:^{
            STRONG_SELF
            DDLogDebug(@"点击选择学段学科");
        }];
    }else if (indexPath.row == 3) {
        [cell configTitle:@"入职年份" content:self.userModel.stage.name];
        WEAK_SELF
        [cell setSelectedButtonActionBlock:^{
            STRONG_SELF
            DDLogDebug(@"点击选择学段学科");
        }];
    }
    return cell;
}
#pragma mark - TabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 50.0f;
}
#pragma mark -  Button Actions
- (void)confirmAction {
    
}

- (void)ignoreAction {
    
}

#pragma mark - InfoPicker
- (void)showProvinceListPicker {
    UserAreaSelectedInfoItem *item = [self.areaInfoPicker selectedInfoItem];
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:item.selectedProvinceRow inComponent:0 animated:NO];
    [self.userInfoPickerView.pickerView selectRow:item.selectedCityRow inComponent:1 animated:NO];
    [self.userInfoPickerView.pickerView selectRow:item.selectedCountyRow inComponent:2 animated:NO];
}
#pragma  mark - configAreaSring
-(NSString *)configAreaString {
    NSString *area = [NSString string];
    if (!isEmpty(self.userModel.province)) {
        area = self.userModel.province.name;
        if (!isEmpty(self.userModel.city)) {
            area = [area stringByAppendingString:self.userModel.city.name];
            if (!isEmpty(self.userModel.district)) {
                area = [area stringByAppendingString:self.userModel.district.name];
            }
        }
    }
    return area;
}
@end
