//
//  QAInputAccessoryView.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HideBlock)(void);
typedef void(^CameraBlock)(void);
typedef void(^AlbumBlock)(void);


@interface QAInputAccessoryView : UIView

- (void)setHideBlock:(HideBlock)block;
- (void)setCameraBlock:(CameraBlock)block;
- (void)setAlbumBlock:(AlbumBlock)block;

@end
