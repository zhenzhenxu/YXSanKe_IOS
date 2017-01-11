//
//  RadianBaseCell.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger, RadianBaseCellStatus) {
    RadianBaseCellStatus_Top = 1<<0,
    RadianBaseCellStatus_Middle = 1<<1,
    RadianBaseCellStatus_Bottom = 1<<2,
};
@interface RadianBaseCell : UITableViewCell
@property (nonatomic, assign) RadianBaseCellStatus cellStatus;
@end
