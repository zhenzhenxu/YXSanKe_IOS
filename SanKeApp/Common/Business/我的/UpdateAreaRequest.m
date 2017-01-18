//
//  UpdateAreaRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpdateAreaRequest.h"

@implementation UpdateAreaRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/user/update_info"];
    }
    return self;
}
@end
