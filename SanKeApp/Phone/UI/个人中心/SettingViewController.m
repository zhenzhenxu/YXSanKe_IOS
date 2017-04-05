//
//  SettingViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SettingViewController.h"
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
#import "UserInfoPicker.h"
#import "UserNameTableViewCell.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MineUserModel *userModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UserInfoPickerView *userInfoPickerView;
@property (nonatomic, strong) UserSubjectStageInfoPicker *subjectStageInfoPicker;
@property (nonatomic, strong) UserAreaInfoPicker *areaInfoPicker;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@property (nonatomic, strong) MenuSelectionView *menuSelectionView;
@property (nonatomic, strong) UserInfoPicker *genderInfoPicker;


@property (nonatomic, strong) Area *province;
@property (nonatomic, strong) Area *city;
@property (nonatomic, strong) Area *district;
@property (nonatomic, strong) FetchStageSubjectRequestItem_stage *stage;
@property (nonatomic, strong) FetchStageSubjectRequestItem_subject *subject;

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation SettingViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavgationBar];
    [self setupUI];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UserImageTableViewCell class] forCellReuseIdentifier:@"UserImageTableViewCell"];
    [self.tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:@"UserInfoTableViewCell"];
    [self.tableView registerClass:[UserNameTableViewCell class] forCellReuseIdentifier:@"UserNameTableViewCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    self.imagePickerController = [[YXImagePickerController alloc] init];
}

#pragma mark - getter

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
        NSString *str1 = @"性别";
        NSString *str2 = @"学段";
        NSString *str3 = @"学科";
        NSString *str4 = @"地区";
        
        NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:str1,str2,str3,str4,nil];
        _dataArray = dataArray.copy;
    }
    return _dataArray;
}

- (UserInfoPickerView *)userInfoPickerView {
    if (_userInfoPickerView == nil) {
        _userInfoPickerView = [[UserInfoPickerView alloc]init];
        [self.navigationController.view addSubview:_userInfoPickerView];
        [_userInfoPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_userInfoPickerView hidePickerView];
        WEAK_SELF
        [_userInfoPickerView setConfirmButtonActionBlock:^{
            STRONG_SELF
            [self updateSelectedInfo];
        }];
    }
    return _userInfoPickerView;
}

- (UserInfoPicker *)genderInfoPicker {
    if (_genderInfoPicker == nil) {
        _genderInfoPicker = [[UserInfoPicker alloc]init];
        _genderInfoPicker.dataArray = [UserInfoDataManger userInfoData].data.gender;
    }
    return _genderInfoPicker;
}

- (UserSubjectStageInfoPicker *)subjectStageInfoPicker {
    if (_subjectStageInfoPicker == nil) {
        _subjectStageInfoPicker = [[UserSubjectStageInfoPicker alloc]init];
        _subjectStageInfoPicker.stageAndSubjectItem = [StageSubjectDataManager dataForStageAndSubject];
    }
    return _subjectStageInfoPicker;
}

- (UserAreaInfoPicker *)areaInfoPicker {
    if (_areaInfoPicker == nil) {
        _areaInfoPicker = [[UserAreaInfoPicker alloc]init];
        _areaInfoPicker.model = [AreaDataManager areaModel];
    }
    return _areaInfoPicker;
}

- (void)LoadData {
    self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
    [self.tableView reloadData];
}

#pragma mark - update Picker Selected Info
- (void)updateSelectedInfo {
    WEAK_SELF
    if ([self.userInfoPickerView.pickerView.dataSource isEqual:self.genderInfoPicker]) {
        [self updateGenderInfo];
        
    }
    if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserSubjectStageInfoPicker class]]) {
        [self.subjectStageInfoPicker updateStageWithCompleteBlock:^(NSError *error) {
            STRONG_SELF
            if (error) {
                [self showToast:error.localizedDescription];
                return;
            }
            [self updateStageSubjectInfo];
        }];
    }
    if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserAreaInfoPicker class]]) {
        [self.areaInfoPicker updateAreaWithCompleteBlock:^(NSError *error) {
            STRONG_SELF
            if (error) {
                [self showToast:error.localizedDescription];
                return;
            }
            [self updateAreaInfo];
        }];
    }
}

- (void)updateGenderInfo {
    DDLogDebug(@"更新性别");
    SupplementUserInfo *info = [[SupplementUserInfo alloc]init];
    info.genderID = self.genderInfoPicker.selectedItem.userInfo.infoID;
    [MineDataManager updateSupplementUserInfo:info completeBlock:^(NSError *error) {
        if (error) {
            [self showToast:error.localizedDescription];
            return ;
        }
        self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
        NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:@[nameIndexPath] withRowAnimation:UITableViewRowAnimationNone];

    }];
}

