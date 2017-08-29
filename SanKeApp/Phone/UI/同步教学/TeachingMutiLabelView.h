//
//  TeachingMutiLabelView.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBookInfoRequest.h"

typedef void(^ClickTabButtonBlock)(void);

@interface TeachingMutiLabelView : UIView
@property (nonatomic, strong) UIButton *expandBtn;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Label *> *tabArray;
@property (nonatomic, assign) NSInteger currentTabIndex;
- (void)expandBtnAction;
- (void)setClickTabButtonBlock:(ClickTabButtonBlock)block;
@end
