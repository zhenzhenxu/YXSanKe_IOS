//
//  YXTestViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTestViewController.h"
#import "StageSubjectSelectViewController.h"
#import "FilterSelectionView.h"

@interface YXTestViewController ()
@end

@implementation YXTestViewController
- (void)viewDidLoad {
    self.devTestActions = @[@"stage_subject",@"filter",@"34",@"45"];
    [super viewDidLoad];
}

- (void)stage_subject {
    StageSubjectSelectViewController *vc = [[StageSubjectSelectViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)filter {
    FilterSelectionView *v = [[FilterSelectionView alloc]init];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = v;
    [alert setHideBlock:^(AlertView *view) {
        [UIView animateWithDuration:0.3 animations:^{
            [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view.mas_right);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*300/375);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alert showWithLayout:^(AlertView *view) {
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_right);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*300/375);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(view.mas_right);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*300/375);
            }];
            [view layoutIfNeeded];
        }];
    }];
}

@end

