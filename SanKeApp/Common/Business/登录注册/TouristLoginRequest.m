//
//  TouristLoginRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TouristLoginRequest.h"

@implementation TouristLoginRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/passport/login"];
    }
    return self;
}
@end
