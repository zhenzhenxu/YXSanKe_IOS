//
//  LabelViewController.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "GetBookInfoRequest.h"

@interface LabelViewController : BaseViewController
@property (nonatomic, strong) GetBookInfoRequestItem_Label *label;
@property (nonatomic, strong) GetBookInfoRequestItem_Volum *volum;
@property (nonatomic, strong) GetBookInfoRequestItem_Unit *unit;
@property (nonatomic, strong) GetBookInfoRequestItem_Course *course;
@end
