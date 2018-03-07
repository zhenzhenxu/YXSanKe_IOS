//
//  GetBookInfoRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@protocol GetBookInfoRequestItem_Marker_Item <NSObject>
@end
@interface GetBookInfoRequestItem_Marker_Item : JSONModel
@property (nonatomic, strong) NSString<Optional> *itemID;
@property (nonatomic, strong) NSString<Optional> *x0;
@property (nonatomic, strong) NSString<Optional> *y0;
@property (nonatomic, strong) NSString<Optional> *x1;
@property (nonatomic, strong) NSString<Optional> *y1;
@property (nonatomic, strong) NSString<Optional> *ox;
@property (nonatomic, strong) NSString<Optional> *oy;
@property (nonatomic, strong) NSString<Optional> *textInfo;
@property (nonatomic, strong) NSString<Optional> *style;
@property (nonatomic, strong) NSString<Optional> *state;


@end

@protocol GetBookInfoRequestItem_Marker <NSObject>
@end
@interface GetBookInfoRequestItem_Marker : JSONModel
@property (nonatomic, strong) NSString<Optional> *markerID;
@property (nonatomic, strong) NSString<Optional> *lineAbove;
@property (nonatomic, strong) NSString<Optional> *lineBelow;
@property (nonatomic, strong) NSString<Optional> *iconWidth;
@property (nonatomic, strong) NSString<Optional> *iconHeight;
@property (nonatomic, strong) NSString<Optional> *markIcon;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Marker_Item, Optional> *lines;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Marker_Item, Optional> *icons;
@end

@protocol GetBookInfoRequestItem_Mark <NSObject>
@end
@interface GetBookInfoRequestItem_Mark : JSONModel
@property (nonatomic, strong) NSString<Optional> *picWidth;
@property (nonatomic, strong) NSString<Optional> *picHeight;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Marker, Optional> *marker;
@end

@protocol GetBookInfoRequestItem_Page <NSObject>
@end
@interface GetBookInfoRequestItem_Page: JSONModel
@property (nonatomic, strong) NSString<Optional> *pageIndex;
@property (nonatomic, strong) NSString<Optional> *pageUrl;
@property (nonatomic, strong) GetBookInfoRequestItem_Mark<Optional> *mark;
//target
@property (nonatomic, strong) NSString<Optional> *pageVolum;
@property (nonatomic, strong) NSString<Optional> *pageUnit;
@property (nonatomic, strong) NSString<Optional> *pageCourse;
@property (nonatomic, strong) NSString<Optional> *isStart;
@property (nonatomic, strong) NSString<Optional> *isEnd;
@end

@protocol GetBookInfoRequestItem_Label <NSObject>
@end
@interface GetBookInfoRequestItem_Label: JSONModel
@property (nonatomic, strong) NSString<Optional> *labelID;
@property (nonatomic, strong) NSString<Optional> *name;
@end


@protocol GetBookInfoRequestItem_Course<NSObject>
@end
@interface GetBookInfoRequestItem_Course : JSONModel
@property (nonatomic, strong) NSString<Optional> *courseID;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *idx;
@property (nonatomic, strong) NSString<Optional> *pages;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Page,Optional> *url;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Label,Optional> *label;
@end

@protocol GetBookInfoRequestItem_Unit <NSObject>
@end
@interface GetBookInfoRequestItem_Unit : JSONModel
@property (nonatomic, strong) NSString<Optional> *unitID;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *idx;
@property (nonatomic, strong) NSString<Optional> *pages;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Page,Optional> *url;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Label,Optional> *label;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Course,Optional> *courses;
@end

@protocol GetBookInfoRequestItem_Volum <NSObject>
@end
@interface GetBookInfoRequestItem_Volum : JSONModel
@property (nonatomic, strong) NSString<Optional> *volumID;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *idx;
@property (nonatomic, strong) NSString<Optional> *pages;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Unit,Optional> *units;
@end

@interface GetBookInfoRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Volum,Optional> *volums;
@end

@interface GetBookInfoRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetBookInfoRequestItem_Data<Optional> *data;
//+ (GetBookInfoRequestItem *)mockGetBookInfoRequestItem;
@end


@interface GetBookInfoRequest : YXPostRequest
@property (nonatomic, strong) NSString<Optional> *biz_id;// 业务id
@end
