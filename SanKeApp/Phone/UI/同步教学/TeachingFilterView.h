//
//  TeachingFilterView.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TeachingFilterViewDelegate <NSObject>

- (void)filterChanged:(NSArray *)filterArray;

@end


@interface TeachingFilterView : UIView

@property (nonatomic, weak) id<TeachingFilterViewDelegate> delegate;

- (void)addFilters:(NSArray *)filters forKey:(NSString *)key;

- (void)setCurrentIndex:(NSInteger)index forKey:(NSString *)key;

/**
 更新筛选条件

 @param filters 要更新的筛选条件的名字的数组
 @param key 要更新的筛选条件的类型名字
 @param isFilter 更新筛选条件后是否重新进行筛选
 */
- (void)refreshFilters:(NSArray *)filters forKey:(NSString *)key isFilter:(BOOL)isFilter;

@end
