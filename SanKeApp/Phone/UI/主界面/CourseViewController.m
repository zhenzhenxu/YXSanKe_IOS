//
//  CourseViewController.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTableViewCell.h"
#import "FilterSelectionView.h"
#import "YXRecordManager.h"
#import "PlayRecordViewController.h"
#import "CourseResListViewController.h"
#import "GetResListFetcher.h"
#import "GetResListRequest.h"

@implementation CourseVideoItem
@end
@interface CourseViewController ()
@property (nonatomic, strong) UIView *middleTabView;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *courseLabel;
@property (nonatomic, strong) FilterSelectionView *selectionView;
@property (nonatomic, strong) ChannelTabFilterRequest *selectionRequest;
@property (nonatomic, strong) FilterSelectedItem *filterSelectedItem;
@end

@implementation CourseViewController
- (void)dealloc{
    DDLogError(@"release====>%@,%@",NSStringFromClass([self class]),self.title);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestSelection];
    }];
    [self requestSelection];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kRecordReportSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kRecordDeletNotification object:nil];
}

- (void)refresh:(NSNotification *)notification {
    NSString *resourceID = notification.userInfo[kResourceIDKey];
    for (GetResListRequestItem_Data_Element *item in self.dataArray) {
        for (GetResListRequestItem_Data_Element_Res *res in item.resourceList) {
            if ([res.resoucrId isEqualToString:resourceID]) {
                [self startLoading];
                [self firstPageFetch];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setupUI
- (void)setupUI {
    [self setupMiddleTabView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.tableView registerClass:[CourseTableViewCell class] forCellReuseIdentifier:@"CourseTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10.0f)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.tableView.tableFooterView = footerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.middleTabView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setupMiddleTabView {
    self.middleTabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.middleTabView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.view addSubview:self.middleTabView];
    [self.middleTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *selectedLabel = [[UILabel alloc] init];
    selectedLabel.text = @"已选：";
    selectedLabel.font = [UIFont systemFontOfSize:12.0f];
    selectedLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.middleTabView addSubview:selectedLabel];
    [selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    
    self.volumeLabel = [[UILabel alloc] init];
    self.volumeLabel.layer.cornerRadius = 2;
    self.volumeLabel.layer.borderColor = [UIColor colorWithHexString:@"4691a6"].CGColor;
    self.volumeLabel.layer.borderWidth = 1;
    self.volumeLabel.font = [UIFont systemFontOfSize:11.0f];
    self.volumeLabel.textColor = [UIColor colorWithHexString:@"4691a6"];
    self.volumeLabel.textAlignment = NSTextAlignmentCenter;
    [self.middleTabView addSubview:self.volumeLabel];
    [self.volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selectedLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(54, 20));
    }];
    
    self.unitLabel = [[UILabel alloc] init];
    self.unitLabel.layer.cornerRadius = 2;
    self.unitLabel.layer.borderColor = [UIColor colorWithHexString:@"4691a6"].CGColor;
    self.unitLabel.layer.borderWidth = 1;
    self.unitLabel.font = [UIFont systemFontOfSize:11.0f];
    self.unitLabel.textColor = [UIColor colorWithHexString:@"4691a6"];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.hidden = YES;
    [self.middleTabView addSubview:self.unitLabel];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.volumeLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(54, 20));
    }];
    
    self.courseLabel = [[UILabel alloc] init];
    self.courseLabel.layer.cornerRadius = 2;
    self.courseLabel.layer.borderColor = [UIColor colorWithHexString:@"4691a6"].CGColor;
    self.courseLabel.layer.borderWidth = 1;
    self.courseLabel.font = [UIFont systemFontOfSize:11.0f];
    self.courseLabel.textColor = [UIColor colorWithHexString:@"4691a6"];
    self.courseLabel.textAlignment = NSTextAlignmentCenter;
    self.courseLabel.hidden = YES;
    [self.middleTabView addSubview:self.courseLabel];
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.unitLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(54, 20));
    }];
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame = CGRectMake(kScreenWidth - 50, 10, 40, 20);
    filterBtn.backgroundColor = [UIColor colorWithHexString:@"4691a6"];
    filterBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterBtn setImage:[UIImage imageNamed:@"筛选展开"] forState:UIControlStateNormal];
    [filterBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -filterBtn.imageView.width-2.5, 0, filterBtn.imageView.width+2.5)];
    [filterBtn setImageEdgeInsets:UIEdgeInsetsMake(0, filterBtn.titleLabel.width+2.5, 0, -filterBtn.titleLabel.width-2.5)];
    filterBtn.layer.cornerRadius = 2;
    [filterBtn addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.middleTabView addSubview:filterBtn];
}

- (void)filterButtonAction:(UIButton *)sender {
    [self showSelectionView];
}

- (void)setFilterSelectedItem:(FilterSelectedItem *)filterSelectedItem {
    _filterSelectedItem = filterSelectedItem;
    self.volumeLabel.text = filterSelectedItem.volume.name;
    self.unitLabel.text = filterSelectedItem.unit.name;
    self.courseLabel.text = filterSelectedItem.course.name;
    
    self.unitLabel.hidden = isEmpty(filterSelectedItem.unit.name);
    self.courseLabel.hidden = isEmpty(filterSelectedItem.course.name);
}

