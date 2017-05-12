//
//  TeachingMainViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingMainViewController.h"
#import "TeachingMainCell.h"
#import "TeachingFilterView.h"
#import "TeachingFiterModel.h"
#import "GetBookInfoRequest.h"
#import "TeachingPageModel.h"
#import "TeachingMutiTabView.h"

@interface TeachingMainViewController ()<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate,TeachingFilterViewDelegate>
@property (nonatomic, strong) TeachingFilterView *filterView;
@property (nonatomic, strong) TeachingMutiTabView *mutiTabView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSArray<TeachingPageModel *> *>*dataArray;
@property (nonatomic, strong) NSArray<TeachingPageModel *> *currentVolumDataArray;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) TeachingFiterModel *filterModel;
@end

@implementation TeachingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTitle];
    self.filterModel = [TeachingFiterModel modelFromRawData:[GetBookInfoRequestItem mockGetBookInfoRequestItem]];
    [self dealWithFilterModel:self.filterModel];
    
    self.dataArray = [TeachingPageModel TeachingPageModelsFromRawData:[GetBookInfoRequestItem mockGetBookInfoRequestItem]];
    [self setupUI];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kStageSubjectDidChangeNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupTitle];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTitle {
    UserModel *model = [UserManager sharedInstance].userModel;
    [StageSubjectDataManager fetchStageSubjectWithStageID:model.stageID subjectID:model.subjectID completeBlock:^(FetchStageSubjectRequestItem_stage *stage, FetchStageSubjectRequestItem_subject *subject) {
        NSString *title = [stage.name stringByAppendingString:subject.name];
        self.navigationItem.title = title;
    }];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 335.0f;
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TeachingMainCell class] forCellReuseIdentifier:@"TeachingMainCell"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44.0f + 44.0f);
    }];
    
    [self setupMutiTabView];
}

- (void)setupMutiTabView {
    self.mutiTabView = [[TeachingMutiTabView alloc]initWithFrame:CGRectMake(0, 44, self.view.width, 44)];
    [self.view addSubview:self.mutiTabView];
    WEAK_SELF
    [self.mutiTabView setClickTabButtonBlock:^(GetBookInfoRequestItem_Label *label) {
        STRONG_SELF
        DDLogDebug(@"点击啦%@的标签",label.labelID);
    }];
}

