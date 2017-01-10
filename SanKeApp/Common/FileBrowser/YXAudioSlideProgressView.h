//
//  YXAudioSlideProgressView.h
//  YanXiuApp
//
//  Created by Lei Cai on 6/11/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXAudioSlideProgressView : UIControl
@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL bSliding;
- (void)updateUI;
@end
