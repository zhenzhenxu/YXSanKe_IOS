//
//  QAReplyFavorRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface QAReplyFavorRequestItem_Data : JSONModel
@property (nonatomic, strong) NSString<Optional> *likeNum;
@property (nonatomic, strong) NSString<Optional> *isLike;
@end

@interface QAReplyFavorRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) QAReplyFavorRequestItem_Data<Optional> *data;
@end

@interface QAReplyFavorRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *biz_id;
@property (nonatomic, strong) NSString<Optional> *answer_id;
@end
