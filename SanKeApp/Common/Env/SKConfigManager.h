//
//  SKConfigManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2016/12/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SKConfigManager : JSONModel
+ (SKConfigManager *)sharedInstance;

@property (nonatomic, strong) NSString<Optional> *server;      // 切换正式、测试环境 Url Header
@property (nonatomic, strong) NSString<Optional> *loginServer;
@property (nonatomic, strong) NSString<Optional> *uploadServer;
@property (nonatomic, strong) NSString<Optional> *websocketServer;
@property (nonatomic, strong) NSString<Optional> *initializeUrl;
@property (nonatomic, strong) NSString<Optional> *mode;

@property (nonatomic, strong) NSString<Ignore> *appName;
@property (nonatomic, strong) NSString<Ignore> *clientVersion;

@property (nonatomic, strong) NSString<Ignore> *deviceID;
@property (nonatomic, strong) NSString<Ignore> *deviceType;
@property (nonatomic, strong) NSString<Ignore> *deviceName;

@property (nonatomic, strong) NSString<Ignore> *osType;
@property (nonatomic, strong) NSString<Ignore> *osVersion;

@property (nonatomic, strong) NSNumber<Optional> *mockFrameworkOn;
@property (nonatomic, strong) NSNumber<Optional> *testFrameworkOn;

@property (nonatomic, strong) NSString<Optional> *TalkingDataAppID;
@property (nonatomic, strong) NSString<Optional> *channel;
@end
