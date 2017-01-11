//
//  StageSubjectHeaderView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, StageSubjectType) {
    StageSubject_Stage,
    StageSubject_Subject
};

@interface StageSubjectHeaderView : UICollectionReusableView
@property (nonatomic, assign) StageSubjectType type;
@property (nonatomic, assign) BOOL seperatorHidden; // default is NO
@end
