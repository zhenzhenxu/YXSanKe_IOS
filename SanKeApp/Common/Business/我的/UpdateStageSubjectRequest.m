//
//  UpdateStageSubjectRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpdateStageSubjectRequest.h"



@implementation UpdateStageSubjectRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/user/update_info"];
    }
    return self;
}
@end
