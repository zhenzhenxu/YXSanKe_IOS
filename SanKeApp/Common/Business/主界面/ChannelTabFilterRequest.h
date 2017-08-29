//
//  ChannelTabFilterRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol ChannelTabFilterRequestItem_filter <NSObject>
@end
@interface ChannelTabFilterRequestItem_filter : JSONModel
@property (nonatomic, strong) NSString<Optional> *filterID;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSArray<ChannelTabFilterRequestItem_filter,Optional> *subFilters;
@end

@interface ChannelTabFilterRequestItem_category : JSONModel
//@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) ChannelTabFilterRequestItem_category<Optional> *subCategory;
@end

@interface ChannelTabFilterRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<ChannelTabFilterRequestItem_filter,Optional> *filters;
@property (nonatomic, strong) ChannelTabFilterRequestItem_category<Optional> *category;
@end

@interface ChannelTabFilterRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ChannelTabFilterRequestItem_data<Optional> *data;
@end

@interface ChannelTabFilterRequest : YXGetRequest
@property (nonatomic, strong) NSString *catid;
@property (nonatomic, strong) NSString *code;
@end
