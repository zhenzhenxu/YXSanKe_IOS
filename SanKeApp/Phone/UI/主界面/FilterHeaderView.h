//
//  FilterHeaderView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterHeaderView : UICollectionReusableView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL seperatorHidden; // default is NO
@end
