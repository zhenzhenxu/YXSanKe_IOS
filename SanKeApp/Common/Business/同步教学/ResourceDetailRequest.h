//
//  ResourceDetailRequest.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@interface ResourceDetailRequestItem_Data : JSONModel
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *resType;
@property (nonatomic, strong) NSString<Optional> *resPreviewUrl;
@property (nonatomic, strong) NSString<Optional> *resThumb;
@property (nonatomic, strong) NSString<Optional> *resDownloadUrl;
@property (nonatomic, strong) NSString<Optional> *readNum;
@property (nonatomic, assign) NSInteger createTime;
@end

@interface ResourceDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ResourceDetailRequestItem_Data<Optional> *data;
@end

@interface ResourceDetailRequest : YXPostRequest
@property (nonatomic, strong) NSString *resourceID;
@end
