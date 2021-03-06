//
//  SupplementUserInfoViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SupplementUserInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserInfoPickerView.h"
#import "UserAreaInfoPicker.h"
#import "UserInfoPicker.h"
#import "SupplementUserInfo.h"
#import "MineUserModel.h"

@interface SupplementUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *ignoreButton;
@property (nonatomic, strong) UserInfoPickerView *userInfoPickerView;
@property (nonatomic, strong) UserAreaInfoPicker *areaInfoPicker;
@property (nonatomic, strong) UserInfoPicker *roleInfoPicker;
@property (nonatomic, strong) UserInfoPicker *genderInfoPicker;
@property (nonatomic, strong) UserInfoPicker *experienceInfoPicker;

@property (nonatomic, strong) Area *province;
@property (nonatomic, strong) Area *city;
@property (nonatomic, strong) Area *district;
@property (nonatomic, strong) UserInfo *roleInfo;
@property (nonatomic, strong) UserInfo *genderInfo;
@property (nonatomic, strong) UserInfo *experienceInfo;

@end

@implementation SupplementUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善个人资料";
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self setupNavgationBar];
    [self setupUI];
    [self setupLayout];
    
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
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2.0f;
    self.contentView.clipsToBounds = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:@"UserInfoTableViewCell"];
    
    
    self.userInfoPickerView = [[UserInfoPickerView alloc]init];
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
    self.confirmButton = confirmButton;
    
    UIButton *ignoreButton = [[UIButton alloc]init];
    ignoreButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [ignoreButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"d65b4b"]] forState:UIControlStateNormal];
    [ignoreButton setTitle:@"忽略" forState:UIControlStateNormal];
    [ignoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ignoreButton addTarget:self action:@selector(ignoreAction) forControlEvents:UIControlEventTouchUpInside];
    self.ignoreButton = ignoreButton;
    
}

- (void)setupLayout {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.navigationController.view addSubview:self.userInfoPickerView];
    [self.contentView addSubview:self.confirmButton];
    [self.contentView addSubview:self.ignoreButton];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 35, 0));
    }];
    [self.userInfoPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.top.equalTo(self.tableView.mas_bottom);
        make.bottom.equalTo(self.contentView);
    }];
    [self.ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmButton.mas_right);
        make.top.equalTo(self.confirmButton);
        make.right.equalTo(self.tableView);
        make.bottom.equalTo(self.confirmButton);
        make.width.mas_equalTo(self.confirmButton.mas_width);
    }];
    
}
#pragma mark - getter
- (UserAreaInfoPicker *)areaInfoPicker {
    if (_areaInfoPicker == nil) {
        _areaInfoPicker = [[UserAreaInfoPicker alloc]init];
        _areaInfoPicker.model = [AreaDataManager areaModel];
    }
    return _areaInfoPicker;
}

- (UserInfoPicker *)roleInfoPicker {
    if (_roleInfoPicker == nil) {
        _roleInfoPicker = [[UserInfoPicker alloc]init];
        _roleInfoPicker.dataArray = [UserInfoDataManger userInfoData].data.role;
    }
    return _roleInfoPicker;
}

- (UserInfoPicker *)genderInfoPicker {
    if (_genderInfoPicker == nil) {
        _genderInfoPicker = [[UserInfoPicker alloc]init];
        _genderInfoPicker.dataArray = [UserInfoDataManger userInfoData].data.gender;
    }
    return _genderInfoPicker;
}

- (UserInfoPicker *)experienceInfoPicker {
    if (_experienceInfoPicker == nil) {
        _experienceInfoPicker = [[UserInfoPicker alloc]init];
        _experienceInfoPicker.dataArray = [UserInfoDataManger userInfoData].data.experience;
    }
    return _experienceInfoPicker;
}
#pragma mark -update Picker Selected Info
- (void)updateSelectedInfo {
    
    if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserAreaInfoPicker class]]) {
        [self updateAreaInfo];
        
    }else if ([self.userInfoPickerView.pickerView.dataSource isEqual:self.roleInfoPicker]) {
        [self updateRoleInfo];
        
    }else if ([self.userInfoPickerView.pickerView.dataSource isEqual:self.genderInfoPicker]) {
        [self updateGenderInfo];
        
    }else if ([self.userInfoPickerView.pickerView.dataSource isEqual:self.experienceInfoPicker]) {
        [self updateExperienceInfo];
    }
}

- (void)updateAreaInfo {
    DDLogDebug(@"更新地区");
    UserAreaSelectedInfoItem *item = [self.areaInfoPicker selectedInfoItem];
    self.province = item.province;
    self.city = item.city;
    self.district = item.district;
    UserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *area = [NSString string];
    if (!isEmpty(self.province)) {
        area = self.province.name;
        if (!isEmpty(self.city)) {
            area = [area stringByAppendingString:self.city.name];
            if (!isEmpty(self.district)) {
                area = [area stringByAppendingString:self.district.name];
            }
        }
    }
    [cell configTitle:@"地区" content:area];
}

- (void)updateRoleInfo {
    DDLogDebug(@"更新身份");
    self.roleInfo = [self.roleInfoPicker selectedInfoItem].userInfo;
    UserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *role = [NSString string];
    if (!isEmpty(self.roleInfo)) {
        role = self.roleInfo.name;
    }
    [cell configTitle:@"身份" content:role];
}

- (void)updateGenderInfo {
    DDLogDebug(@"更新性别");
    self.genderInfo = [self.genderInfoPicker selectedInfoItem].userInfo;
    UserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *gender = [NSString string];
    if (!isEmpty(self.genderInfo)) {
        gender = self.genderInfo.name;
    }
    [cell configTitle:@"性别" content:gender];
}

