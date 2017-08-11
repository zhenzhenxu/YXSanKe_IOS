//
//  TeachingMainCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QASlideItemBaseView.h"
#import "TeachingPageModel.h"
#import "MarkView.h"


typedef void(^SelectedButtonActionBlock)(void);

@interface TeachingMainCell : QASlideItemBaseView

@property (nonatomic, strong) MarkView *markView;
@property (nonatomic, strong) TeachingPageModel *model;
@property (nonatomic, copy) void (^showMarkDetailBlock)(UIButton *markBtn);
- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block;

@end
