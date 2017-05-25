//
//  ResourceDetailHeaderView.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResourceDetailRequestItem_Data;

@interface ResourceDetailHeaderView : UIView

@property (nonatomic, strong) ResourceDetailRequestItem_Data *item;
@property (nonatomic, copy) void(^resourceButtonBlock)();

@end