- (void)updateExperienceInfo {
    DDLogDebug(@"更新工作年限");
    self.experienceInfo = [self.experienceInfoPicker selectedInfoItem].userInfo;
    UserInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *experience = [NSString string];
    if (!isEmpty(self.experienceInfo)) {
        experience = self.experienceInfo.name;
    }
    [cell configTitle:@"入职年份" content:experience];
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
            MineUserModel *model = [[MineUserModel alloc]init];
            model.province = self.province;
            model.city = self.city;
            model.district = self.district;
            [self.areaInfoPicker resetSelectedProvinceDataWithUserModel:model];
            [self showProvinceListPicker];
        }];
    }else if (indexPath.row == 1) {
        [cell configTitle:@"身份" content:self.roleInfo.name];
        WEAK_SELF
        [cell setSelectedButtonActionBlock:^{
            STRONG_SELF
            DDLogDebug(@"点击选择身份");
            self.userInfoPickerView.pickerView.dataSource = self.roleInfoPicker;
            self.userInfoPickerView.pickerView.delegate = self.roleInfoPicker;
            [self.userInfoPickerView showPickerView];
            [self.roleInfoPicker resetSelectedInfo:self.roleInfo];
            [self showRoleListPicker];
            
        }];
    }else if (indexPath.row == 2) {
        [cell configTitle:@"性别" content: self.genderInfo.name];
        WEAK_SELF
        [cell setSelectedButtonActionBlock:^{
            STRONG_SELF
            DDLogDebug(@"点击选择性别");
            self.userInfoPickerView.pickerView.dataSource = self.genderInfoPicker;
            self.userInfoPickerView.pickerView.delegate = self.genderInfoPicker;
            [self.userInfoPickerView showPickerView];
            [self.genderInfoPicker resetSelectedInfo:self.genderInfo];
            [self showGenderListPicker];
        }];
    }else if (indexPath.row == 3) {
        [cell configTitle:@"入职年份" content:self.experienceInfo.name];
        WEAK_SELF
        [cell setSelectedButtonActionBlock:^{
            STRONG_SELF
            DDLogDebug(@"点击选择入职年份");
            self.userInfoPickerView.pickerView.dataSource = self.experienceInfoPicker;
            self.userInfoPickerView.pickerView.delegate = self.experienceInfoPicker;
            [self.userInfoPickerView showPickerView];
            [self.experienceInfoPicker resetSelectedInfo:self.experienceInfo];
            [self showExperienceListPicker];
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
    SupplementUserInfo *info = [[SupplementUserInfo alloc]init];
    info.stageID = self.stageID;
    info.subjectID = self.subjectID;
    info.areaID = [self configAreaID];
    info.roleID = self.roleInfo.infoID;
    info.genderID = self.genderInfo.infoID;
    info.experienceID = self.experienceInfo.infoID;
    WEAK_SELF
    [MineDataManager updateSupplementUserInfo:info completeBlock:^(NSError *error) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        [self reportRecord];
    }];
}

- (void)ignoreAction {
    SupplementUserInfo *info = [[SupplementUserInfo alloc]init];
    info.stageID = self.stageID;
    info.subjectID = self.subjectID;
    WEAK_SELF
    [MineDataManager updateSupplementUserInfo:info completeBlock:^(NSError *error) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        [self reportRecord];
    }];
}

- (void)reportRecord {
    YXProblemItem *item = [YXProblemItem new];
    item.subject = self.subjectID;
    item.grade = self.stageID;
    item.type = YXRecordGradeType;
    [YXRecordManager addRecord:item];
}
#pragma mark - InfoPicker
- (void)showProvinceListPicker {
    UserAreaSelectedInfoItem *item = [self.areaInfoPicker selectedInfoItem];
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:item.provinceRow inComponent:0 animated:NO];
    [self.userInfoPickerView.pickerView selectRow:item.cityRow inComponent:1 animated:NO];
    [self.userInfoPickerView.pickerView selectRow:item.districtRow inComponent:2 animated:NO];
}
- (void)showRoleListPicker {
    NSInteger selectedRow = [self.roleInfoPicker selectedInfoItem].row;
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:selectedRow inComponent:0 animated:NO];
}
- (void)showGenderListPicker {
    NSInteger selectedRow = [self.genderInfoPicker selectedInfoItem].row;
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:selectedRow inComponent:0 animated:NO];
}

- (void)showExperienceListPicker {
    NSInteger selectedRow = [self.experienceInfoPicker selectedInfoItem].row;
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:selectedRow inComponent:0 animated:NO];
}    
#pragma  mark - configAreaSring
-(NSString *)configAreaString {
    NSString *area = [NSString string];
    if (!isEmpty(self.province)) {
        area = self.province.name;
        if (!isEmpty(self.city)) {
            area = [area stringByAppendingString:self.city.name];
            if (!isEmpty(self.district)) {
                area = [area stringByAppendingString:self.district.name];
            }
        }
    }
    return area;
}

-(NSString *)configAreaID {
    NSString *areaID = [NSString string];
    if (!isEmpty(self.province.areaID)) {
        areaID = self.province.areaID;
        if (!isEmpty(self.city.areaID)) {
            areaID = [NSString stringWithFormat:@"%@,%@",areaID,self.city.areaID];
            if (!isEmpty(self.district.areaID)) {
                areaID = [NSString stringWithFormat:@"%@,%@",areaID,self.district.areaID];
            }
        }
    }
    return areaID;
}
@end