- (void)dealWithFilterModel:(TeachingFiterModel *)model{
    TeachingFilterView *filterView = [[TeachingFilterView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.filterView = filterView;
    [self.view addSubview:filterView];

    NSMutableArray *array0 = [NSMutableArray array];
    for (GetBookInfoRequestItem_Volum *filter in model.volums) {
        [array0 addObject:filter.name];
    }
    [self.filterView addFilters:array0 forKey:model.volumName];

    NSMutableArray *array1 = [NSMutableArray array];
    for (GetBookInfoRequestItem_Unit *filter in model.units) {
        [array1 addObject:filter.name];
    }
    [self.filterView addFilters:array1 forKey:model.unitName];
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (GetBookInfoRequestItem_Course *filter in model.courses) {
        [array2 addObject:filter.name];
    }
    [self.filterView addFilters:array2 forKey:model.courseName];

    filterView.delegate = self;
    [self.view addSubview:filterView];
}

#pragma mark - TeachingFilterViewDelegate
- (void)filterChanged:(NSArray *)filterArray{
    //MARK:0.首先当册变了之后,单元和课也要变化
    NSNumber *num0 = filterArray[0];
    
    NSNumber *num1 = [NSNumber numberWithInteger:0];
    if (num0.integerValue != self.filterModel.volumChooseInteger) {
        self.filterModel.volumChooseInteger = num0.integerValue;
        self.filterModel.unitChooseInteger = 0;
        self.filterModel.courseChooseInteger = 0;
        [self refreshUnitWithFilterModel];//更新单元
        [self.tableView reloadData];
        return;
    }else {
        num1 = filterArray[1];
    }
    
    NSNumber *num2 = [NSNumber numberWithInteger:0];
    if (num1.integerValue != self.filterModel.unitChooseInteger) {
        self.filterModel.unitChooseInteger = num1.integerValue;
        self.filterModel.courseChooseInteger = 0;
        [self refreshCourseWithFilterModel];//更新课
        return;
    }else {
        // 学科
        num2 = filterArray[2];
        self.filterModel.courseChooseInteger = num2.integerValue;
    }
    //MARK:1.其次,筛选完成后,要滚动到当前筛选的位置
    //获取到当前的册-->单元-->课的id,然后又一个fetcher来返回应该滚动到的位置(索引以及url)
    //    BeijingCourseListFetcher *fetcher = (BeijingCourseListFetcher *)self.dataFetcher;
    //    //服务端数据返回空的处理:"0"-全部,即不做筛选
    //    if (self.filterModel.segment.count >0){
    //        fetcher.segid = self.filterModel.segment[num0.integerValue].filterID?:@"0";
    //    }
    //    if (self.filterModel.study.count > 0) {
    //        fetcher.studyid = self.filterModel.study[num1.integerValue].filterID?:@"0";
    //    }
    //    if (self.filterModel.stage.count) {
    //        fetcher.stageid = self.filterModel.stage[num2.integerValue].filterID?:@"0";
    //    }
    //筛选完成后,要滚动到当前筛选的位置
    [self scrollToFilterPosition];
}

- (void)scrollToFilterPosition {
    
    GetBookInfoRequestItem_Volum *volum = self.filterModel.volums[self.filterModel.volumChooseInteger];
    GetBookInfoRequestItem_Unit *unit = self.filterModel.units[self.filterModel.unitChooseInteger];
    GetBookInfoRequestItem_Course *course = self.filterModel.courses[self.filterModel.courseChooseInteger];
    DDLogDebug(@"课程选择%@;---%@,单元选择%@----%@,课程选择%@----%@",@(self.filterModel.volumChooseInteger),volum.volumID,@(self.filterModel.unitChooseInteger),unit.unitID,@(self.filterModel.courseChooseInteger),course.courseID);

}
- (void)refreshUnitWithFilterModel{
    NSMutableArray *array = [NSMutableArray array];
    for (GetBookInfoRequestItem_Unit *filter in self.filterModel.units) {
        [array addObject:filter.name];
    }
    [self.filterView refreshUnitFilters:array forKey:self.filterModel.unitName];
    [self.filterView setCurrentIndex:0 forKey:self.filterModel.unitName];
    [self refreshCourseWithFilterModel];
}

- (void)refreshCourseWithFilterModel{
    NSMutableArray *array = [NSMutableArray array];
    for (GetBookInfoRequestItem_Course *filter in self.filterModel.courses) {
        [array addObject:filter.name];
    }
    [self.filterView refreshCourseFilters:array forKey:self.filterModel.courseName];
}

- (void)setupWithCurrentFilters{
    //0.首先,第一次进来的时候(第一次安装/退出app后再进来/切换学科学段),要设置默认的册和单元,课设置为全部;
    //1.其次,在上下滑动的过程中,筛选条件要随着变化到相应的位置;
    //2.还有,在点击图片全屏浏览的时候.也需要将筛选条件变化到相应的位置.
//    [self.dataArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.filterView setCurrentIndex:0 forKey:obj.firstObject];
//    }];
}

#pragma mark - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[self.filterModel.volumChooseInteger];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeachingMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeachingMainCell"];
    TeachingPageModel *model = self.currentVolumDataArray[indexPath.row];
    cell.model = model;
    if (model.pageLabel.count > 0) {
        self.mutiTabView.hidden = NO;
        self.mutiTabView.tabArray = model.pageLabel;
    }else {
        self.mutiTabView.hidden = YES;
    }
    WEAK_SELF
    [cell setSelectedButtonActionBlock:^{
        STRONG_SELF
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        //            browser.displayActionButton = NO; //分享保存等的功能,默认是
        //        browser.displayNavArrows = NO;//左右分页切换(底部显示左右的三角按钮来翻页,同时若此时分享按钮显示,则也在底部显示),默认否
        //        browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上(右上角的对勾),默认否
                browser.alwaysShowControls = NO;//顶部的导航条以及页数是否一直显示(no则点击时显示-->隐藏->显示;yes则一直显示),默认否
                browser.zoomPhotosToFill = YES;//是否全屏(图片整张占满导航),默认是
        //        browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是(yes查看所有 no逐个加载)
        //        browser.startOnGrid = NO;//是否第一张,默认否(目前并没有发现这个有什么用)
        //        browser.enableSwipeToDismiss = YES;//是否开始对缩略图网格代替第一张照片.
        
        self.photoBrowser = browser;
        //设置当前要显示的图片
        [self.photoBrowser setCurrentPhotoIndex:model.pageIndex.integerValue - 1];
        
        //push到MWPhotoBrowser
        [self.navigationController pushViewController:self.photoBrowser animated:YES];
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    view.backgroundColor = [UIColor blueColor];
    return view;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.currentVolumDataArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    DDLogDebug(@"%@", @(index));
    if (index < self.currentVolumDataArray.count) {
        NSString *url = self.currentVolumDataArray[index].pageUrl;
        MWPhoto *ptoto = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        return ptoto;
    }
    return nil;
}

- (NSArray<TeachingPageModel *> *)currentVolumDataArray {
    return self.dataArray[self.filterModel.volumChooseInteger];
}
@end
