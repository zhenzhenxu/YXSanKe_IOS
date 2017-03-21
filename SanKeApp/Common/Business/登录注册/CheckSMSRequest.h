//
//  CheckSMSRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface CheckSMSRequest : YXGetRequest
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *from;
@end
