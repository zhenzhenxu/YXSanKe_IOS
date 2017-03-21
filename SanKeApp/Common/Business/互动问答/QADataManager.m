//
//  QADataManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QADataManager.h"

@interface QADataManager()

@end

@implementation QADataManager
+ (QADataManager *)sharedInstance {
    static dispatch_once_t once;
    static QADataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[QADataManager alloc] init];
    });
    
    return sharedInstance;
}
@end
