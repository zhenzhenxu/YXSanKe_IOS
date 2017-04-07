//
//  QAShareView.h
//  SanKeApp
//
//  Created by ZLL on 2017/4/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancelActionBlock)(void);
typedef void(^ShareActionBlock)(YXShareType type);
@interface QAShareModel : NSObject
@property (nonatomic, assign) YXShareType type;
@end

@interface QAShareView : UIView

- (void)setCancelActionBlock:(CancelActionBlock)block;
- (void)setShareActionBlock:(ShareActionBlock)block;
@end
