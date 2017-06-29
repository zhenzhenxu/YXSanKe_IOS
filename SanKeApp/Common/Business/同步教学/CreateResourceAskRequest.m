//
//  CreateResourceAskRequest.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CreateResourceAskRequest.h"

@implementation CreateResourceAskRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/create_res_ask"];
        self.replyed_comment_id = @"0";
        self.action = @"create";
        self.objecttype = @"16";
        self.parentid = @"0";
        self.istruename = @"1";
    }
    return self;
}

@end
