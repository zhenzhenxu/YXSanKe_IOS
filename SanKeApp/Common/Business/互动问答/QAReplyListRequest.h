//
//  QAReplyListRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface QAReplyListRequestItem_LikeInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *likeNum;
@property (nonatomic, strong) NSString<Optional> *isLike;
@end

@protocol QAReplyListRequestItem_Element <NSObject>
@end
@interface QAReplyListRequestItem_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementID;
@property (nonatomic, strong) NSString<Optional> *answer;
@property (nonatomic, strong) NSString<Optional> *askId;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *updateTime;
@property (nonatomic, strong) NSString<Optional> *showUserName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) QAReplyListRequestItem_LikeInfo<Optional> *likeInfo;
@end

@interface QAReplyListRequestItem_AnswerPage : JSONModel
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *pageNum;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSArray<QAReplyListRequestItem_Element,Optional> *elements;
@end

@interface QAReplyListRequestItem_Data : JSONModel
@property (nonatomic, strong) QAReplyListRequestItem_AnswerPage<Optional> *answerPage;
@end

@interface QAReplyListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) QAReplyListRequestItem_Data<Optional> *data;
@end

@interface QAReplyListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *biz_id;
@property (nonatomic, strong) NSString<Optional> *from;
@property (nonatomic, strong) NSString<Optional> *m;
@property (nonatomic, strong) NSString<Optional> *ask_id;
@end
