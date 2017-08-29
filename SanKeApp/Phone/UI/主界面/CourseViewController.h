//
//  CourseViewController.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"

@interface CourseVideoItem : NSObject
@property (nonatomic, copy) NSString *moduleId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *catID;
@property (nonatomic, copy) NSString *filterID;
@property (nonatomic, assign) NSInteger fromType;
@property (nonatomic, strong) NSString *code;
@end

@interface CourseViewController : PagedListViewControllerBase
@property (nonatomic, strong) CourseVideoItem *videoItem;
@property (nonatomic, strong) YXProblemItem *recordItem;
@end
