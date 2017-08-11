//
//  TeachingContentsCell.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeachingContentsCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isIndented;
@property (nonatomic, assign) BOOL isSelected;

@end
