//
//  SubmitButton.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SubmitBlock)(void);

@interface SubmitButton : UIButton

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL canEdit;
- (void)setSubmitBlock:(SubmitBlock)block;
@end
