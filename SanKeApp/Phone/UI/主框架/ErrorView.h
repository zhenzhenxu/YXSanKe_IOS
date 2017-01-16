//
//  ErrorView.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RetryBlock)(void);

@interface ErrorView : UIView

- (void)setRetryBlock:(RetryBlock)block;
@end
