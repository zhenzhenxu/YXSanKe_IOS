//
//  PagedListFetcherBase.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PagedListFetcherBase.h"

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

@end
