//
//  YXEmptyView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXEmptyView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *imageName;
//活动视频界面专用
@property (nonatomic, assign) BOOL isActivityVideo;
@end
