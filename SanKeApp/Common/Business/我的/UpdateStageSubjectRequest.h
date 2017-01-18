//
//  UpdateStageSubjectRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UpdateStageSubjectRequest : YXGetRequest
@property (nonatomic, strong) NSString *stage;
@property (nonatomic, strong) NSString *subject;
@end
