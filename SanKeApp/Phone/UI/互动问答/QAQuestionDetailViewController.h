//
//  QAQuestionDetailViewController.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "QAQuestionListRequest.h"

@interface QAQuestionDetailViewController : PagedListViewControllerBase
@property (nonatomic, strong) QAQuestionListRequestItem_Element *item;
@end
