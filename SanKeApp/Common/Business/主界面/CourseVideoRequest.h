//
//  CourseVideoRequest.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol CourseVideoRequestItem_Data_Elements
@end
@interface CourseVideoRequestItem_Data_Elements : JSONModel
@property (nonatomic ,copy) NSString<Optional> *resourceId;
@property (nonatomic ,copy) NSString<Optional> *title;
@property (nonatomic ,copy) NSString<Optional> *author;
@property (nonatomic ,copy) NSString<Optional> *videos;
@property (nonatomic ,copy) NSString<Optional> *videosMp4;
@property (nonatomic ,copy) NSString<Optional> *watchRecord;
@property (nonatomic ,copy) NSString<Optional> *totalTime;
@property (nonatomic ,copy) NSString<Optional> *catid;
@property (nonatomic ,copy) NSString<Optional> *thumb;
@property (nonatomic ,copy) NSString<Optional> *summary;
@property (nonatomic ,copy) NSString<Optional> *itemID;
@end
@interface CourseVideoRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<CourseVideoRequestItem_Data_Elements, Optional> *items;
@property (nonatomic, copy) NSString<Optional> *moreData;
@end
@interface CourseVideoRequestItem : HttpBaseRequestItem
@property (nonatomic ,strong) CourseVideoRequestItem_Data<Optional> *data;
@end
@interface CourseVideoRequest : YXGetRequest
@property (nonatomic, copy) NSString *filterID;
@property (nonatomic, copy) NSString *catID;
@property (nonatomic, assign) NSInteger fromType;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger lastID;
@end
