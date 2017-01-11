//
//  FilterCell.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UICollectionViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isCurrent;
@property (nonatomic, strong) void(^ActionBlock) (void);

+ (CGSize)sizeForTitle:(NSString *)title;
@end
