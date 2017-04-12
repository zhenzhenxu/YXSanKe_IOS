//
//  QAQuestionDetailRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol QAQuestionDetailRequestItem_Attachment <NSObject>
@end
@interface QAQuestionDetailRequestItem_Attachment : JSONModel
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *resType;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *fileType;
@property (nonatomic, strong) NSString<Optional> *resSize;
@property (nonatomic, strong) NSString<Optional> *thumbnail;
@property (nonatomic, strong) NSString<Optional> *downloadUrl;
@property (nonatomic, strong) NSString<Optional> *previewUrl;
@end

@protocol QAQuestionDetailRequestItem_Ask <NSObject>
@end
@interface QAQuestionDetailRequestItem_Ask : JSONModel
@property (nonatomic, strong) NSString<Optional> *askID;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *answerNum;
@property (nonatomic, strong) NSString<Optional> *viewNum;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *updateTime;
@property (nonatomic, strong) NSString<Optional> *showUserName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSArray<QAQuestionDetailRequestItem_Attachment,Optional> *attachmentList;
@end

@interface QAQuestionDetailRequestItem_Data : JSONModel
@property (nonatomic, strong) QAQuestionDetailRequestItem_Ask<Optional> *ask;
@end

@interface QAQuestionDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) QAQuestionDetailRequestItem_Data<Optional> *data;
@end

@interface QAQuestionDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *biz_id;
@property (nonatomic, strong) NSString<Optional> *questionID;
@end
