//
//  MenuSelectionView.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseMenuBlock)(NSInteger index);

@interface MenuSelectionView : UIView

@property (nonatomic, strong) NSArray *dataArray;
- (void)setChooseMenuBlock:(ChooseMenuBlock)block;
- (CGFloat)totalHeight;

@end
