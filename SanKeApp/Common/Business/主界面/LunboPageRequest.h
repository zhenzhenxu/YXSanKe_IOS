//
//  LunboPageRequest.h
//  SanKeApp
//
//  Created by 郑小龙 on 2018/1/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol LunboPageItem_Data_Item @end

@interface LunboPageItem_Data_Item : JSONModel
@property (nonatomic, strong) NSString<Optional> *itemId;
@property (nonatomic, strong) NSString<Optional> *image;
@property (nonatomic, strong) NSString<Optional> *detail;
@end

@interface LunboPageItem_Data : JSONModel
@property (nonatomic, strong) NSArray<LunboPageItem_Data_Item, Optional> *items;

@end

@interface LunboPageItem : HttpBaseRequestItem
@property (nonatomic, strong) LunboPageItem_Data <Optional> *data;
@end
@interface LunboPageRequest : YXGetRequest

@end
