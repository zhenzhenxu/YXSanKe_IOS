//
//  MarkBtn.h
//  SanKeApp
//
//  Created by SRT on 2018/3/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBookInfoRequest.h"

@interface MarkBtn : UIButton

+(instancetype)initWithMarker_Item:(GetBookInfoRequestItem_Marker_Item *)item ScaleX:(CGFloat)scaleX ScaleY:(CGFloat)scaleY lineAbove:(CGFloat)lineAbove lineBelow:(CGFloat)lineBelow;

@end
