//
//  LabelTreeCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianCornerBaseCell.h"
@class LabelTreeCell;
@class GetLabelListRequestItem_Element;

typedef void(^ExpandBlock) (LabelTreeCell *cell);
typedef void(^ClickBlock) (LabelTreeCell *cell);

@interface LabelTreeCell : RadianCornerBaseCell
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, strong) GetLabelListRequestItem_Element *element;

- (void)setTreeExpandBlock:(ExpandBlock)block;
- (void)setTreeClickBlock:(ClickBlock)block;
@end
