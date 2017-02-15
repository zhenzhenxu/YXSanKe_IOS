//
//  FetchStageSubjectRequest.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol FetchStageSubjectRequestItem_subject <NSObject>
@end
@interface FetchStageSubjectRequestItem_subject : JSONModel
@property (nonatomic, strong) NSString *subjectID;
@property (nonatomic, strong) NSString *name;
@end

@protocol FetchStageSubjectRequestItem_stage <NSObject>
@end
@interface FetchStageSubjectRequestItem_stage : JSONModel
@property (nonatomic, strong) NSString *stageID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<FetchStageSubjectRequestItem_subject,Optional> *subjects;
@end

@interface FetchStageSubjectRequestItem_category : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FetchStageSubjectRequestItem_category<Optional> *subCategory;
@end

@interface FetchStageSubjectRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<FetchStageSubjectRequestItem_stage,Optional> *stages;
@end

@interface FetchStageSubjectRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) FetchStageSubjectRequestItem_data<Optional> *data;
@property (nonatomic, strong) FetchStageSubjectRequestItem_category<Optional> *category;
@end

@interface FetchStageSubjectRequest : YXGetRequest

@end
