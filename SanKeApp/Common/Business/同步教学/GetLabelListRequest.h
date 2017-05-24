//
//  GetLabelListRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
#import "TreeNodeProtocol.h"

@protocol GetLabelListRequestItem_Element <NSObject>
@end
@interface GetLabelListRequestItem_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *ebookId;
@property (nonatomic, strong) NSString<Optional> *elementID;
@property (nonatomic, strong) NSString<Optional> *labelType;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSArray<GetLabelListRequestItem_Element,Optional> *items;
@end

@interface GetLabelListRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<GetLabelListRequestItem_Element,Optional> *elements;
@end

@interface GetLabelListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetLabelListRequestItem_Data<Optional> *data;
@end

@interface GetLabelListRequest : YXPostRequest
@property (nonatomic, strong) NSString<Optional> *labelID;
@end
