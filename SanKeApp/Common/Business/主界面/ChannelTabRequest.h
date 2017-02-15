//
//  ChannelTabRequest.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ChannelTabRequestItem_Data_Category
@end
@interface ChannelTabRequestItem_Data_Category : JSONModel
@property (nonatomic, strong) NSString *cateName;
@property (nonatomic, strong) NSString *catId;
@end

@interface ChannelTabRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<ChannelTabRequestItem_Data_Category, Optional> *category;
@end

@interface ChannelTabRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ChannelTabRequestItem_Data<Optional> *data;
@end
@interface ChannelTabRequest : YXGetRequest

@end
