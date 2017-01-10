//
//  YXImageViewController.h
//  YanXiuApp
//
//  Created by Lei Cai on 6/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXFileFavorWrapper.h"
#import "YXBrowserExitDelegate.h"

@interface YXImageViewController : BaseViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) YXFileFavorWrapper *favorWrapper;
@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;
@end
