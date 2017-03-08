//
//  UserInfoDataManger.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserInfo
@end
@interface UserInfo:JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *infoID;
@property (nonatomic ,strong) NSArray<UserInfo,Optional> *subInfo;
@end

@interface UserInfoModel:JSONModel
@property (nonatomic ,strong)NSArray<UserInfo,Optional> *userInfo;
@property (nonatomic, copy) NSString<Optional> *version;
@end


@interface UserInfoDataManger : NSObject
+ (AreaModel *)areaModel;
@end
