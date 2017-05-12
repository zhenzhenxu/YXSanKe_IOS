//
//  TeachingMutiTabView.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBookInfoRequest.h"

typedef void(^ClickTabButtonBlock)(GetBookInfoRequestItem_Label *label);

@interface TeachingMutiTabView : UIScrollView
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Label *> *tabArray;
@property (nonatomic, strong) GetBookInfoRequestItem_Label *currentTab;

- (void)setClickTabButtonBlock:(ClickTabButtonBlock)block;
@end
