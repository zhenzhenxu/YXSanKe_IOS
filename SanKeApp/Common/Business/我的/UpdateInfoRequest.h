//
//  UpdateInfoRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UpdateInfoRequest : YXGetRequest

@property (nonatomic, strong) NSString *stage;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *experience;

@end
