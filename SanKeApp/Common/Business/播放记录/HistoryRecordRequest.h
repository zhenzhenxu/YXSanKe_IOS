//
//  HistoryRecordRequest.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface HistoryRecordRequestItem_Data : JSONModel
@end
@interface HistoryRecordRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) HistoryRecordRequestItem_Data<Optional> *data;
@end
@interface HistoryRecordRequest : YXGetRequest
@property (nonatomic, copy) NSString *resourceID;
@property (nonatomic, copy) NSString *watchRecord;
@property (nonatomic, copy) NSString *totalTime;
@end
