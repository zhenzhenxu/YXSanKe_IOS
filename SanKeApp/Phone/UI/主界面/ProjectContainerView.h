//
//  ProjectContainerView.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseViewController;
@interface ProjectContainerView : UIView
@property(nonatomic,strong) NSArray<__kindof CourseViewController *> *childViewControllers;
@property(nonatomic,strong) CourseViewController *chooseViewController;
@property (nonatomic, copy) void(^ClickTabButtonBlock)();
@end
