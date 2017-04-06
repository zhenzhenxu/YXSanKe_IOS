//
//  QACreateAskRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/4/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@interface QACreateAskRequest : YXPostRequest

@property (nonatomic, strong) NSString *biz_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *attachment;
@end
