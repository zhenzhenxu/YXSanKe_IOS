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
@end
