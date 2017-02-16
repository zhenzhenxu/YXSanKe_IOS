//
//  MineViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineViewController.h"
#import "UserImageTableViewCell.h"
#import "UserInfoTableViewCell.h"
#import "UserInfoPickerView.h"
#import "UserSubjectStageInfoPicker.h"
#import "UserAreaInfoPicker.h"
#import "ErrorView.h"
#import "EmptyView.h"
#import "MineUserModel.h"
@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MineUserModel *userModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UserInfoPickerView *userInfoPickerView;
@property (nonatomic, strong) UserSubjectStageInfoPicker *subjectStageInfoPicker;
@property (nonatomic, strong) UserAreaInfoPicker *areaInfoPicker;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupInfoPicker];
    [self LoadData];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UserImageTableViewCell class] forCellReuseIdentifier:@"UserImageTableViewCell"];
    [self.tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:@"UserInfoTableViewCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
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
}

- (void)setupInfoPicker {
    self.subjectStageInfoPicker = [[UserSubjectStageInfoPicker alloc]init];
    self.subjectStageInfoPicker.stageAndSubjectItem = [StageSubjectDataManager dataForStageAndSubject];
    
    self.areaInfoPicker = [[UserAreaInfoPicker alloc]init];
    self.areaInfoPicker.model = [AreaDataManager areaModel];
}

- (void)LoadData {
    self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
    [self.tableView reloadData];
}

#pragma mark -update Picker Selected Info
- (void)updateSelectedInfo {
    WEAK_SELF
    if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserSubjectStageInfoPicker class]]) {
        [self.subjectStageInfoPicker updateStageWithCompleteBlock:^(NSError *error) {
            STRONG_SELF
            if (error) {
                [self showToast:error.localizedDescription];
                return;
            }
            [self updateStageSubjectInfo];//接入真实数据后用
//            [self updateMockStageSubjectInfo];//mock数据
        }];
    }else if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserAreaInfoPicker class]]) {
        [self.areaInfoPicker updateAreaWithCompleteBlock:^(NSError *error) {
            STRONG_SELF
            if (error) {
                [self showToast:error.localizedDescription];
                return;
            }
            [self updateAreaInfo];//待接入真实数据后使用
//            [self updateMockAreaInfo];//mock数据
        }];
    }
}

- (void)updateStageSubjectInfo {
    self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
     DDLogDebug(@"最终结果学科%@-学段%@",self.userModel.stage.name,self.userModel.subject.name);
    NSIndexPath *stageIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *subjectIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[stageIndexPath,subjectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateAreaInfo {
    self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
    DDLogDebug(@"最终结果地区:%@-%@-%@",self.userModel.province.name,self.userModel.city.name,self.userModel.district.name);
    NSIndexPath *areaIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[areaIndexPath] withRowAnimation:UITableViewRowAnimationNone];

}

- (void)updateMockStageSubjectInfo {
    FetchStageSubjectRequestItem *stageSubjectItem = [StageSubjectDataManager dataForStageAndSubject];
    UserSubjectStageSelectedInfoItem *item = [self.subjectStageInfoPicker selectedInfoItem];
    FetchStageSubjectRequestItem_stage *stage = [[FetchStageSubjectRequestItem_stage alloc]init];
    FetchStageSubjectRequestItem_subject *subject = [[FetchStageSubjectRequestItem_subject alloc]init];
    if (stageSubjectItem.data.stages.count > 0) {
        stage = stageSubjectItem.data.stages[item.selectedStageRow];
        if (stage.subjects.count > 0) {
            subject = stage.subjects[item.selectedSubjectRow];
        }
    }
    UserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UserInfoTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell configTitle:@"学段" content:stage.name];
    [cell1 configTitle:@"学科" content:subject.name];
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
    if (indexPath.row == 0) {
        UserImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserImageTableViewCell" forIndexPath:indexPath];
        cell.model = [UserManager sharedInstance].userModel;
        return cell;
    }else {
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 1 || indexPath.row == 2) {
            if (indexPath.row == 1) {
                [cell configTitle:@"学段" content:self.userModel.stage.name];
            }else if (indexPath.row == 2) {
                [cell configTitle:@"学科" content:self.userModel.subject.name];
            }
            WEAK_SELF
            [cell setSelectedButtonActionBlock:^{
                STRONG_SELF
                DDLogDebug(@"点击选择学段学科");
                self.userInfoPickerView.pickerView.dataSource = self.subjectStageInfoPicker;
                self.userInfoPickerView.pickerView.delegate = self.subjectStageInfoPicker;
                [self.userInfoPickerView showPickerView];
                [self.subjectStageInfoPicker resetSelectedSubjectsWithUserModel:self.userModel];
                [self showStageAndSubjectPicker];
            }];
        }else if (indexPath.row == 3) {
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
        }
        return cell;
    }
}
#pragma mark - TabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150;
    }else {
        return 50;
    }
}

#pragma mark - InfoPicker
- (void)showStageAndSubjectPicker {
    UserSubjectStageSelectedInfoItem *item = [self.subjectStageInfoPicker selectedInfoItem];
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:item.selectedStageRow inComponent:0 animated:NO];
    [self.userInfoPickerView.pickerView selectRow:item.selectedSubjectRow inComponent:1 animated:NO];
}

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
