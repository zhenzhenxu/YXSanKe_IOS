//
//  PagedListFetcherBase.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PagedListFetcherBase.h"

@implementation PagedListFetcherBase

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
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
