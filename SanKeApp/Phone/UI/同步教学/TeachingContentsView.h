//
//  TeachingContentsView.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachingContentsModel.h"

@interface TeachingContentsView : UIView

@property (nonatomic, strong) TeachingContentsModel *data;
@property (nonatomic, copy) void (^pageChooseBlock)(TeachingContentsModel *model);

@end
