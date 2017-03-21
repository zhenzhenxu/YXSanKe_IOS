//
//  QAReplyDetailMenuItemView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAReplyDetailMenuItemView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void(^ActionBlock) ();
- (void)updateWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title;
@end
