//
//  QAFileTypeMappingTable.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAFileTypeMappingTable.h"

@implementation QAFileTypeMappingTable
+ (YXFileType)fileTypeWithString:(NSString *)typeString{
    NSDictionary *mappingDic = @{@"doc":@(YXFileTypeDoc),
                                 @"docx":@(YXFileTypeDoc),
                                 @"xls":@(YXFileTypeDoc),
                                 @"xlsx":@(YXFileTypeDoc),
                                 @"ppt":@(YXFileTypeDoc),
                                 @"pptx":@(YXFileTypeDoc),
                                 @"pps":@(YXFileTypeDoc),
                                 @"ppsx":@(YXFileTypeDoc),
                                 @"pdf":@(YXFileTypeDoc),
                                 @"txt":@(YXFileTypeDoc),
                                 @"rar":@(YXFileTypeUnknown),
                                 @"zip":@(YXFileTypeUnknown),
                                 @"flv":@(YXFileTypeVideo),
                                 @"m3u8":@(YXFileTypeVideo),
                                 @"mp4":@(YXFileTypeVideo),
                                 @"mp3":@(YXFileTypeAudio),
                                 @"jpg":@(YXFileTypePhoto),
                                 @"gif":@(YXFileTypePhoto),
                                 @"png":@(YXFileTypePhoto),
                                 @"bmp":@(YXFileTypePhoto)};
    NSNumber *number = [mappingDic valueForKey:typeString];
    if (number) {
        return number.integerValue;
    }
    return YXFileTypeDoc;
}
@end
