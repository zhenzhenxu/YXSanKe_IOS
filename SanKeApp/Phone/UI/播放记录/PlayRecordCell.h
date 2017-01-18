//
//  PlayRecordCell.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianBaseCell.h"
#import "PlayHistoryRequest.h"
@interface PlayRecordCell : RadianBaseCell
@property (nonatomic, strong) PlayHistoryRequestItem_Data_History *history;
@end
