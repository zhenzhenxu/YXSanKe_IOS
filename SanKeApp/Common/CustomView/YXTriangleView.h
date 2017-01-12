//
//  YXTriangleView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXTriangleDirection) {
    YXTriangleDirection_Top,
    YXTriangleDirection_Bottom,
    YXTriangleDirection_Left,
    YXTriangleDirection_Right
};

@interface YXTriangleView : UIView
@property (nonatomic, assign) YXTriangleDirection direction; // default is YXTriangleDirection_Top
@end
