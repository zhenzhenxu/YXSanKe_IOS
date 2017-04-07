//
//  QATextView.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QATextView.h"

@interface QATextView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation QATextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextViewTextDidChangeNotification object:nil]subscribeNext:^(id x) {
            STRONG_SELF
            [self handleTextChange];
        }];
        
        [self setupGestureRecognizer];
    }
    return self;
}

- (void)setupUI {
    
    self.layer.cornerRadius = 2.0f;
    self.clipsToBounds = YES;
    self.font = [UIFont systemFontOfSize:14.0f];
    self.textColor = [UIColor colorWithHexString:@"333333"];
    self.textContainerInset = UIEdgeInsetsMake(15, 10, 20, 9);
    
    self.placeholderLabel = [[UILabel alloc]init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
    self.placeholderLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.placeholderLabel];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15.0f);
    }];
}

- (void)handleTextChange {
    if (!isEmpty(self.text)) {
        self.placeholderLabel.hidden = YES;
    }else {
        self.placeholderLabel.hidden = NO;
    }
}

#pragma mark - GestureRecognizer
- (void)setupGestureRecognizer {
    UISwipeGestureRecognizer *upRecognizer;
    upRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:upRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer;
    downRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:downRecognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    [self resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

@end
