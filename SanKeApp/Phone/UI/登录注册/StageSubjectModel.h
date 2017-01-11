//
//  StageSubjectModel.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol StageSubjectItem <NSObject>

@end

@interface StageSubjectItem : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<StageSubjectItem,Optional> *items;
@end

@interface StageSubjectModel : JSONModel
@property (nonatomic, strong) NSArray<StageSubjectItem,Optional> *items;
@end
