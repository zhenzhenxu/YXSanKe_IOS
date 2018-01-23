//
//  FocusRotationView.h
//  SanKeApp
//
//  Created by 郑小龙 on 2018/1/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusRotationView : UIView
@property (nonatomic, strong) NSArray *itemViewArray;
@property (nonatomic, assign) CGFloat widthFloat;
@property (nonatomic, copy) void(^focusRotationClickBlock)(NSInteger integer);
@end
