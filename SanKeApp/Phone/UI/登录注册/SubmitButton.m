//
//  SubmitButton.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SubmitButton.h"

@interface SubmitButton ()
@property (nonatomic, copy) SubmitBlock block;

@end

@implementation SubmitButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.layer.cornerRadius = 2.0f;
    self.clipsToBounds = YES;
    
    [self setButtonColor];
    [self addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitButtonAction {
    BLOCK_EXEC(self.block);
}


- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setSubmitBlock:(SubmitBlock)block {
    self.block = block;
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    self.enabled = canEdit;
    [self setButtonColor];
}

- (void)setButtonColor {
    if (self.canEdit) {
        [self setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
       self.backgroundColor = [UIColor colorWithHexString:@"4691a6"];
    }else {
        [self setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
          self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
}
@end
