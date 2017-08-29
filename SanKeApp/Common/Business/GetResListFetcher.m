//
//  GetResListFetcher.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetResListFetcher.h"
#import "GetResListRequest.h"

@interface GetResListFetcher ()
@property (nonatomic, strong) GetResListRequest *request;
@end

@implementation GetResListFetcher
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetResListRequest alloc]init];
    self.request.moduleId = self.moduleId;
    self.request.tab_type = self.tab_type;
    self.request.page_size = [NSString stringWithFormat:@"%@", @(self.pageSize)];
    self.request.last_id = [NSString stringWithFormat:@"%@", @(self.lastID)];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetResListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        GetResListRequestItem *item = (GetResListRequestItem *)retItem;
        self.lastID += item.data.items.count;
        BLOCK_EXEC(aCompleteBlock, item.data.moreData.integerValue, item.data.items, nil)
    }];
}
@end
