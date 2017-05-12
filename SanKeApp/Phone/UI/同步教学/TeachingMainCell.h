//
//  TeachingMainCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachingPageModel.h"

typedef void(^SelectedButtonActionBlock)(void);

@interface TeachingMainCell : UITableViewCell

@property (nonatomic, strong) TeachingPageModel *model;
- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block;

@end
