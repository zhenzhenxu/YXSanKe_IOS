//
//  TabListViewController.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
@class GetBookInfoRequestItem_Label;

@interface TabListViewController : BaseViewController
@property (nonatomic, strong)  NSArray <GetBookInfoRequestItem_Label *> *tabArray;
@property (nonatomic, assign)  NSInteger currentTabIndex;
@end
