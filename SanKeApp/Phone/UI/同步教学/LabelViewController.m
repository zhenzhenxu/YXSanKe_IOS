//
//  LabelViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LabelViewController.h"
#import "GetLabelListRequest.h"
#import "LabelHeaderView.h"
#import "LabelTreeCell.h"
#import <RATreeView/RATreeView.h>

@interface LabelViewController ()<RATreeViewDataSource, RATreeViewDelegate>
@property (nonatomic, strong) GetLabelListRequest *selectionRequest;
@property (nonatomic, strong) NSArray *treeNodes;
@property (nonatomic, strong) RATreeView *treeView;

@end

@implementation LabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitle];
    [self setupUI];
    [self requestSelection];
    // Do any additional setup after loading the view.
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
    [self.treeView registerClass:[LabelTreeCell class] forCellReuseIdentifier:@"LabelTreeCell"];
    [self.view addSubview:self.treeView];
    [self.treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
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
        [self.treeView reloadData];
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
    BOOL isExpand = [treeView isCellForItemExpanded:item];
    GetLabelListRequestItem_Element *element = item;
    
    LabelTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"LabelTreeCell"];
    cell.isExpand = isExpand;
    cell.level = level;
    cell.element = element;
    WEAK_SELF
    [cell setTreeExpandBlock:^(LabelTreeCell *cell) {
        STRONG_SELF
        if (cell.isExpand) {
            [self.treeView collapseRowForItem:item];
        }else {
            [self.treeView expandRowForItem:item];
        }
        cell.isExpand = !cell.isExpand;
    }];
    [cell setTreeClickBlock:^(LabelTreeCell *cell) {
        GetLabelListRequestItem_Element *element = nil;
        if (level == 0) {
            return ;
        }
        element = cell.element;
        //跳转到资源详情页
        DDLogDebug(@"跳转到资源详情页");
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

- (void)refershLabelList {
    [self requestSelection];
}
@end
