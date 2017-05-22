//
//  LabelListContainerView.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LabelViewController;
@class GetBookInfoRequestItem_Label;

@interface LabelListContainerView : UIView
@property(nonatomic,strong) NSArray<__kindof LabelViewController *> *childViewControllers;
@property(nonatomic,assign) NSInteger chooseIndex;
@property(nonatomic,strong) LabelViewController *chooseViewController;
@property (nonatomic, copy) void(^ClickTabButtonBlock)();
@end
