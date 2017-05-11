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

@interface TeachingMainViewController ()<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate,TeachingFilterViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *photoUrlArray;
@property (nonatomic, strong) NSArray <NSArray *>*dataArray;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) TeachingFilterView *filterView;
@property (nonatomic, strong) TeachingFiterModel *filterModel;
@end

@implementation TeachingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTitle];
    [self setupUI];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kStageSubjectDidChangeNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupTitle];
    }];
    
    self.filterModel = [TeachingFiterModel modelFromRawData:[GetBookInfoRequestItem mockGetBookInfoRequestItem]];
    [self dealWithFilterModel:self.filterModel];
    [self setupMockData];
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
        make.top.mas_equalTo(44.0f);
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
    [self.dataArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.filterView setCurrentIndex:0 forKey:obj.firstObject];
    }];
}


- (void)setupMockData {
    NSArray *array0 = @[
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide1.jpg",//第一单元
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide2.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide3.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide4.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide5.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide6.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide7.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide8.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide9.jpg"
                        ];
    NSArray *array1 = @[
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide17.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide17.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide18.jpg"
                        ];
    NSArray *array2 = @[
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide19.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide20.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide21.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide22.jpg"
                        ];
    NSArray *array3 = @[
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide32.jpg",
                        @"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide33.jpg"
                        ];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:array0,array1,array2,array3, nil];
    self.dataArray = array.copy;
    
}

#pragma mark - UITableViewDataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeachingMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeachingMainCell"];
    cell.url = self.dataArray[indexPath.section][indexPath.row];
    WEAK_SELF
    [cell setSelectedButtonActionBlock:^{
        STRONG_SELF
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        //            browser.displayActionButton = NO; //分享保存等的功能,默认是
        //        browser.displayNavArrows = NO;//左右分页切换(底部显示左右的三角按钮来翻页,同时若此时分享按钮显示,则也在底部显示),默认否
        //        browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上(右上角的对勾),默认否
        //        browser.alwaysShowControls = NO;//顶部的导航条以及页数是否一直显示(no则点击时显示-->隐藏->显示;yes则一直显示),默认否
        //        browser.zoomPhotosToFill = YES;//是否全屏(图片整张占满导航),默认是
        //        browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是(yes查看所有 no逐个加载)
        //        browser.startOnGrid = NO;//是否第一张,默认否(目前并没有发现这个有什么用)
        //        browser.enableSwipeToDismiss = YES;//是否开始对缩略图网格代替第一张照片.
        
        self.photoBrowser = browser;
        //设置当前要显示的图片
        [self.photoBrowser setCurrentPhotoIndex:1];
        
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
- (void)setupBrowser {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    //            browser.displayActionButton = NO; //分享保存等的功能,默认是
    //        browser.displayNavArrows = NO;//左右分页切换(底部显示左右的三角按钮来翻页,同时若此时分享按钮显示,则也在底部显示),默认否
    //        browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上(右上角的对勾),默认否
    //        browser.alwaysShowControls = NO;//顶部的导航条以及页数是否一直显示(no则点击时显示-->隐藏->显示;yes则一直显示),默认否
    //        browser.zoomPhotosToFill = YES;//是否全屏(图片整张占满导航),默认是
    //        browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是(目前并没有发现这个有什么用)
    //        browser.startOnGrid = NO;//是否第一张,默认否(目前并没有发现这个有什么用)
    //        browser.enableSwipeToDismiss = YES;//不知道干啥的.
    
    self.photoBrowser = browser;
    
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    //    __block NSInteger count;
    //    [self.dataArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        count += obj.count;
    //    }];
    //    return count;
    return 18;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    DDLogDebug(@"%@", @(index));
    if (index < 18) {
        MWPhoto *ptoto = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://userfile.sanke.zgjiaoyan.com/upload/storage/public/sanke/tbook/2017_03_08/1488968694_288389035/image/slide33.jpg"]];
        return ptoto;
    }
    return nil;
}

@end
