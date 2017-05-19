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
#import "TeachingPhotoBrowser.h"
#import "TabListViewController.h"

@interface TeachingMainViewController ()<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate,TeachingFilterViewDelegate>
#pragma mark - data
@property (nonatomic, strong) GetBookInfoRequest *getBookInfoRequest;
@property (nonatomic, strong) NSArray <NSArray<TeachingPageModel *> *>*dataArray;
@property (nonatomic, strong) NSArray<TeachingPageModel *> *currentVolumDataArray;
@property (nonatomic, strong) TeachingFiterModel *filterModel;
#pragma mark - view
@property (nonatomic, strong) TeachingFilterView *filterView;
@property (nonatomic, strong) TeachingMutiTabView *mutiTabView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TeachingPhotoBrowser *photoBrowser;
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
        [self startLoading];
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
        data.requestDataExist = !isEmpty(item);
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data inView:self.view]) {
            return;
        }
       
        self.dataArray = [TeachingPageModel TeachingPageModelsFromRawData:item];
        [self setupUI];
        self.filterModel = [TeachingFiterModel modelFromRawData:item];
        [self dealWithFilterModel:self.filterModel];
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kStageSubjectDidChangeNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupTitle];
        [self setupCurrentContent];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kTeachingPhotoBrowserExitNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSString *indexStr = dic[kPhotoIndexKey];
        NSInteger currentIndex = indexStr.integerValue;
        
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        TeachingMainCell *cell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
        TeachingPageModel *model = cell.model;
        [self setupCurrentPageTabWithPageModel:model];
        [self setupCurrentFiltersWithPageModel:model];
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
        make.top.mas_equalTo(44.0f);
    }];
    
    [self setupMutiTabView];
}

- (void)setupMutiTabView {
    self.mutiTabView = [[TeachingMutiTabView alloc]initWithFrame:CGRectMake(0, 44, self.view.width, 44)];
    [self.view addSubview:self.mutiTabView];
    WEAK_SELF
    [self.mutiTabView setClickTabButtonBlock:^{
        STRONG_SELF
        //跳转到标签页并选中相应的标签
        TabListViewController *vc = [[TabListViewController alloc]init];
        vc.tabArray = self.mutiTabView.tabArray;
        vc.currentTabIndex = self.mutiTabView.currentTabIndex;
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
    //MARK:0.首先当册变了之后,单元和课也要变化
    NSNumber *num0 = filterArray[0];
    
    NSNumber *num1 = [NSNumber numberWithInteger:0];
    if (num0.integerValue != self.filterModel.volumChooseInteger) {
        self.filterModel.volumChooseInteger = num0.integerValue;
        self.filterModel.unitChooseInteger = 0;
        self.filterModel.courseChooseInteger = 0;
        [self refreshUnitFilter];//更新单元
        [self.tableView reloadData];
        return;
    }else {
        num1 = filterArray[1];
    }
    
    NSNumber *num2 = [NSNumber numberWithInteger:0];
    if (num1.integerValue != self.filterModel.unitChooseInteger) {
        self.filterModel.unitChooseInteger = num1.integerValue;
        self.filterModel.courseChooseInteger = 0;
        [self refreshCourseFilter];//更新课
        return;
    }else {
        num2 = filterArray[2];
        self.filterModel.courseChooseInteger = num2.integerValue;
    }
    //MARK:1.其次,筛选完成后,要滚动到当前筛选的位置
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
    DDLogDebug(@"课程选择%@;---%@,单元选择%@----%@,课程选择%@----%@",@(self.filterModel.volumChooseInteger),volum.volumID,@(self.filterModel.unitChooseInteger),unit.unitID,@(self.filterModel.courseChooseInteger),course.courseID);
    
    NSString *filter;
    if (isEmpty(course.courseID)) {
        filter = [NSString stringWithFormat:@"%@,%@",volum.volumID,unit.unitID];
    }else {
        filter = [NSString stringWithFormat:@"%@,%@,%@",volum.volumID,unit.unitID,course.courseID];
    }
    [self.currentVolumDataArray enumerateObjectsUsingBlock:^(TeachingPageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.pageTarget isEqualToString:filter] && obj.isStart) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self setupCurrentPageTabWithPageModel:obj];
            *stop = YES;
        }
    }];
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
        [self setupCurrentPageTabWithPageModel:model];
    }
    WEAK_SELF
    [cell setSelectedButtonActionBlock:^{
        STRONG_SELF
        TeachingPhotoBrowser *browser = [[TeachingPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        self.photoBrowser = browser;
        [self.photoBrowser setCurrentPhotoIndex:indexPath.row];
        [self.navigationController pushViewController:self.photoBrowser animated:NO];
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
    if (index < self.currentVolumDataArray.count) {
        NSString *url = self.currentVolumDataArray[index].pageUrl;
        MWPhoto *ptoto = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        return ptoto;
    }
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%@/%@",@(index + 1),@(self.currentVolumDataArray.count)];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.lastContentOffset - scrollView.contentOffset.y > 30) {
        self.isScrollTop = NO;
    }
    if (scrollView.contentOffset.y - self.lastContentOffset > 30) {
        self.isScrollTop = YES;
    }
    [self setupCurrentPageModel];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.lastContentOffset - scrollView.contentOffset.y > 30) {
        self.isScrollTop = NO;
    }
    if (scrollView.contentOffset.y - self.lastContentOffset > 30) {
        self.isScrollTop = YES;
    }
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
    [self setupCurrentPageTabWithPageModel:model];
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

- (void)setupCurrentPageTabWithPageModel:(TeachingPageModel *)model {
    if (model.pageLabel.count > 0) {
        self.mutiTabView.hidden = NO;
        self.mutiTabView.tabArray = model.pageLabel;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44.0f + 44.0f);
        }];
    }else {
        self.mutiTabView.hidden = YES;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44.0f);
        }];
    }
}

- (void)setupCurrentFiltersWithPageModel:(TeachingPageModel *)model{
    //0.首先,第一次进来的时候(第一次安装/退出app后再进来/切换学科学段),要设置默认的册和单元,课设置为全部;
    //1.其次,在上下滑动的过程中,筛选条件要随着变化到相应的位置;
    //2.还有,在点击图片全屏浏览的时候.也需要将筛选条件变化到相应的位置.
    //    if (!model.isStart && !model.isEnd) {
    //        return;
    //    }
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
    return self.dataArray[self.filterModel.volumChooseInteger];
}
@end
