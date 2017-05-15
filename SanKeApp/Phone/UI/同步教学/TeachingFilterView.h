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

//- (void)refreshUnitFilters:(NSArray *)filters forKey:(NSString *)key;
//
//- (void)refreshCourseFilters:(NSArray *)filters forKey:(NSString *)key;

- (void)refreshFilters:(NSArray *)filters forKey:(NSString *)key isReset:(BOOL)isReset;

@end