- (void)updateStageSubjectInfo {
    self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
    DDLogDebug(@"最终结果学科%@-学段%@",self.userModel.stage.name,self.userModel.subject.name);
    NSIndexPath *stageIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    NSIndexPath *subjectIndexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:@[stageIndexPath,subjectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    YXProblemItem *item = [YXProblemItem new];
    item.subject = self.userModel.subject.subjectID;
    item.grade = self.userModel.stage.stageID;
    item.type = YXRecordGradeChangeType;
    [YXRecordManager addRecord:item];
}

- (void)updateAreaInfo {
    self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
    DDLogDebug(@"最终结果地区:%@-%@-%@",self.userModel.province.name,self.userModel.city.name,self.userModel.district.name);
    NSIndexPath *areaIndexPath = [NSIndexPath indexPathForRow:3 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:@[areaIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        if ([UserManager sharedInstance].userModel.isAnonymous) {
            return 0;
        }else {
            return 1;
        }
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0) {
        UserImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserImageTableViewCell" forIndexPath:indexPath];
        cell.model = [UserManager sharedInstance].userModel;
        WEAK_SELF
        [cell setEditBlock:^{
            STRONG_SELF
            [self.view endEditing:YES];
            DDLogDebug(@"%@修改头像",[self class]);
            [self changeHeadPortrait];
        }];
        return cell;
    }else if (indexPath.section == 1){
        if (![UserManager sharedInstance].userModel.isAnonymous) {
            UserNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserNameTableViewCell" forIndexPath:indexPath];
            [cell configTitle:@"用户名:" content:self.userModel.name];
            WEAK_SELF
            [cell setClickBlock:^(UITextField *nameTextField) {
                STRONG_SELF
                [nameTextField becomeFirstResponder];
            }];
            [cell setChangeNameBlock:^(NSString *name) {
                STRONG_SELF
                [self updateUserName:name];
            }];
            return cell;
        }else {
            return nil;
        }
    }else {
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [cell configTitle:self.dataArray[indexPath.row] content:self.userModel.gender.name];
            WEAK_SELF
            [cell setSelectedButtonActionBlock:^{
                STRONG_SELF
                [self.view endEditing:YES];
                DDLogDebug(@"点击选择性别");
                self.userInfoPickerView.pickerView.dataSource = self.genderInfoPicker;
                self.userInfoPickerView.pickerView.delegate = self.genderInfoPicker;
                [self.userInfoPickerView showPickerView];
                [self.genderInfoPicker resetSelectedInfo:self.userModel.gender];
                [self showGenderListPicker];
            }];
        }else if (indexPath.row == 1 || indexPath.row == 2) {
            if (indexPath.row == 1) {
                [cell configTitle:self.dataArray[indexPath.row] content:self.userModel.stage.name];
            }else if (indexPath.row == 2) {
                [cell configTitle:self.dataArray[indexPath.row] content:self.userModel.subject.name];
            }
            WEAK_SELF
            [cell setSelectedButtonActionBlock:^{
                STRONG_SELF
                [self.view endEditing:YES];
                DDLogDebug(@"点击选择学段学科");
                self.userInfoPickerView.pickerView.dataSource = self.subjectStageInfoPicker;
                self.userInfoPickerView.pickerView.delegate = self.subjectStageInfoPicker;
                [self.userInfoPickerView showPickerView];
                [self.subjectStageInfoPicker resetSelectedSubjectsWithUserModel:self.userModel];
                [self showStageAndSubjectPicker];
            }];
        }else {
            NSString *area = [self configAreaString];
            [cell configTitle:self.dataArray[indexPath.row] content:area];
            WEAK_SELF
            [cell setSelectedButtonActionBlock:^{
                STRONG_SELF
                [self.view endEditing:YES];
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
            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage *selectedImage) {
                STRONG_SELF
                [self updateHeadPortrait:selectedImage];
            }];
        }
            break;
        case 1:{
            WEAK_SELF
            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
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
    WEAK_SELF
    [MineDataManager updateHeadPortrait:image completeBlock:^(NSError *error) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
        }
        NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[nameIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - update UserName
- (void)updateUserName:(NSString *)name {
    DDLogDebug(@"设置用户名");
    if ([name isEqualToString:self.userModel.name]) {
        return;
    }
    WEAK_SELF
    [MineDataManager updateUserName:name completeBlock:^(NSError *error) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
            return ;
        }
        self.userModel = [MineUserModel mineUserModelFromRawModel:[UserManager sharedInstance].userModel];
        NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[nameIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - InfoPicker
- (void)showGenderListPicker {
    NSInteger selectedRow = self.genderInfoPicker.selectedItem.row;
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:selectedRow inComponent:0 animated:NO];
}
- (void)showStageAndSubjectPicker {
    UserSubjectStageSelectedInfoItem *item = [self.subjectStageInfoPicker selectedInfoItem];
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:item.stageRow inComponent:0 animated:NO];
    [self.userInfoPickerView.pickerView selectRow:item.subjectRow inComponent:1 animated:NO];
}

- (void)showProvinceListPicker {
    UserAreaSelectedInfoItem *item = [self.areaInfoPicker selectedInfoItem];
    [self.userInfoPickerView reloadPickerView];
    [self.userInfoPickerView.pickerView selectRow:item.provinceRow inComponent:0 animated:NO];
    [self.userInfoPickerView.pickerView selectRow:item.cityRow inComponent:1 animated:NO];
    [self.userInfoPickerView.pickerView selectRow:item.districtRow inComponent:2 animated:NO];
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
