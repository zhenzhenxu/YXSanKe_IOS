//
//  MarkView.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBookInfoRequest.h"

@interface MarkView : UIView

@property (nonatomic, strong) GetBookInfoRequestItem_Mark *mark;
@property (nonatomic, copy) void (^markerBtnBlock)(UIButton *markBtn, BOOL isLineBtn);

@end
