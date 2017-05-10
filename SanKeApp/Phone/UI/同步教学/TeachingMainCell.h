//
//  TeachingMainCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedButtonActionBlock)(void);

@interface TeachingMainCell : UITableViewCell

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger *index;

- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block;

@end
