//
//  UserInfoModel.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic, strong) NSString *infoName;
@property (nonatomic, strong) NSString *infoId;

//+ (UserInfoModel *)modelFromRoalData:(YXDatumSearchRequestItem_data *)data;
@end
