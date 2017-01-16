//
//  StageAndSubjectRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

// 学科，如数学
@interface StageAndSubjectItem_Stage_Subject : JSONModel

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *name;

@end

// 学段，如小学
@protocol StageAndSubjectItem_Stage_Subject
@end
@interface StageAndSubjectItem_Stage : JSONModel

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<StageAndSubjectItem_Stage_Subject, Optional> *subjects;

@end

@protocol StageAndSubjectItem_Stage
@end
@interface StageAndSubjectItem : HttpBaseRequestItem

@property (nonatomic, strong) NSArray<StageAndSubjectItem_Stage, Optional> *stages;
@property (nonatomic, copy) NSString *version;

@end


@interface StageAndSubjectRequest : YXGetRequest

@end
