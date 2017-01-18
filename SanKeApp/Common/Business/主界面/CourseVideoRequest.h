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
@property (nonatomic ,copy) NSString<Optional> *videoID;
@property (nonatomic ,copy) NSString<Optional> *title;
@property (nonatomic ,copy) NSString<Optional> *desc;
@property (nonatomic ,copy) NSString<Optional> *author;
@property (nonatomic ,copy) NSString<Optional> *thanks;
@property (nonatomic ,copy) NSString<Optional> *icon;
@property (nonatomic ,copy) NSString<Optional> *videos;
@property (nonatomic ,copy) NSString<Optional> *wealth;

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
