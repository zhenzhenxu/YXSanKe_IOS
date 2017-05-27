//
//  StepTwoRequest.h
//  SanKeApp
//
//  Created by Lei Cai on 08/05/2017.
//  Copyright © 2017 niuzhaowang. All rights reserved.
//

#import "GetRequest.h"

@interface StepTwoRequestItem_result : JSONModel
@property (nonatomic, copy) NSString<Optional> *resid;
@end


@interface StepTwoRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) StepTwoRequestItem_result<Optional> *result;
//@property (nonatomic, copy) NSString<Optional> *code;
@end


@interface StepTwoRequest : GetRequest
@property (nonatomic, copy) NSString *md5;
@end
