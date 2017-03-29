//
//  QAQuestionListRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol QAQuestionListRequestItem_Attachment <NSObject>
@end
@interface QAQuestionListRequestItem_Attachment : JSONModel
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *resType;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *fileType;
@property (nonatomic, strong) NSString<Optional> *resSize;
@property (nonatomic, strong) NSString<Optional> *thumbnail;
@property (nonatomic, strong) NSString<Optional> *downloadUrl;
@property (nonatomic, strong) NSString<Optional> *previewUrl;
@end

@protocol QAQuestionListRequestItem_Element <NSObject>
@end
@interface QAQuestionListRequestItem_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementID;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *answerNum;
@property (nonatomic, strong) NSString<Optional> *viewNum;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *updateTime;
@property (nonatomic, strong) NSString<Optional> *showUserName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSArray<QAQuestionListRequestItem_Attachment,Optional> *attachmentList;
@end

@interface QAQuestionListRequestItem_AskPage : JSONModel
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *pageNum;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSArray<QAQuestionListRequestItem_Element,Optional> *elements;
@end

@interface QAQuestionListRequestItem_Data : JSONModel
@property (nonatomic, strong) QAQuestionListRequestItem_AskPage<Optional> *askPage;
@end

@interface QAQuestionListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) QAQuestionListRequestItem_Data<Optional> *data;
@end

@interface QAQuestionListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *biz_id;
@property (nonatomic, strong) NSString<Optional> *from;
@property (nonatomic, strong) NSString<Optional> *m;
@property (nonatomic, strong) NSString<Optional> *sort_field;
@property (nonatomic, strong) NSString<Optional> *order;
@end
