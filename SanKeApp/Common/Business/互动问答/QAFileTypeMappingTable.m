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
    NSDictionary *mappingDic = @{
                                 // doc
                                 // $doc=' txt,doc,docx,wps,pdf,ps,rtf,asc,html,htm,mht,mhtml,xls,xlsx';
                                 // $ppt=' ppt,pptx,swf,exe,gsp,ppsx,pps';
                                 @"word":@(YXFileTypeDoc),
                                 @"excel":@(YXFileTypeDoc),
                                 @"ppt":@(YXFileTypeDoc),
                                 @"pdf":@(YXFileTypeDoc),
                                 @"text":@(YXFileTypeDoc),
                                 @"txt":@(YXFileTypeDoc),
                                 @"doc":@(YXFileTypeDoc),
                                 @"docx":@(YXFileTypeDoc),
                                 @"wps":@(YXFileTypeDoc),
                                 @"ps":@(YXFileTypeDoc),
                                 @"rtf":@(YXFileTypeDoc),
                                 @"asc":@(YXFileTypeDoc),
                                 @"xls":@(YXFileTypeDoc),
                                 @"xlsx":@(YXFileTypeDoc),
                                 @"pptx":@(YXFileTypeDoc),
                                 @"swf":@(YXFileTypeDoc),
                                 @"exe":@(YXFileTypeDoc),
                                 @"gsp":@(YXFileTypeDoc),
                                 @"ppsx":@(YXFileTypeDoc),
                                 @"pps":@(YXFileTypeDoc),
                                 
                                 // html
                                 @"html":@(YXFileTypeHtml),
                                 @"htm":@(YXFileTypeHtml),
                                 @"mht":@(YXFileTypeHtml),
                                 @"mhtml":@(YXFileTypeHtml),
                                 
                                 // video
                                 // $video=' avi,wmv,asf,rmvb,rm,mov,divx,flv,mp4';
                                 
                                 @"video":@(YXFileTypeVideo),
                                 @"avi":@(YXFileTypeVideo),
                                 @"wmv":@(YXFileTypeVideo),
                                 @"asf":@(YXFileTypeVideo),
                                 @"rmvb":@(YXFileTypeVideo),
                                 @"rm":@(YXFileTypeVideo),
                                 @"mov":@(YXFileTypeVideo),
                                 @"divx":@(YXFileTypeVideo),
                                 @"flv":@(YXFileTypeVideo),
                                 @"mp4":@(YXFileTypeVideo),
                                 @"m3u8":@(YXFileTypeVideo),
                                 
                                 // audio
                                 // $mp3=' mid,wav,mp3,ra,ram,asf,wma';
                                 @"audio":@(YXFileTypeAudio),
                                 @"mid":@(YXFileTypeAudio),
                                 @"wav":@(YXFileTypeAudio),
                                 @"mp3":@(YXFileTypeAudio),
                                 @"ra":@(YXFileTypeAudio),
                                 @"ram":@(YXFileTypeAudio),
                                 @"asf":@(YXFileTypeAudio),
                                 @"wma":@(YXFileTypeAudio),
                                 
                                 // image
                                 // $pic=' jpg,bmp,jpeg,gif,png,psd,tiff,eps';
                                 @"image":@(YXFileTypePhoto),         @"jpg":@(YXFileTypePhoto),
                                 @"bmp":@(YXFileTypePhoto),
                                 @"jpeg":@(YXFileTypePhoto),
                                 @"gif":@(YXFileTypePhoto),
                                 @"png":@(YXFileTypePhoto),
                                 @"psd":@(YXFileTypePhoto),
                                 @"tiff":@(YXFileTypePhoto),
                                 @"eps":@(YXFileTypePhoto),
                                 };
    NSNumber *number = [mappingDic valueForKey:typeString];
    if (number) {
        return number.integerValue;
    }
    return YXFileTypeUnknown;
}
@end
