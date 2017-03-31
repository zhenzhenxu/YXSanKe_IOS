//
//  QADeleteImageViewController.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^DeleteBlock)(void);

@interface QADeleteImageViewController : BaseViewController
@property (nonatomic, strong) UIImage *image;

- (void)setDeleteBlock:(DeleteBlock)block;
@end
