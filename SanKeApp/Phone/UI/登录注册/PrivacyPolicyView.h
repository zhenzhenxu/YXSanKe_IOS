//
//  PrivacyPolicyView.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseBlock)(void);
typedef void(^MarkBlock)(void);
@interface PrivacyPolicyView : UIView

@property (nonatomic, assign) BOOL isMark;
- (void)setChooseBlock:(ChooseBlock)block;
- (void)setMarkBlock:(MarkBlock)block;
@end
