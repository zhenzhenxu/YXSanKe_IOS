//
//  SKAlertButton.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SKAlertButton.h"

@implementation SKAlertButton

- (void)setStyle:(SKAlertButtonStyle)style {
    _style = style;
    if (style == SKAlertButtonStyle_Cancel) {
        [self setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"a9acae"]] forState:UIControlStateHighlighted];
        self.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    else if (style == SKAlertButtonStyle_Default){
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"003686"]] forState:UIControlStateHighlighted];
        self.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }else if(style == SKAlertButtonStyle_Alone){
        [self setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"003686"]] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
}

@end
