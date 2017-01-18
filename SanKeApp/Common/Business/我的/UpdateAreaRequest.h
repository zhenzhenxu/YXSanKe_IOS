//
//  UpdateAreaRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UpdateAreaRequest : YXGetRequest
@property (nonatomic, strong) NSString *area; // 省市区的id，用“,”分割
@end
