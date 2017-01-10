//
//  UIView+YXAddtion.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YXAddtion)
/**
 *	@brief	横向等间隙布局
 *
 *	@param 	views 	布局view
 */
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;

/**
 *	@brief	竖向等间距布局
 *
 *	@param 	views 	所需布局view
 */
- (void) distributeSpacingVerticallyWith:(NSArray*)views;

@end
