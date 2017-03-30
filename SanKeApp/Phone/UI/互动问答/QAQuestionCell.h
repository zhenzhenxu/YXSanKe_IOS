//
//  QAQuestionCell.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianCornerBaseCell.h"
#import "QAQuestionListRequest.h"

@interface QAQuestionCell : RadianCornerBaseCell
@property (nonatomic, strong) QAQuestionListRequestItem_Element *item;
@end
