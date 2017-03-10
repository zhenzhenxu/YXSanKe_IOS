//
//  UploadHeadImgRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/2/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UploadHeadImgRequest.h"

@implementation UploadHeadImgRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/sankeUpload"];
    }
    return self;
}

@end
