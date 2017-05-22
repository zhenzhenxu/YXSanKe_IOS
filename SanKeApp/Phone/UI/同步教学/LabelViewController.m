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
#import "LabelTableViewCell.h"

@interface LabelViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) GetLabelListRequest *selectionRequest;
@property (nonatomic, strong) GetLabelListRequestItem *dataSourceItem;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
//    UILabel *label = [[UILabel alloc]init];
//    label.text = self.label.name;
//    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(0);
//    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupUI {
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestSelection];
    }];
    self.dataErrorView = [[DataErrorView alloc]init];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 335.0f;
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[LabelTableViewCell class] forCellReuseIdentifier:@"LabelTableViewCell"];
    [self.tableView registerClass:[LabelHeaderView class] forHeaderFooterViewReuseIdentifier:@"LabelHeaderView"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
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
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        GetLabelListRequestItem *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = item.data.elements.count > 0 ? YES : NO;
        data.localDataExist = NO;//等等
        data.error = error;
        if ([self handleRequestData:data inView:self.view]) {
            return;
        }
        
        //刷新tableView
    }];
}

#pragma mark - UITableViewDataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceItem.data.elements.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GetLabelListRequestItem_Element *element = self.dataSourceItem.data.elements[section];
    return element.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelTableViewCell"];
    cell.textLabel.text = @"测试测试";
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LabelHeaderView *header = (LabelHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LabelHeaderView"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

@end
