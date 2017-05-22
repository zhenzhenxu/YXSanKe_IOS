//
//  LabelListViewController.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
@class GetBookInfoRequestItem_Label;

@interface LabelListViewController : BaseViewController
@property (nonatomic, strong)  NSArray <GetBookInfoRequestItem_Label *> *tabArray;
@property (nonatomic, assign)  NSInteger currentTabIndex;
@end
