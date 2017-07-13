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
#import "TeachingMutiLabelView.h"
#import "LabelListViewController.h"
#import "PhotoBrowserController.h"

@interface TeachingMainViewController ()<UITableViewDataSource,UITableViewDelegate,TeachingFilterViewDelegate>
#pragma mark - data
@property (nonatomic, strong) GetBookInfoRequest *getBookInfoRequest;
@property (nonatomic, strong) NSArray <NSArray<TeachingPageModel *> *>*dataArray;
@property (nonatomic, strong) NSArray<TeachingPageModel *> *currentVolumDataArray;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, strong) TeachingFiterModel *filterModel;
#pragma mark - view
@property (nonatomic, strong) TeachingFilterView *filterView;
@property (nonatomic, strong) TeachingMutiLabelView *mutiTabView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;
#pragma mark - other
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) BOOL isScrollTop;
@end

@implementation TeachingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emptyView = [[EmptyView alloc]init];
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self setupCurrentContent];
    }];
    self.dataErrorView = [[DataErrorView alloc]init];
    
    self.isScrollTop = YES;
    [self setupTitle];
    [self setupCurrentContent];
    [self setupObserver];
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

- (void)setupCurrentContent {
    NSArray *array = self.view.subviews;
    [array enumerateObjectsUsingBlock:^(UIView *  _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        [subView removeFromSuperview];
    }];
    
    if (self.getBookInfoRequest) {
        [self.getBookInfoRequest stopRequest];
    }
    self.getBookInfoRequest = [[GetBookInfoRequest alloc]init];
    WEAK_SELF
    [self startLoading];
    [self.getBookInfoRequest startRequestWithRetClass:[GetBookInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        
        GetBookInfoRequestItem *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = item.data.volums.count > 0 ? YES : NO;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data inView:self.view]) {
            return;
        }
       
        self.filterModel = [TeachingFiterModel modelFromRawData:item];
        [self dealWithFilterModel:self.filterModel];
        self.dataArray = [TeachingPageModel TeachingPageModelsFromRawData:item];
        [self setupUI];
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kStageSubjectDidChangeNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupTitle];
        [self setupCurrentContent];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kPhotoBrowserExitNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSString *indexStr = dic[kPhotoBrowserIndexKey];
        NSInteger currentIndex = indexStr.integerValue;
        
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        TeachingMainCell *cell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
        TeachingPageModel *model = cell.model;
        [self setupCurrentPageLabelWithPageModel:model];
        [self setupCurrentFiltersWithPageModel:model];
    }];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 385.0f * kScreenHeightScale(1.0f);
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TeachingMainCell class] forCellReuseIdentifier:@"TeachingMainCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44.0f);
    }];
    
    [self setupMutiTabView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.view addSubview:lineView];
    self.lineView = lineView;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mutiTabView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setupMutiTabView {
    self.mutiTabView = [[TeachingMutiLabelView alloc]initWithFrame:CGRectMake(0, 44, self.view.width, 44)];
    [self.view addSubview:self.mutiTabView];
    WEAK_SELF
    [self.mutiTabView setClickTabButtonBlock:^{
        STRONG_SELF
        GetBookInfoRequestItem_Volum *volum = self.filterModel.volums[self.filterModel.volumChooseInteger];
        GetBookInfoRequestItem_Unit *unit = self.filterModel.units[self.filterModel.unitChooseInteger];
        GetBookInfoRequestItem_Course *course = self.filterModel.courses[self.filterModel.courseChooseInteger];
        
        LabelListViewController *vc = [[LabelListViewController alloc]init];
        vc.tabArray = self.mutiTabView.tabArray;
        vc.currentTabIndex = self.mutiTabView.currentTabIndex;
        vc.volum = volum;
        vc.unit = unit;
        vc.course = course;
        [self.navigationController pushViewController:vc animated:YES];
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
}

#pragma mark - TeachingFilterViewDelegate
- (void)filterChanged:(NSArray *)filterArray{
    NSNumber *num0 = filterArray[0];
    
    NSNumber *num1 = [NSNumber numberWithInteger:0];
    if (num0.integerValue != self.filterModel.volumChooseInteger) {
        self.filterModel.volumChooseInteger = num0.integerValue;
        self.filterModel.unitChooseInteger = 0;
        self.filterModel.courseChooseInteger = 0;
        [self refreshUnitFilter];
        [self.tableView reloadData];
        return;
    }else {
        num1 = filterArray[1];
    }
    
    NSNumber *num2 = [NSNumber numberWithInteger:0];
    if (num1.integerValue != self.filterModel.unitChooseInteger) {
        self.filterModel.unitChooseInteger = num1.integerValue;
        self.filterModel.courseChooseInteger = 0;
        [self refreshCourseFilter];
        return;
    }else {
        num2 = filterArray[2];
        self.filterModel.courseChooseInteger = num2.integerValue;
    }
    [self scrollToFilterPosition];
}

- (void)refreshUnitFilter{
    NSMutableArray *array = [NSMutableArray array];
    for (GetBookInfoRequestItem_Unit *filter in self.filterModel.units) {
        [array addObject:filter.name];
    }
    [self.filterView refreshFilters:array forKey:self.filterModel.unitName isFilter:NO];
    [self.filterView setCurrentIndex:0 forKey:self.filterModel.unitName];
    [self refreshCourseFilter];
}

- (void)refreshCourseFilter{
    NSMutableArray *array = [NSMutableArray array];
    for (GetBookInfoRequestItem_Course *filter in self.filterModel.courses) {
        [array addObject:filter.name];
    }
    [self.filterView refreshFilters:array forKey:self.filterModel.courseName isFilter:YES];
}

- (void)scrollToFilterPosition {
    
    GetBookInfoRequestItem_Volum *volum = self.filterModel.volums[self.filterModel.volumChooseInteger];
    GetBookInfoRequestItem_Unit *unit = self.filterModel.units[self.filterModel.unitChooseInteger];
    GetBookInfoRequestItem_Course *course = self.filterModel.courses[self.filterModel.courseChooseInteger];
    NSString *filter;
    if (isEmpty(course.courseID)) {
        filter = [NSString stringWithFormat:@"%@,%@",volum.volumID,unit.unitID];
    }else {
        filter = [NSString stringWithFormat:@"%@,%@,%@",volum.volumID,unit.unitID,course.courseID];
    }
    [self.currentVolumDataArray enumerateObjectsUsingBlock:^(TeachingPageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.pageTarget isEqualToString:filter] && obj.isStart) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self setupCurrentPageLabelWithPageModel:obj];
            *stop = YES;
        }
    }];
    
    
    YXProblemItem *item = [[YXProblemItem alloc]init];
    item.grade = [UserManager sharedInstance].userModel.stageID;
    item.subject = [UserManager sharedInstance].userModel.subjectID;
    item.volume_id = volum.volumID;
    item.unit_id = unit.unitID;
    item.course_id = course.courseID;
    item.type = YXRecordClickType;
    item.objType = @"filter_tbjx";
    [YXRecordManager addRecord:item];
}

