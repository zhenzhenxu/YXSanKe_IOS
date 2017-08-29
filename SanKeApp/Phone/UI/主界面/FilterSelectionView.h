//
//  FilterSelectionView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelTabFilterRequest.h"

@interface FilterSelectedItem : NSObject
@property (nonatomic, strong) ChannelTabFilterRequestItem_filter *volume;
@property (nonatomic, strong) ChannelTabFilterRequestItem_filter *unit;
@property (nonatomic, strong) ChannelTabFilterRequestItem_filter *course;
@end

@interface FilterSelectionView : UIView
@property (nonatomic, assign) BOOL hasCourseFilter;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, strong) ChannelTabFilterRequestItem_data *data;
@property (nonatomic, copy) void(^completeBlock)(FilterSelectedItem *selectedItem);
- (void)cancelReset;
@end
