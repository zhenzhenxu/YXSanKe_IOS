//
//  QAQuestionDetailView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAQuestionListRequest.h"

@interface QAQuestionDetailView : UIView
@property (nonatomic, strong) QAQuestionListRequestItem_Element *item;
@property (nonatomic, copy) void(^AttachmentClickAction) ();

- (void)updateWithReplyCount:(NSString *)replyCount browseCount:(NSString *)browseCount;
+ (CGFloat)heightForWidth:(CGFloat)width item:(QAQuestionListRequestItem_Element *)item;
@end