#pragma mark - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentVolumDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeachingMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeachingMainCell"];
    TeachingPageModel *model = self.currentVolumDataArray[indexPath.row];
    cell.model = model;
    if (indexPath.row == 0) {
        [self setupCurrentPageLabelWithPageModel:model];
    }
    WEAK_SELF
    [cell setSelectedButtonActionBlock:^{
        STRONG_SELF
        PhotoBrowserController *pbController = [[PhotoBrowserController alloc] init];
        pbController.imageUrls = self.imageUrls;
        pbController.currentIndex = indexPath.row;
        [self.navigationController pushViewController:pbController animated:NO];
    }];
    return cell;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastContentOffset = scrollView.contentOffset.y;
    self.filterView.userInteractionEnabled = NO;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.filterView.userInteractionEnabled = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.filterView.userInteractionEnabled = YES;
    if (self.lastContentOffset - scrollView.contentOffset.y > 30) {
        self.isScrollTop = NO;
    }
    if (scrollView.contentOffset.y - self.lastContentOffset > 30) {
        self.isScrollTop = YES;
    }
    [self setupCurrentPageModel];
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height) {
        [self showToast:@"没有更多"];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.filterView.userInteractionEnabled = YES;
    if (self.lastContentOffset - scrollView.contentOffset.y > 30) {
        self.isScrollTop = NO;
    }
    if (scrollView.contentOffset.y - self.lastContentOffset > 30) {
        self.isScrollTop = YES;
    }
    [self setupCurrentPageModel];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.isScrollTop = YES;
    [self setupCurrentPageModel];
}

#pragma mark - setupCurrentPageModel
- (void)setupCurrentPageModel {
    NSIndexPath *currentIndexPath;
    if (self.isScrollTop) {
        currentIndexPath = [self minVisibleIndexPath];
    }else {
        currentIndexPath = [self maxVisibleIndexPath];
    }
    TeachingMainCell *cell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
    TeachingPageModel *model = cell.model;
    [self setupCurrentPageLabelWithPageModel:model];
    [self setupCurrentFiltersWithPageModel:model];
}

