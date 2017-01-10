//
//  AreaDataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Area
@end
@interface Area:JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *number;
@property (nonatomic ,strong) NSArray<Area,Optional> *subAreas;
@end

@interface AreaModel:JSONModel
@property (nonatomic ,strong)NSArray<Area,Optional> *areas;
@property (nonatomic, copy) NSString<Optional> *version;
@end

@interface AreaDataManager : NSObject
+ (AreaModel *)areaModel;
@end
