//
//  UnhandledRequestData.h
//  TrainApp
//
//  Created by ZLL on 2016/12/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnhandledRequestData : NSObject

@property (nonatomic, assign)BOOL requestDataExist;
@property (nonatomic, assign)BOOL localDataExist;
@property (nonatomic, strong)NSError *error;

@end
