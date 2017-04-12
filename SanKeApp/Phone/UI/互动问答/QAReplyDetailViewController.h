//
//  QAReplyDetailViewController.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "QAReplyListRequest.h"
#import "QAQuestionDetailRequest.h"

@interface QAReplyDetailViewController : BaseViewController
@property (nonatomic, strong) QAReplyListRequestItem_Element *item;
@property (nonatomic, strong) QAQuestionDetailRequestItem_Ask *questionItem;
@end
