//
//  PlayHistoryRequest.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol PlayHistoryRequestItem_Data_History

@end
@interface PlayHistoryRequestItem_Data_History : JSONModel
@property (nonatomic, copy) NSString<Optional> *catid;
@property (nonatomic, copy) NSString<Optional> *videoID;
@property (nonatomic, copy) NSString<Optional> *thumb;
@property (nonatomic, copy) NSString<Optional> *videos;
@property (nonatomic, copy) NSString<Optional> *videosMp4;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *watchRecord;
@property (nonatomic, copy) NSString<Optional> *totalTime;
@property (nonatomic, copy) NSString<Optional> *resourceId;
@end

@interface PlayHistoryRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<PlayHistoryRequestItem_Data_History, Optional> *history;
@property (nonatomic, copy) NSString<Optional> *moreData;
@end

@interface PlayHistoryRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) PlayHistoryRequestItem_Data<Optional> *data;
@end
@interface PlayHistoryRequest : YXGetRequest
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger lastID;
@end