- (NSIndexPath *)minVisibleIndexPath {
    NSIndexPath *minIndexPath;
    NSArray *array = [self.tableView indexPathsForVisibleRows];
    if (array.count > 0) {
        minIndexPath = array.firstObject;
        for (NSIndexPath *indexPath in array) {
            NSComparisonResult result = [minIndexPath compare:indexPath];
            if (result == NSOrderedDescending) {
                minIndexPath = indexPath;
            }
        }
    }
    return minIndexPath;
}

- (NSIndexPath *)maxVisibleIndexPath {
    NSIndexPath *maxIndexPath;
    NSArray *array = [self.tableView indexPathsForVisibleRows];
    if (array.count > 0) {
        maxIndexPath = array.firstObject;
        for (NSIndexPath *indexPath in array) {
            NSComparisonResult result = [maxIndexPath compare:indexPath];
            if (result == NSOrderedAscending) {
                if (indexPath.row == 1) {
                    break ;
                }
                maxIndexPath = indexPath;
            }
        }
    }
    return maxIndexPath;
}

- (void)setupCurrentPageLabelWithPageModel:(TeachingPageModel *)model {
    if (model.pageLabel.count > 0) {
        self.mutiTabView.hidden = NO;
        self.lineView.hidden = NO;
        self.mutiTabView.tabArray = model.pageLabel;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44.0f + 44.0f);
        }];
    }else {
        self.mutiTabView.hidden = YES;
        self.lineView.hidden = YES;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44.0f);
        }];
    }
}

- (void)setupCurrentFiltersWithPageModel:(TeachingPageModel *)model{
    GetBookInfoRequestItem_Volum *volum = self.filterModel.volums[self.filterModel.volumChooseInteger];
    
    NSString *target = model.pageTarget;
    NSString *volumStr = [NSString stringWithFormat:@"%@,",volum.volumID];
    
    if (![target containsString:volumStr]) {
        return;
    }
    NSRange range = [target rangeOfString:volumStr];
    NSString * result = [target substringFromIndex:range.location + range.length];
    NSArray *array = [result componentsSeparatedByString:@","];
    if (array.count > 0) {
        if (array.count == 1) {
            [self.filterModel.units enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Unit * _Nonnull unit, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([array.firstObject isEqualToString:unit.unitID]) {
                    self.filterModel.unitChooseInteger = idx;
                    self.filterModel.courseChooseInteger = 0;
                    NSMutableArray *array = [NSMutableArray array];
                    for (GetBookInfoRequestItem_Course *filter in self.filterModel.courses) {
                        [array addObject:filter.name];
                    }
                    [self.filterView refreshFilters:array forKey:self.filterModel.courseName isFilter:NO];
                    *stop = YES;
                }
            }];
        }
        if (array.count == 2) {
            [self.filterModel.units enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Unit * _Nonnull unit, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([array.firstObject isEqualToString:unit.unitID]) {
                    self.filterModel.unitChooseInteger = idx;
                    self.filterModel.courseChooseInteger = 0;
                    NSMutableArray *array = [NSMutableArray array];
                    for (GetBookInfoRequestItem_Course *filter in self.filterModel.courses) {
                        [array addObject:filter.name];
                    }
                    [self.filterView refreshFilters:array forKey:self.filterModel.courseName isFilter:NO];
                    *stop = YES;
                }
            }];
            [self.filterModel.courses enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Course * _Nonnull course, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([array.lastObject isEqualToString:course.courseID]) {
                    self.filterModel.courseChooseInteger = idx;
                }
            }];
        }
        [self.filterView setCurrentIndex:self.filterModel.unitChooseInteger forKey:self.filterModel.unitName];
        [self.filterView setCurrentIndex:self.filterModel.courseChooseInteger forKey:self.filterModel.courseName];
    }
}

#pragma mark - getter
- (NSArray<TeachingPageModel *> *)currentVolumDataArray {
    if ([_currentVolumDataArray isEqualToArray:self.dataArray[self.filterModel.volumChooseInteger]]) {
        return _currentVolumDataArray;
    }
    
    _currentVolumDataArray = self.dataArray[self.filterModel.volumChooseInteger];
    self.imageUrls = [NSMutableArray array];
    for (int i = 0; i < _currentVolumDataArray.count; i++) {
        [self.imageUrls addObject:_currentVolumDataArray[i].pageUrl];
    }
    return _currentVolumDataArray;
}

@end
