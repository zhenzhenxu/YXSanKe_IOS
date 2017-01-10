//
//  YXQLPreviewController.h
//  YanXiuApp
//
//  Created by wd on 15/12/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import "YXBrowserExitDelegate.h"
#import "YXFileFavorWrapper.h"
#import "YXBrowseTimeDelegate.h"

@interface YXQLPreviewController : QLPreviewController

@property (nonatomic, strong) NSString *qlTitle;
@property (nonatomic, strong) NSString *qlUrl;
@property (nonatomic, strong) YXFileFavorWrapper *favorWrapper;
@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;
@property (nonatomic, weak) id<YXBrowseTimeDelegate> browseTimeDelegate;

- (BOOL)canPreview;

@end
