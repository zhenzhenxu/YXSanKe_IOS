//
//  UpdateUserNameRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UpdateUserNameRequest : YXGetRequest
@property (nonatomic, strong) NSString *username;
@end
