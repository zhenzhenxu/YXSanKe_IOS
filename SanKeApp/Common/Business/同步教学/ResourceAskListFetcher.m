//
//  ResourceAskListFetcher.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceAskListFetcher.h"
#import "ResourceAskListRequest.h"

@interface ResourceAskListFetcher ()
@property (nonatomic, strong) ResourceAskListRequest *request;
@end

@implementation ResourceAskListFetcher
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[ResourceAskListRequest alloc]init];
    self.request.objectid = self.resourceID;
    self.request.pageno = [NSString stringWithFormat:@"%ld", (long)self.pageNum];
    WEAK_SELF
    [self.request startRequestWithRetClass:[ResourceAskListItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock, 0, nil, error)
            return;
        }
        ResourceAskListItem *item = (ResourceAskListItem *)retItem;
        BLOCK_EXEC(aCompleteBlock, item.data.total, item.data.data, nil)
    }];
}
@end
