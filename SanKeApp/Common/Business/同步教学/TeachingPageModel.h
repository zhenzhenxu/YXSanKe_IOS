//
//  TeachingPageModel.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetBookInfoRequest.h"

@interface TeachingPage : JSONModel

@end
@interface TeachingPageModel : JSONModel
@property (nonatomic, copy) NSString *pageIndex;
@property (nonatomic, copy) NSString *pageUrl;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Label *> *pageLabel;
@property (nonatomic, copy) NSString *pageTarget;//volum,unit,course
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) BOOL isEnd;

+ (NSArray *)TeachingPageModelsFromRawData:(GetBookInfoRequestItem *)item;
@end
