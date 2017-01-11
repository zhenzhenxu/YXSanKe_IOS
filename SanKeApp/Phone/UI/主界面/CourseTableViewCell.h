//
//  CourseTableViewCell.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActitvityCommentCellFavorBlock) ();
typedef NS_OPTIONS(NSInteger, CourseTableViewCellStatus) {
    CourseTableViewCellStatus_Top = 1<<0,
    CourseTableViewCellStatus_Middle = 1<<1,
    CourseTableViewCellStatus_Bottom = 1<<2,
};
@interface CourseTableViewCell : UITableViewCell
@property (nonatomic, assign) CourseTableViewCellStatus cellStatus;
- (void)setupMokeData:(NSString *)string;
@end
