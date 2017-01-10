//
//  SKAlertButton.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SKAlertButtonStyle) {
    SKAlertButtonStyle_Alone = 0,
    SKAlertButtonStyle_Default = 1,
    SKAlertButtonStyle_Cancel = 2,
};

@interface SKAlertButton : UIButton
@property (nonatomic, assign) SKAlertButtonStyle style;
@end
