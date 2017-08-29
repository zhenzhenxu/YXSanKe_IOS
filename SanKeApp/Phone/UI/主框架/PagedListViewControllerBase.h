//
//  PagedListViewControllerBase.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "BaseViewController.h"
#import "PagedListFetcherBase.h"

@interface PagedListViewControllerBase : BaseViewController<UITableViewDataSource, UITableViewDelegate> {
    NSInteger _total;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL bIsGroupedTableViewStyle;    // currently trick
@property (nonatomic, strong) NSMutableArray *dataArray;        // the model
@property (nonatomic, assign) BOOL bNeedHeader;
@property (nonatomic, assign) BOOL bNeedFooter;
@property (nonatomic, weak) id<PageListRequestDelegate> requestDelegate;

@property (nonatomic, strong) PagedListFetcherBase *dataFetcher;
- (void)firstPageFetch;
- (void)morePageFetch;
- (void)checkHasMore;
- (void)stopAnimation;
- (void)setPulldownViewHidden:(BOOL)hidden;
- (void)setPullupViewHidden:(BOOL)hidden;
- (void)refreshUIWhenDataIsNotEmpty;

@property (nonatomic, assign) int emptyViewTopInset;


@end
