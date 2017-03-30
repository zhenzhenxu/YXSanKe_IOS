//
//  QAReplyCell.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianCornerBaseCell.h"
#import "QAReplyListRequest.h"

@interface QAReplyCell : RadianCornerBaseCell
@property (nonatomic, strong) QAReplyListRequestItem_Element *item;
@end
