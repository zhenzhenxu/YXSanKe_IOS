//
//  TabContainerView.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabViewController;
@class GetBookInfoRequestItem_Label;

@interface TabContainerView : UIView
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Label *> *tabArray;
@property(nonatomic,strong) NSArray<__kindof TabViewController *> *childViewControllers;
@property(nonatomic,strong) TabViewController *chooseViewController;
@property(nonatomic,assign) NSInteger chooseIndex;
@property (nonatomic, copy) void(^ClickTabButtonBlock)();
@end
