//
//  YXBrowseTimeDelegate.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXBrowseTimeDelegate <NSObject>
- (void)browseTimeUpdated:(NSTimeInterval)time;
@end
