//
//  TeachingMainViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingMainViewController.h"
#import "TeachingMainCell.h"
#import "TeachingContentsModel.h"
#import "GetBookInfoRequest.h"
#import "TeachingPageModel.h"
#import "TeachingMutiLabelView.h"
#import "LabelViewController.h"
#import "PhotoBrowserController.h"
#import "QASlideView.h"
#import "TeachingContentsView.h"
#import "GetMarkDetailRequest.h"
#import "MarkDetailView.h"

@interface TeachingMainViewController ()<QASlideViewDataSource, QASlideViewDelegate>
@property (nonatomic, assign) BOOL shouldReserveFilter;
#pragma mark - data
@property (nonatomic, strong) GetBookInfoRequest *getBookInfoRequest;
@property (nonatomic, strong) GetMarkDetailRequest *request;
@property (nonatomic, strong) NSArray <NSArray<TeachingPageModel *> *>*dataArray;
@property (nonatomic, strong) NSArray<TeachingPageModel *> *currentVolumDataArray;
@property (nonatomic, strong) TeachingContentsModel *contentsModel;
#pragma mark - view
@property (nonatomic, strong) TeachingMutiLabelView *mutiTabView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) QASlideView *tableView;
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
    
    [self setupTitle];
    [self setupCurrentContent];
    [self setupObserver];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!self.shouldReserveFilter && self.mutiTabView.expandBtn.selected) {
        [self.mutiTabView expandBtnAction];
    }
    self.shouldReserveFilter = NO;
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
       
        self.contentsModel = [TeachingContentsModel modelFromRawData:item];
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
        
        [self.tableView scrollToItemIndex:currentIndex animated:NO];
        TeachingMainCell *cell = [self.tableView itemViewAtIndex:currentIndex];
        TeachingPageModel *model = cell.model;
        [self setupCurrentPageLabelWithPageModel:model];
        [self updateContentsModelWithPageModel:model];
    }];
}

- (void)setupUI {
    self.tableView = [[QASlideView alloc]initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
    
    UIButton *contentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contentsButton.frame = CGRectMake(15, self.view.bounds.size.height - 20 - 49, 50, 50);
    [contentsButton setImage:[UIImage imageNamed:@"目录"] forState:UIControlStateNormal];
    [contentsButton addTarget:self action:@selector(contentsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contentsButton];
    [self.view bringSubviewToFront:contentsButton];
}

- (void)contentsButtonAction:(UIButton *)sender {
    TeachingContentsView *contentsView = [[TeachingContentsView alloc] init];
    contentsView.data = self.contentsModel;
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = contentsView;
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [contentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(view.mas_left);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(kScreenWidth - 50);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [contentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view.mas_left);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth - 50);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [contentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view.mas_left);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(kScreenWidth - 50);
            }];
            [view layoutIfNeeded];
        }];
    }];
    
    contentsView.pageChooseBlock = ^(TeachingContentsModel *model) {
        STRONG_SELF
        [alert hide];
        
        self.contentsModel = model;
        [self scrollToCurrentPosition];
        [self.tableView reloadData];
    };
}

- (void)setupMutiTabView {
    self.mutiTabView = [[TeachingMutiLabelView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [self.view addSubview:self.mutiTabView];
    WEAK_SELF
    [self.mutiTabView setClickTabButtonBlock:^{
        STRONG_SELF
        self.shouldReserveFilter = YES;
        GetBookInfoRequestItem_Volum *volum = self.contentsModel.volums[self.contentsModel.volumChooseInteger];
        GetBookInfoRequestItem_Unit *unit = self.contentsModel.units[self.contentsModel.unitChooseInteger];
        GetBookInfoRequestItem_Course *course = nil;
        if (self.contentsModel.courseChooseInteger >= 0) {
            course = self.contentsModel.courses[self.contentsModel.courseChooseInteger];
        }
        
        LabelViewController *vc = [[LabelViewController alloc]init];
        vc.label = self.mutiTabView.tabArray[self.mutiTabView.currentTabIndex];
        vc.volum = volum;
        vc.unit = unit;
        vc.course = course;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - contentsUpdate
- (void)scrollToCurrentPosition {
    
    GetBookInfoRequestItem_Volum *volum = self.contentsModel.volums[self.contentsModel.volumChooseInteger];
    GetBookInfoRequestItem_Unit *unit = self.contentsModel.units[self.contentsModel.unitChooseInteger];
    GetBookInfoRequestItem_Course *course = nil;
    if (self.contentsModel.courseChooseInteger >= 0) {
        course = self.contentsModel.courses[self.contentsModel.courseChooseInteger];
    }
    NSString *filter;
    if (isEmpty(course.courseID)) {
        filter = [NSString stringWithFormat:@"%@,%@",volum.volumID,unit.unitID];
    }else {
        filter = [NSString stringWithFormat:@"%@,%@,%@",volum.volumID,unit.unitID,course.courseID];
    }
    [self.currentVolumDataArray enumerateObjectsUsingBlock:^(TeachingPageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.pageTarget isEqualToString:filter] && obj.isStart) {
            [self.tableView scrollToItemIndex:idx animated:NO];
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

- (void)updateContentsModelWithPageModel:(TeachingPageModel *)model {
    GetBookInfoRequestItem_Volum *volum = self.contentsModel.volums[self.contentsModel.volumChooseInteger];
    
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
            [self.contentsModel.units enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Unit * _Nonnull unit, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([array.firstObject isEqualToString:unit.unitID]) {
                    self.contentsModel.unitChooseInteger = idx;
                    self.contentsModel.courseChooseInteger = -1;
                    *stop = YES;
                }
            }];
        }
        if (array.count == 2) {
            [self.contentsModel.units enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Unit * _Nonnull unit, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([array.firstObject isEqualToString:unit.unitID]) {
                    self.contentsModel.unitChooseInteger = idx;
                    self.contentsModel.courseChooseInteger = 0;
                    *stop = YES;
                }
            }];
            [self.contentsModel.courses enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Course * _Nonnull course, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([array.lastObject isEqualToString:course.courseID]) {
                    self.contentsModel.courseChooseInteger = idx;
                }
            }];
        }
    }
}

- (void)setupCurrentPageLabelWithPageModel:(TeachingPageModel *)model {
    if (model.pageLabel.count > 0) {
        self.mutiTabView.hidden = NO;
        self.lineView.hidden = NO;
        self.mutiTabView.tabArray = model.pageLabel;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 0, 0));
        }];
    }else {
        self.mutiTabView.hidden = YES;
        self.lineView.hidden = YES;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
}