- (void)showSelectionView {
    FilterSelectionView *selectionView = self.selectionView;
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = selectionView;
    CGFloat selectionViewHeight = 85.f;
    if ([self.videoItem.code isEqualToString:@"gjdw_tab"]) {
        selectionViewHeight = 170.f;
    } else if ([self.videoItem.code isEqualToString:@"klym_tab"]) {
        selectionViewHeight = 255.f / 667 * kScreenHeight;
    }
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(view.mas_top);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(selectionViewHeight + 69);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [selectionView cancelReset];
            [view removeFromSuperview];
        }];
    }];
    [alert showInView:self.view withLayout:^(AlertView *view) {
        STRONG_SELF
        [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(view.mas_top);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(selectionViewHeight + 69);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view.mas_top);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(selectionViewHeight + 69);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [selectionView setCompleteBlock:^(FilterSelectedItem *selectedItem) {
        STRONG_SELF
        [alert hide];
        self.filterSelectedItem = selectedItem;
        YXProblemItem *item = [[YXProblemItem alloc]init];
        item.edition_id = @"720175";
        item.volume_id = selectedItem.volume.filterID;
        item.unit_id = selectedItem.unit.filterID;
        item.course_id = selectedItem.course.filterID;
        self.recordItem = item;
        
        GetResListFetcher *fetcher = (GetResListFetcher *)self.dataFetcher;
        if (!isEmpty(selectedItem.volume)) {
            fetcher.moduleId = selectedItem.volume.filterID;
            if (!isEmpty(selectedItem.unit)) {
                fetcher.moduleId = selectedItem.unit.filterID;
                if (!isEmpty(selectedItem.course)) {
                    fetcher.moduleId = selectedItem.course.filterID;
                }
            }
        }
        [self startLoading];
        [self firstPageFetch];
    }];
}

- (void)requestSelection{
    [self.selectionRequest stopRequest];
    self.selectionRequest = [ChannelTabFilterRequest new];
    self.selectionRequest.catid = self.videoItem.catID;
    self.selectionRequest.code = self.videoItem.code;
    WEAK_SELF
    [self.selectionRequest startRequestWithRetClass:[ChannelTabFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        UnhandledRequestData *data = [[UnhandledRequestData alloc] init];
        data.requestDataExist = !isEmpty(retItem);
        data.error = error;
        if ([self handleRequestData:data inView:self.contentView]) {
            return;
        }
        ChannelTabFilterRequestItem *item = retItem;
        self.selectionView = [[FilterSelectionView alloc]init];
        self.selectionView.data = item.data;
        self.selectionView.sectionId = self.videoItem.catID;
        self.selectionView.hasCourseFilter = [self.videoItem.code isEqualToString:@"klym_tab"];
        
        ChannelTabFilterRequestItem_filter *volume = item.data.filters.firstObject;
        ChannelTabFilterRequestItem_filter *unit = volume.subFilters.firstObject;
        FilterSelectedItem *selectedItem = [[FilterSelectedItem alloc] init];
        selectedItem.volume = volume;
        selectedItem.unit = [self.videoItem.code isEqualToString:@"gjdw_tab"] ? unit : nil;
        self.filterSelectedItem = selectedItem;
        
        GetResListFetcher *fetcher = [[GetResListFetcher alloc] init];
        if (!isEmpty(selectedItem.volume)) {
            fetcher.moduleId = selectedItem.volume.filterID;
            if (!isEmpty(selectedItem.unit)) {
                fetcher.moduleId = selectedItem.unit.filterID;
                if (!isEmpty(selectedItem.course)) {
                    fetcher.moduleId = selectedItem.course.filterID;
                }
            }
        }
        fetcher.tab_type = self.videoItem.code;
        fetcher.pageSize = 10;
        self.dataFetcher = fetcher;
        self.requestDelegate = self.dataFetcher;
        [self startLoading];
        [self firstPageFetch];
    }];
}

- (void)checkHasMore {
    [self setPullupViewHidden:_total <= 0];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell" forIndexPath:indexPath];
    if (self.dataArray.count <= 1) {
        cell.cellStatus = RadianBaseCellStatus_Top | RadianBaseCellStatus_Bottom;
    }else {
        if (indexPath.row == 0) {
            cell.cellStatus = RadianBaseCellStatus_Top;
        } else if (indexPath.row < self.dataArray.count - 1) {
            cell.cellStatus = RadianBaseCellStatus_Middle;
        } else {
            cell.cellStatus = RadianBaseCellStatus_Bottom;
        }
    }
    GetResListRequestItem_Data_Element *element = self.dataArray[indexPath.row];
    cell.element = element;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseResListViewController *vc = [[CourseResListViewController alloc] init];
    GetResListRequestItem_Data_Element *element = self.dataArray[indexPath.row];
    NSMutableArray *resArray = [NSMutableArray arrayWithArray:element.resourceList];
    GetResListRequestItem_Data_Element_Res *res = [[GetResListRequestItem_Data_Element_Res alloc] init];
    res.title = element.title;
    [resArray insertObject:res atIndex:0];
    vc.catID = self.videoItem.catID;
    vc.resListArray = resArray;
    vc.recordItem = self.recordItem;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
