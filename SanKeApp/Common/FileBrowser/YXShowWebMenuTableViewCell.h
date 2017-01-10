//
//  YXShowWebMenuTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXShowWebMenuTableViewCell : UITableViewCell

- (void)configCellWithTitle:(NSString *)title imageString:(NSString *)imageName highLightImage:(NSString *)highLightImage isLastOne:(BOOL)isLastOne;

@end
