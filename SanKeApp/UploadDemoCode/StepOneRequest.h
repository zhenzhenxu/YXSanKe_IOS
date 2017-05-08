//
//  StepOneRequest.h
//  SanKeApp
//
//  Created by Lei Cai on 08/05/2017.
//  Copyright © 2017 niuzhaowang. All rights reserved.
//

#import "PostRequest.h"

@interface StepOneRequest : PostRequest
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *chunkSize;
@property (nonatomic, copy) NSString *md5;

@property (nonatomic, strong) NSData<Ignore> *data;
@end


@interface StepOneResponse : JSONModel

@end
