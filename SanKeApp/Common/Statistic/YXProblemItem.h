//
//  YXProblemItem.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRecordBase.h"

@interface YXProblemItem : YXRecordBase

@property (nonatomic, copy) NSString<Optional> *objType;
@property (nonatomic, copy) NSString<Optional> *objId;
@property (nonatomic, copy) NSString<Optional> *objName;

@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, copy) NSString<Optional> *grade;

@end
