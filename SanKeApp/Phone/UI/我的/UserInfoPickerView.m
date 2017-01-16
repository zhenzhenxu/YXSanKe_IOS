//
//  UserInfoPickerView.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoPickerView.h"

@interface UserInfoPickerView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, copy) ConfirmButtonActionBlock buttonActionBlock;
@end

@implementation UserInfoPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupLayout];
        [self hidePickerView:NO];
    }
    return self;
}

- (void)setupUI {
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.5f;
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    self.confirmButton = [[UIButton alloc] init];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.titleLabel.font = self.cancelButton.titleLabel.font;
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
    
    self.pickerView = [[UIPickerView alloc] init];
}

- (void)setupLayout {
    [self addSubview:self.backgroundView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.confirmButton];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.pickerView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@246);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(@40);
        make.left.mas_equalTo(self.contentView.mas_left).offset(40);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(self.cancelButton.mas_height);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-40);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cancelButton.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(self.cancelButton.mas_bottom);
    }];
    [self clearSeparatorWithView:self.pickerView];
}
- (void)reloadPickerView
{
    [self showPickerView:YES];
    [self.pickerView reloadAllComponents];
}

#pragma mark - touches
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self hidePickerView:YES];
    }
}

#pragma mark -
- (void)showPickerView {
    [self showPickerView:NO];
}
- (void)showPickerView:(BOOL)animated
{
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat contentHeight = CGRectGetHeight(self.contentView.bounds);
    CGRect frame = CGRectMake(0, height - contentHeight, width, contentHeight);
    self.contentView.frame = CGRectMake(0, height, width, contentHeight);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.contentView.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
    self.hidden = NO;
}

- (void)hidePickerView {
    [self hidePickerView:NO];
}
- (void)hidePickerView:(BOOL)animated
{
    if (animated) {
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat contentHeight = CGRectGetHeight(self.contentView.bounds);
        CGRect frame = CGRectMake(0, height, width, contentHeight);
        self.contentView.frame = CGRectMake(0, height - contentHeight, width, contentHeight);
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.contentView.frame = frame;
                         } completion:^(BOOL finished) {
                             self.hidden = YES;
                         }];
    } else {
        self.hidden = YES;
    }
}

- (void)cancelAction:(id)sender
{
    [self hidePickerView:YES];
}

- (void)confirmAction:(id)sender
{
    [self hidePickerView:YES];
    BLOCK_EXEC(self.buttonActionBlock);
}

-(void)setConfirmButtonActionBlock:(ConfirmButtonActionBlock)block {
    
    self.buttonActionBlock = block;
}
- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}

@end
