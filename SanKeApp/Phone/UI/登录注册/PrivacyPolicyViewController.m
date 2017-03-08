//
//  PrivacyPolicyViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私政策";
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.textView = [[UITextView alloc]init];
    self.textView.delegate = self;
    self.textView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.textView];
    NSString * str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"隐私政策" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = str;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView isFirstResponder]){
        return YES;
    }
    return NO;
}
@end
