//
//  ProjectNavRightView.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectNavRightView : UIView
@property (nonatomic, copy) void(^ProjectNavButtonLeftBlock)();
@property (nonatomic, copy) void(^ProjectNavButtonRightBlock)();
@end
