//
//  StageSubjectDataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchStageSubjectRequest.h"

@interface StageSubjectDataManager : NSObject
+ (void)updateToLatestData;
+ (FetchStageSubjectRequestItem *)dataForStageAndSubject;
@end
