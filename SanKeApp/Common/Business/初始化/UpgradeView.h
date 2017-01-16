//
//  UpgradeView.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpgradeButtonActionBlock)(void);

@interface UpgradeView : UIView
@property (nonatomic, assign) BOOL isForce;

- (void)setUpgradeButtonActionBlock:(UpgradeButtonActionBlock)block;
@end
