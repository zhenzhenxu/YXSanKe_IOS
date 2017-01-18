//
//  SaveRecordRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface SaveRecordRequest : YXGetRequest
@property (nonatomic, strong) NSString *resource_id;
@property (nonatomic, strong) NSString *watch_record; //观看时长
@property (nonatomic, strong) NSString *total_time; // 总时长
@end
