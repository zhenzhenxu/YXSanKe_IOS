//
//  YXProblemItem.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRecordBase.h"

@interface YXProblemItem : YXRecordBase

@property (nonatomic, copy) NSString *objType;
@property (nonatomic, copy) NSString *objId;
@property (nonatomic, copy) NSString *objName;

@property (nonatomic, copy) NSString *subject;

@end
