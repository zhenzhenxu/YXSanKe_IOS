//
//  MineUserModel.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineUserModel : NSObject
@property (nonatomic, strong) NSString *backgroundImageUrl;
@property (nonatomic, strong) NSString *portraitUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FetchStageSubjectRequestItem_stage *stage;
@property (nonatomic, strong) FetchStageSubjectRequestItem_subject *subject;
@property (nonatomic, strong) Area *province;
@property (nonatomic, strong) Area *city;
@property (nonatomic, strong) Area *district;

+ (MineUserModel *)mineUserModelFromRawModel:(UserModel *)model;
@end
