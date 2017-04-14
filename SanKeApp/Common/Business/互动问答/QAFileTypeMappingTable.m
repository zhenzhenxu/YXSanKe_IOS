//
//  QAFileTypeMappingTable.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAFileTypeMappingTable.h"

@implementation QAFileTypeMappingTable
+ (YXFileType)fileTypeWithString:(NSString *)typeString{//4.14产品要求附件格式为：doc(docx)、xls(xlsx)、ppt(ppsx)、pdf、txt、jpg(gif,png,bmp) 能打开，其余格式不让打开
    NSDictionary *mappingDic = @{@"word":@(YXFileTypeDoc),
                                 @"excel":@(YXFileTypeDoc),
                                 @"ppt":@(YXFileTypeDoc),
                                 @"pdf":@(YXFileTypeDoc),
                                 @"text":@(YXFileTypeDoc),
                                 @"video":@(YXFileTypeUnknown),
                                 @"audio":@(YXFileTypeUnknown),
                                 @"image":@(YXFileTypePhoto),
                                 @"unknown":@(YXFileTypeUnknown)
                                 };
    NSNumber *number = [mappingDic valueForKey:typeString];
    if (number) {
        return number.integerValue;
    }
    return YXFileTypeDoc;
}
@end
