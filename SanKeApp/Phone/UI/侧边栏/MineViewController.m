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

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    [self setupSubjectStageInfoPicker];
    [self setupAreaInfoPicker];
   
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
        //确定之后的回调
        //先发送请求,成功之后,再修改cell的标题(判断数据源是哪个,进行相应的更新)
        if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserAreaInfoPicker class]]) {
            DDLogDebug(@"选择好了地区");
            DDLogDebug(@">>>%d",self.areaInfoPicker.integer);
        };
        if ([self.userInfoPickerView.pickerView.dataSource isKindOfClass:[UserSubjectStageInfoPicker class]]) {
            DDLogDebug(@"选择好了学科学段");
        };
    }];
}

- (void)setupSubjectStageInfoPicker {
     self.subjectStageInfoPicker = [[UserSubjectStageInfoPicker alloc]init];
    //设置初始的数据等(请求数据之后赋值)
    
}
- (void)setupAreaInfoPicker {
    self.areaInfoPicker = [[UserAreaInfoPicker alloc]init];
    self.areaInfoPicker.model = [AreaDataManager areaModel];
    //设置初始的地区等(请求数据之后赋值)
    self.areaInfoPicker.selectedProvince = self.areaInfoPicker.model.areas[0];
//    self.areaInfoPicker.selectedCitys = self.areaInfoPicker.selectedProvince.subAreas;
//    self.areaInfoPicker.selectedCounties = self.areaInfoPicker.selectedCitys[0].subAreas;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UserImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserImageTableViewCell" forIndexPath:indexPath];
        cell.imageUrl = @"http://a0.att.hudong.com/07/80/300245751203132333808987603.jpg";
        return cell;
    }else {
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 1 || indexPath.row == 2) {
            if (indexPath.row == 1) {
                [cell configTitle:@"学段" content:@"小学"];
            }else if (indexPath.row == 2) {
                [cell configTitle:@"学科" content:@"语文"];
            }
            WEAK_SELF
            [cell setSelectedButtonActionBlock:^{
                STRONG_SELF
                DDLogDebug(@"点击选择学段");
                
                self.userInfoPickerView.pickerView.dataSource = self.subjectStageInfoPicker;
                self.userInfoPickerView.pickerView.delegate = self.subjectStageInfoPicker;
                [self.userInfoPickerView reloadPickerView];
            }];
        }else if (indexPath.row == 3) {
            [cell configTitle:@"地区" content:@"张家口市"];
            WEAK_SELF
            [cell setSelectedButtonActionBlock:^{
                STRONG_SELF
                DDLogDebug(@"点击选择地区");
                self.userInfoPickerView.pickerView.dataSource = self.areaInfoPicker;
                self.userInfoPickerView.pickerView.delegate = self.areaInfoPicker;
                [self.areaInfoPicker selectRow:self.userInfoPickerView.pickerView];
                [self.userInfoPickerView reloadPickerView];
             [self.userInfoPickerView.pickerView selectRow:1 inComponent:1 animated:NO];
//                [self.userInfoPickerView selectRow:selectedRowInComponent1 inComponent:1 animated:NO];
//                [self.userInfoPickerView selectRow:selectedRowInComponent2 inComponent:2 animated:NO];

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

@end
