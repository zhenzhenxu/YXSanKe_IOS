//
//  QAShareCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/4/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(void);

@interface QAShareCell : UICollectionViewCell

@property (nonatomic, assign) YXShareType type;

- (void)setActionBlock:(ActionBlock)block;
@end
