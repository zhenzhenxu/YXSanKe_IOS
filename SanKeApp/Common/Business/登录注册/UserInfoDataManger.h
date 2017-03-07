//
//  UserInfoDataManger.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel:JSONModel
@property (nonatomic ,copy)NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *Id;
@end


@interface UserInfoDataManger : NSObject

@end
