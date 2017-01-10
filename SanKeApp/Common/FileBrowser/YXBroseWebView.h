//
//  YXBroseWebView.h
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "YXBrowserExitDelegate.h"
#import "YXBrowseTimeDelegate.h"

@interface YXBroseWebView : BaseViewController
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;
@property (nonatomic, weak) id<YXBrowseTimeDelegate> browseTimeDelegate;

@end
