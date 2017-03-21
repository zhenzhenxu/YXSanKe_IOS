//
//  QAQuestionDetailView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAQuestionDetailView : UIView
@property (nonatomic, copy) void(^AttachmentClickAction) ();
@property (nonatomic, assign) NSInteger type; // for test, 0 for no attach, 1 for pic, 2 for others
+ (CGFloat)heightForWidth:(CGFloat)width;
@end
