//
//  PagedListViewControllerBase.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "MJRefresh.h"

@interface PagedListViewControllerBase () <UITableViewDataSource, UITableViewDelegate> {
    int _total;
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation PagedListViewControllerBase

- (id)init {
    self = [super init];
    if (self) {
        _bNeedHeader = YES;
        _bNeedFooter = YES;
        _bIsGroupedTableViewStyle = NO;
    }
    return self;
}

- (void)dealloc
{
    DDLogWarn(@"PagedListViewController Dealloc");
    [_header free];
    [_footer free];
    [self.dataFetcher stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[UIView alloc]init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
    if (self.bIsGroupedTableViewStyle) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    self.errorView = [[ErrorView alloc]init];
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self startLoading];
        [self firstPageFetch];
    }];
    self.dataErrorView = [[DataErrorView alloc]init];
    if (self.bNeedFooter) {
        _footer = [MJRefreshFooterView footer];
        _footer.scrollView = self.tableView;
        _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            @strongify(self); if (!self) return;
            [self morePageFetch];
        };
        _footer.alpha = 0;
    }
    
    if (self.bNeedHeader) {
        _header = [MJRefreshHeaderView header];
        _header.scrollView = self.tableView;
        _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            @strongify(self); if (!self) return;
            [self firstPageFetch];
        };
    }
    
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObjectsFromArray:[self.dataFetcher cachedItemArray]];
    _total = (int)[self.dataArray count];
    [self startLoading];
    [self firstPageFetch];
}
- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    
    [self.dataFetcher stop];
    
    // 1, load cache
    //    [self.dataArray removeAllObjects];
    //    [self.dataArray addObjectsFromArray:[self.dataFetcher cachedItemArray]];
    //    _total = (int)[self.dataArray count];
    
    // 2, fetch
    self.dataFetcher.lastID = 0;
    if (!self.dataFetcher.pageSize) {
        self.dataFetcher.pageSize = 20;
    }
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        
        [self tableViewWillRefresh];
        [self stopLoading];
        [self stopAnimation];
        
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = retItemArray.count != 0;
        data.localDataExist = self.dataArray.count != 0;
        data.error = error;
        if ([self handleRequestData:data inView:self.contentView]) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            return;
        }
        [self->_header setLastUpdateTime:[NSDate date]];
        self->_total = total;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:retItemArray];
        [self checkHasMore];
        [self.dataFetcher saveToCache];
        
        self.tableView.contentOffset = CGPointZero;
        [self.tableView reloadData];
    }];
}

- (void)tableViewWillRefresh
{
    
}

- (void)stopAnimation
{
    [self->_header endRefreshing];
}

- (void)setPulldownViewHidden:(BOOL)hidden
{
    _header.alpha = hidden ? 0:1;
}

- (void)setPullupViewHidden:(BOOL)hidden
{
    _footer.alpha = hidden ? 0:1;
}

- (void)morePageFetch {
    [self.dataFetcher stop];
    self.dataFetcher.lastID = self.dataFetcher.lastID + self.dataFetcher.pageSize;
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        [self->_footer endRefreshing];
        if (error) {
            self.dataFetcher.lastID = self.dataFetcher.lastID - self.dataFetcher.pageSize;
            [self showToast:error.localizedDescription];
            return;
        }
        
        [self.dataArray addObjectsFromArray:retItemArray];
        self->_total = total;
        [self.tableView reloadData];
        [self checkHasMore];
    }];
}

- (void)checkHasMore {
    // there is a bug is MJRefresh, so we use alpha instead of hidden
    [self setPullupViewHidden:[self.dataArray count] >= _total];
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}
@end
