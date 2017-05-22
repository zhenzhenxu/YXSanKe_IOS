//
//  LabelHeaderView.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetLabelListRequestItem_Element;

@interface LabelHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) GetLabelListRequestItem_Element *element;
@property (nonatomic, strong) void(^actionBlock)();

@property (nonatomic, assign) BOOL isFold;
@property (nonatomic, assign) BOOL isFinished;
@end
