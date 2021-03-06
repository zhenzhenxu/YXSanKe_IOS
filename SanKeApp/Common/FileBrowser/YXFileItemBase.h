//
//  YXFileItemBase.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "YXFileFavorWrapper.h"

typedef NS_ENUM(NSUInteger, YXFileType) {
    YXFileTypeVideo,
    YXFileTypeAudio,
    YXFileTypePhoto,
    YXFileTypeDoc,
    YXFileTypeHtml,
    YXFileTypeUnknown
};

@interface YXFileItemBase : NSObject<YXFileFavorDelegate>

@property (nonatomic, assign) BOOL isLocal; // whether is a local file, default is NO.
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *lurl;
@property (nonatomic, strong) NSString *murl;
@property (nonatomic, strong) NSString *surl;
@property (nonatomic, assign) BOOL isNotNeededRecord;
@property (nonatomic, strong) NSString *record; // 已播放时长，用于视频
@property (nonatomic, strong) NSString *duration; // 总时长，用于视频
@property (nonatomic, strong) NSString *resourceID; // 资源id，用于上报

@property (nonatomic, weak) BaseViewController *baseViewController;
- (void)addFavorWithData:(id)data completion:(void(^)())completeBlock; // 如果需要收藏，则调用此方法
- (void)browseFile;
@end
