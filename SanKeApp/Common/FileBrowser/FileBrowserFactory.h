//
//  FileBrowserFactory.h
//  TrainApp
//
//  Created by niuzhaowang on 2016/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileBrowserFactory : NSObject
+ (YXFileItemBase *)browserWithFileType:(YXFileType)type;
@end
