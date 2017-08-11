//
//  LabelViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LabelViewController.h"
#import "GetLabelListRequest.h"
#import "LabelTreeCell.h"
#import <RATreeView/RATreeView.h>
#import "ResourceDetailViewController.h"

@interface LabelViewController ()<RATreeViewDataSource, RATreeViewDelegate>
@property (nonatomic, strong) GetLabelListRequest *selectionRequest;
@property (nonatomic, strong) NSArray *treeNodes;
@property (nonatomic, strong) RATreeView *treeView;

@end

@implementation LabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.label.name;
    [self setupUI];
    [self uploadRecord];
    [self requestSelection];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"很抱歉,该标签下暂无资源";
    
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestSelection];
    }];
    
    self.dataErrorView = [[DataErrorView alloc]init];
    
    self.treeView = [[RATreeView alloc] initWithFrame:CGRectZero style:RATreeViewStylePlain];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.showsVerticalScrollIndicator = NO;
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    self.treeView.rowHeight = UITableViewAutomaticDimension;
    self.treeView.rowsCollapsingAnimation = RATreeViewRowAnimationFade;
    self.treeView.rowsExpandingAnimation = RATreeViewRowAnimationFade;
    [self.treeView registerClass:[LabelTreeCell class] forCellReuseIdentifier:@"LabelTreeCell"];
    [self.view addSubview:self.treeView];
    [self.treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)uploadRecord {
    YXProblemItem *item = [[YXProblemItem alloc] init];
    item.grade = [UserManager sharedInstance].userModel.stageID;
    item.subject = [UserManager sharedInstance].userModel.subjectID;
    item.volume_id = self.volum.volumID;
    item.unit_id = self.unit.unitID;
    item.course_id = self.course.courseID;
    item.tag_id = self.label.labelID;
    item.type = YXRecordClickType;
    item.objType = @"filter_tbjx";
    [YXRecordManager addRecord:item];
}

- (void)requestSelection{
    [self.selectionRequest stopRequest];
    self.selectionRequest = [[GetLabelListRequest alloc]init];
    self.selectionRequest.labelID = self.label.labelID;
    [self startLoading];
    WEAK_SELF
    [self.selectionRequest startRequestWithRetClass:[GetLabelListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        GetLabelListRequestItem *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = item.data.elements.count > 0 ? YES : NO;
        data.localDataExist = self.treeNodes.count> 0 ? YES : NO;
        data.error = error;
        if ([self handleRequestData:data inView:self.view]) {
            return;
        }
        self.treeNodes = item.data.elements;
        self.treeView.contentOffset = CGPointZero;
        [self.treeView reloadData];
        for (GetLabelListRequestItem_Element *element in item.data.elements) {
            [self.treeView expandRowForItem:element];
        }
    }];
}

#pragma mark - RATreeViewDataSource
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (!item) {
        return self.treeNodes.count;
    }
    id<TreeNodeProtocol> node = item;
    return [node subNodes].count;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        return self.treeNodes[index];
    }
    id<TreeNodeProtocol> node = item;
    return [node subNodes][index];
}

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    GetLabelListRequestItem_Element *element = item;
    
    LabelTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"LabelTreeCell"];
    cell.isExpand = YES;
    cell.level = level;
    cell.element = element;
    [cell setTreeClickBlock:^(LabelTreeCell *cell) {
        GetLabelListRequestItem_Element *element = nil;
        if (level == 0) {
            return ;
        }
        element = cell.element;
        DDLogDebug(@"跳转到资源详情页");
        ResourceDetailViewController *resourceDetailVC = [[ResourceDetailViewController alloc] init];
        resourceDetailVC.resourceID = cell.element.elementID;
        [self.navigationController pushViewController:resourceDetailVC animated:YES];
    }];
    return cell;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}

#pragma mark - RATreeViewDelegate
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item {
    return NO;
}

- (BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item {
    return NO;
}

@end
