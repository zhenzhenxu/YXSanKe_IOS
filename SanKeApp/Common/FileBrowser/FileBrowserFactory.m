//
//  FileBrowserFactory.m
//  TrainApp
//
//  Created by niuzhaowang on 2016/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "FileBrowserFactory.h"
#import "YXFileVideoItem.h"
#import "YXFileAudioItem.h"
#import "YXFilePhotoItem.h"
#import "YXFileDocItem.h"
#import "YXFileHtmlItem.h"

@implementation FileBrowserFactory

+ (YXFileItemBase *)browserWithFileType:(YXFileType)type {
    if (type == YXFileTypeVideo) {
        return [[YXFileVideoItem alloc]init];
    }else if (type == YXFileTypeAudio) {
        return [[YXFileAudioItem alloc]init];
    }else if (type == YXFileTypePhoto) {
        return [[YXFilePhotoItem alloc]init];
    }else if (type == YXFileTypeDoc) {
        return [[YXFileDocItem alloc]init];
    }else if (type == YXFileTypeHtml) {
        return [[YXFileHtmlItem alloc]init];
    }else {
        return nil;
    }
}

@end
