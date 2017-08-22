//
//  SlideImageView.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QASlideItemBaseView.h"
#import "MarkView.h"
#import "TeachingPageModel.h"


@interface SlideImageView : QASlideItemBaseView

@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) MarkView *markView;
@property (nonatomic, strong) TeachingPageModel *model;

@end
