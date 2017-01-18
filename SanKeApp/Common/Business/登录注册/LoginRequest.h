//
//  LoginRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface LoginRequest : YXGetRequest
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password; // md5加密
@end
