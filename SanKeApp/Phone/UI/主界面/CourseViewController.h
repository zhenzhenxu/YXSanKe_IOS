//
//  CourseViewController.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
@interface CourseTabItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tabId;
@end

@interface CourseViewController : PagedListViewControllerBase
@property (nonatomic, strong) CourseTabItem *tabItem;
@end
