//
//  QAReplyDetailCell.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianCornerBaseCell.h"
#import "QAReplyListRequest.h"

@interface QAReplyDetailCell : RadianCornerBaseCell
@property (nonatomic, strong) QAReplyListRequestItem_Element *item;
@end
