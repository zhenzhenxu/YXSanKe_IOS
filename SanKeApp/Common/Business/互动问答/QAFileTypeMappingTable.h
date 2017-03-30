//
//  QAFileTypeMappingTable.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAFileTypeMappingTable : NSObject
+ (YXFileType)fileTypeWithString:(NSString *)typeString;
@end