#pragma mark - showMarkerDetail
- (void)fetchMarkDetailWithMarkBtn:(UIButton *)markBtn isLineBtn:(BOOL)isLineBtn currentModel:(TeachingPageModel *)model {
    GetBookInfoRequestItem_Marker *marker = model.mark.marker[markBtn.tag - markBtn.tag / 1000 * 1000];
    GetBookInfoRequestItem_Marker_Item *currentMark = isLineBtn ? marker.lines[markBtn.tag / 1000] : marker.icons[markBtn.tag / 1000];
    
    if (isEmpty(currentMark.textInfo)) {
        [self.request stopRequest];
        self.request = [[GetMarkDetailRequest alloc]init];
        self.request.marker_id = marker.markerID;
        if (isLineBtn) {
            self.request.line_id = currentMark.itemID;
        } else {
            self.request.icon_id = currentMark.itemID;
        }
        [self startLoading];
        WEAK_SELF
        [self.request startRequestWithRetClass:[GetMarkDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            if (error) {
                [self showToast:error.localizedDescription];
                return ;
            }
            GetMarkDetailRequestItem *item = (GetMarkDetailRequestItem *)retItem;
            if (isEmpty(item.data)) {
                [self showToast:@"暂无内容"];
                return;
            }
            currentMark.textInfo = item.data.textInfo;
            [self showMarkerDetailWithTextInfo:currentMark.textInfo markBtn:markBtn];
        }];
    } else {
        [self showMarkerDetailWithTextInfo:currentMark.textInfo markBtn:markBtn];
    }
}

- (void)showMarkerDetailWithTextInfo:(NSString *)textInfo markBtn:(UIButton *)markBtn {
    MarkDetailView *markDetailView = [[MarkDetailView alloc] init];
    markDetailView.textInfo = textInfo;
    markDetailView.markBtn = markBtn;
    
    AlertView *alert = [[AlertView alloc] init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = markDetailView;
    [alert showWithLayout:nil];
}

#pragma mark - QASlideViewDataSource & QASlideViewDelegate
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.currentVolumDataArray.count;
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    TeachingMainCell *cell = [[TeachingMainCell alloc] init];
    TeachingPageModel *model = self.currentVolumDataArray[index];
    cell.model = model;
    if (index == 0) {
        [self setupCurrentPageLabelWithPageModel:model];
    }
    WEAK_SELF
    [cell setSelectedButtonActionBlock:^{
        STRONG_SELF
        PhotoBrowserController *pbController = [[PhotoBrowserController alloc] init];
        pbController.currentVolumDataArray = self.currentVolumDataArray;
        pbController.currentIndex = index;
        [self.navigationController pushViewController:pbController animated:NO];
    }];
    
    cell.markView.markerBtnBlock = ^(UIButton *markBtn, BOOL isLineBtn) {
        STRONG_SELF
        [self fetchMarkDetailWithMarkBtn:markBtn isLineBtn:isLineBtn currentModel:model];
    };
    return cell;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    TeachingPageModel *model = self.currentVolumDataArray[to];
    [self setupCurrentPageLabelWithPageModel:model];
    [self updateContentsModelWithPageModel:model];
}

- (void)slideViewDidReachMostLeft:(QASlideView *)slideView {
    [self showToast:@"已翻到首页"];
}

- (void)slideViewDidReachMostRight:(QASlideView *)slideView {
    [self showToast:@"已翻到末页"];
}

#pragma mark - getter
- (NSArray<TeachingPageModel *> *)currentVolumDataArray {
    return self.dataArray[self.contentsModel.volumChooseInteger];
}

@end
