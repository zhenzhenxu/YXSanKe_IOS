//
//  ChangeAvatarView.h
//  SanKeApp
//
//  Created by ZLL on 2017/2/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChangeAvatarBlock)(NSInteger idx);

@interface ChangeAvatarView : UIView
- (void)setChangeAvatarBlock:(ChangeAvatarBlock)block;
@end
