//
//  QAQuestionDetailView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAQuestionDetailRequest.h"

@interface QAQuestionDetailView : UIView
@property (nonatomic, strong) QAQuestionDetailRequestItem_Ask *item;
@property (nonatomic, copy) void(^AttachmentClickAction) ();

- (void)updateWithReplyCount:(NSString *)replyCount browseCount:(NSString *)browseCount;
+ (CGFloat)heightForWidth:(CGFloat)width item:(QAQuestionDetailRequestItem_Ask *)item;
@end
