//
//  StepTwoRequest.m
//  SanKeApp
//
//  Created by Lei Cai on 08/05/2017.
//  Copyright © 2017 niuzhaowang. All rights reserved.
//

#import "StepTwoRequest.h"

@interface StepTwoRequest ()
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *isexist;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *reserve;
@end

@implementation StepTwoRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"http://newupload.yanxiu.com/fileUpload";
    }
    return self;
}

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
    // set cookie
    NSMutableDictionary *cp1 = [NSMutableDictionary dictionary];
    [cp1 setObject:@"client_type" forKey:NSHTTPCookieName];
    [cp1 setObject:@"app" forKey:NSHTTPCookieValue];
    [cp1 setObject:@"newupload.yanxiu.com" forKey:NSHTTPCookieDomain];
    [cp1 setObject:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cp1];

    NSMutableDictionary *cp2 = [NSMutableDictionary dictionary];
    [cp2 setObject:@"passport" forKey:NSHTTPCookieName];
    [cp2 setObject:@"18333646084" forKey:NSHTTPCookieValue];
    [cp2 setObject:@"newupload.yanxiu.com" forKey:NSHTTPCookieDomain];
    [cp2 setObject:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cp2];
    
    [self.request setRequestCookies:[NSMutableArray arrayWithArray:@[cookie1, cookie2]]];
    
    // 参数
    self.status = @"upinfo";
    self.domain = @"main.zgjiaoyan.com";
    self.isexist = @"0";
    self.filename = @"iosTestFile";
    NSString *reserve = @"{\"typeId\":1000,\"title\":\"iosTestFile\",\"username\":\"研修网崔志伟\",\"uid\":20103549,\"shareType\":0,\"from\":6,\"source\":\"pc\",\"description\":\"\"}";
    self.reserve = reserve;
    
    [super startRequestWithRetClass:retClass andCompleteBlock:completeBlock];
}

@end
