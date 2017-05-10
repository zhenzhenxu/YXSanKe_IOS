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

@interface TeachingMainViewController ()<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate,TeachingFilterViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *photoUrlArray;
@property (nonatomic, strong) NSArray <NSArray *>*dataArray;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) TeachingFilterView *filterView;
@property (nonatomic, strong) NSArray <NSArray *>*filterDataArray;
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
    
    [self setupMockFilterData];
    [self setupFilterView];
//     [self dealWithFilterModel:[TeachingFiterModel mockFilterData]];
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

- (void)setupMockFilterData {
    // 学科
    NSArray *volumeArray = @[
                             @"七年级上",
                             @"七年级下"
                             ];
    NSArray *unitArray = @[
                           @"第一单元 阅读",
                           @"第一单元 写作",
                           @"第二单元 阅读",
                           @"第二单元 写作",
                           @"第二单元 综合性学习",
                           @"第三单元 阅读",
                           @"第三单元 写作",
                           @"第三单元 名著导读",
                           @"第三单元 课外古诗词诵读",
                           @"第四单元 阅读",
                           @"第四单元 写作",
                           @"第四单元 综合性学习",
                           @"第五单元 阅读",
                           @"第五单元 写作",
                           @"第六单元 阅读",
                           @"第六单元 写作",
                           @"第六单元 综合性学习",
                           @"第六单元 名著导读",
                           @"第六单元 课外古诗词诵读"
                           ];
    NSArray *courseArray = @[
                             @"全部",
                             @"1 春/朱自清",
                             @"2 济南的春天/老舍",
                             @"第三课",
                             @"第四课",
                             @"第五课"
                             ];
    self.filterDataArray = [NSArray arrayWithObjects:volumeArray,unitArray,courseArray, nil];
}

- (void)setupFilterView {
    TeachingFilterView *filterView = [[TeachingFilterView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.filterView = filterView;
    for (NSArray *group in self.filterDataArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *filter in group) {
            [array addObject:filter];
        }
        [filterView addFilters:array forKey:group.firstObject];
    }
    [self setupWithCurrentFilters];
    filterView.delegate = self;
    [self.view addSubview:filterView];
}

- (void)dealWithFilterModel:(TeachingFiterModel *)model{
    TeachingFilterView *filterView = [[TeachingFilterView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.filterView = filterView;
    for (TeachingFiterGroup *group in model.groupArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (TeachingFilter *filter in group.filterArray) {
            [array addObject:filter.name];
        }
        [filterView addFilters:array forKey:group.name];
    }
    [self setupWithCurrentFilters];
    filterView.delegate = self;
    [self.view addSubview:filterView];
}

#pragma mark - YXCourseFilterViewDelegate
- (void)filterChanged:(NSArray *)filterArray{
    DDLogDebug(@"滚动到筛选的位置");
}

- (void)setupWithCurrentFilters{
    //在上下滑动浏览/图片浏览器左右滑动的时候,滑动到相应的课程的时候要重置筛选框显示的内容.
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
