//
//  ResourceAskListRequest.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol ResourceAskListItem_Element <NSObject>
@end
@interface ResourceAskListItem_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *userIcon;
@property (nonatomic, strong) NSString<Optional> *userTrueName;
@property (nonatomic, strong) NSString<Optional> *BuildDate;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSNumber<Ignore> *cellHeight;
@end

@interface ResourceAskListItem_Data : JSONModel
@property (nonatomic, strong) NSArray<ResourceAskListItem_Element, Optional> *data;
@property (nonatomic, assign) NSInteger total;
@end

@interface ResourceAskListItem : HttpBaseRequestItem
@property (nonatomic, strong) ResourceAskListItem_Data<Optional> *data;
@end

@interface ResourceAskListRequest : YXGetRequest
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *objectid;
@property (nonatomic, strong) NSString *objecttype;
@property (nonatomic, strong) NSString *pageno;
@end
