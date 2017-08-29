//
//  GetResListRequest.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/22.
//  strongright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@protocol GetResListRequestItem_Data_Element_Res <NSObject>
@end
@interface GetResListRequestItem_Data_Element_Res : JSONModel
@property (nonatomic, strong) NSString<Optional> *resoucrId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *videos;
@property (nonatomic, strong) NSString<Optional> *videosMp4;
@property (nonatomic, strong) NSString<Optional> *watchRecord;
@property (nonatomic, strong) NSString<Optional> *totalTime;
@end

@protocol GetResListRequestItem_Data_Element <NSObject>
@end
@interface GetResListRequestItem_Data_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *author;
@property (nonatomic, strong) NSString<Optional> *thumb;
@property (nonatomic, strong) NSString<Optional> *summary;
@property (nonatomic, strong) NSString<Optional> *elementID;
@property (nonatomic, strong) NSString<Optional> *recordType;
@property (nonatomic, strong) NSArray<GetResListRequestItem_Data_Element_Res, Optional> *resourceList;
@end

@interface GetResListRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<GetResListRequestItem_Data_Element, Optional> *items;
@property (nonatomic, strong) NSString<Optional> *moreData;
@end

@interface GetResListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetResListRequestItem_Data<Optional> *data;
@end

@interface GetResListRequest : YXPostRequest
@property (nonatomic, strong) NSString *moduleId;
@property (nonatomic, strong) NSString *page_size;
@property (nonatomic, strong) NSString *tab_type;
@property (nonatomic, strong) NSString *last_id;
@end
