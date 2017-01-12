//
//  LoginActionView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginActionView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void(^actionBlock) (void);
@end
