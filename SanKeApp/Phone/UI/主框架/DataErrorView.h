//
//  DataErrorView.h
//  TrainApp
//
//  Created by ZLL on 2016/11/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataErrorView : UIView
@property (nonatomic, copy) void(^refreshBlock)();

//活动视频界面专用
@property (nonatomic, assign) BOOL isActivityVideo;
@end
