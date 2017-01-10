//
//  YXAudioPlayerViewController.h
//  YanXiuApp
//
//  Created by Lei Cai on 6/11/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXPlayProgressDelegate.h"
#import "YXFileFavorWrapper.h"
#import "YXBrowserExitDelegate.h"

@interface YXAudioPlayerViewController : BaseViewController
@property (nonatomic, assign) BOOL bIsLocalFile;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, assign) CGFloat preProgress;


@property (nonatomic, weak) id<YXPlayProgressDelegate> delegate;

@property (nonatomic, strong) YXFileFavorWrapper *favorWrapper;

@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;
@end
