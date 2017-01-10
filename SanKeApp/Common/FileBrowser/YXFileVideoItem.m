//
//  YXFileVideoItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileVideoItem.h"
#import "YXPlayerViewController.h"

@implementation YXFileVideoItem

- (void)openFile {
    YXPlayerViewController *vc = [[YXPlayerViewController alloc] init];
    id favorData = [self valueForKey:@"favorData"];
    if (favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    vc.videoUrl = self.url;
    
    YXPlayerDefinition *d0 = [[YXPlayerDefinition alloc] init];
    d0.identifier = @"流畅";
    d0.url = self.lurl;
    
    YXPlayerDefinition *d1 = [[YXPlayerDefinition alloc] init];
    d1.identifier = @"标清";
    d1.url = self.murl;
    
    YXPlayerDefinition *d2 = [[YXPlayerDefinition alloc] init];
    d2.identifier = @"高清";
    d2.url = self.surl;
    
    vc.definitionArray = @[d0, d1, d2];
    
    vc.title = self.name;
    [[self.baseViewController visibleViewController] presentViewController:vc animated:YES completion:nil];
}

@end
