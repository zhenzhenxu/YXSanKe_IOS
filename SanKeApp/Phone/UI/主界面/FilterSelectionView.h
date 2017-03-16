//
//  FilterSelectionView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelTabFilterRequest.h"

@interface FilterSelectionView : UIView
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, strong) ChannelTabFilterRequestItem_data *data;
@property (nonatomic, copy) void(^completeBlock)(YXProblemItem *recordItem);
- (void)cancelReset;
@end
