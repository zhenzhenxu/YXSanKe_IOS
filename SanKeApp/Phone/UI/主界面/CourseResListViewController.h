//
//  CourseResListViewController.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface CourseResListViewController : BaseViewController

@property (nonatomic, strong) NSString *catID;
@property (nonatomic, strong) NSArray *resListArray;
@property (nonatomic, strong) YXProblemItem *recordItem;

@end
