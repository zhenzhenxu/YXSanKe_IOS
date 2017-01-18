//
//  ChannelIndexFetch.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "CourseVideoRequest.h"
@interface CourseVideoFetch : PagedListFetcherBase
@property (nonatomic, copy) NSString *filterID;
@property (nonatomic, copy) NSString *catID;
@property (nonatomic, assign) NSInteger fromType;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger lastID;
@end
