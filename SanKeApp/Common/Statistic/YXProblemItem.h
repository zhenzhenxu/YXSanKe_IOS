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
@property (nonatomic, copy) NSString<Optional> *grade;//学段
@property (nonatomic, copy) NSString<Optional> *subject;//学科
@property (nonatomic, copy) NSString<Optional> *section_id;//板块id
@property (nonatomic, copy) NSString<Optional> *edition_id;//版本
@property (nonatomic, copy) NSString<Optional> *volume_id;//年级&册
@property (nonatomic, copy) NSString<Optional> *unit_id;//单元
@property (nonatomic, copy) NSString<Optional> *course_id;//课
@property (nonatomic, copy) NSString<Optional> *object_id;
@property (nonatomic, copy) NSString<Optional> *object_name;
@property (nonatomic, copy) NSString<Optional> *tag_id;//标签id
@end
