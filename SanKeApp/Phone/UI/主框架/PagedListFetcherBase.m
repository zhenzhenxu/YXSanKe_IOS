//
//  PagedListFetcherBase.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface PagedListFetcherBase()
@property (nonatomic, assign) NSInteger pre_pageNum;
@property (nonatomic, assign) NSInteger pre_lastID;
@end

@implementation PagedListFetcherBase

- (instancetype)init {
    if (self = [super init]) {
        self.pageSize = 10;
        self.pageNum = 0;
        self.lastID = 0;
    }
    return self;
}

- (void)startWithBlock:(void(^)(NSInteger total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    _completeBlock = aCompleteBlock;
}

- (void)stop {
    
}

- (NSArray *)cachedItemArray {
    return nil;
}

- (int)cachedTotalNumber {
    return INT16_MAX;   // default to always allow load more even in cache mode
}

- (void)saveToCache {
    
}

#pragma mark - PageListRequestDelegate
- (void)requestWillRefresh {
    self.pre_pageNum = self.pageNum;
    self.pre_lastID = self.lastID;
    self.pageNum = 0;
    self.lastID = 0;
}

- (void)requestEndRefreshWithError:(NSError *)error {
    if (error) {
        self.pageNum = self.pre_pageNum;
        self.lastID = self.pre_lastID;
    }
}

- (void)requestWillFetchMore {
    self.pageNum += 1;
}

- (void)requestEndFetchMoreWithError:(NSError *)error {
    if (error) {
        self.pageNum -= 1;
    }
}

@end
