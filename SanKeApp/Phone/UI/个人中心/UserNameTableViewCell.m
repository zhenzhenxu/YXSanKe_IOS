//
//  UserNameTableViewCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserNameTableViewCell.h"

@interface UserNameTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) ChangeNameBlock changeNameActionBlock;
@property (nonatomic, copy) ClickBlock clickActionBlock;
@end

@implementation UserNameTableViewCell

- (void)dealloc {
    [self removeObserver];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.nameTextField = [[UITextField alloc]init];
    self.nameTextField.font = [UIFont systemFontOfSize:14];
    self.nameTextField.textColor = [UIColor colorWithHexString:@"999999"];
    self.nameTextField.textAlignment = NSTextAlignmentRight;
    [self.nameTextField addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    self.nameTextField.delegate = self;
    
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedButton setImage:[UIImage imageNamed:@"学科"] forState:UIControlStateNormal];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
    [self.contentView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}
- (void)clickAction {
    BLOCK_EXEC(self.clickActionBlock,self.nameTextField);
}
- (void)setupLayout {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nameTextField];
    [self.contentView addSubview:self.selectedButton];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectedButton.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
    }];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.nameTextField);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
    }];
}

- (void)setupObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)textEditingChanged:(UITextField *)sender
{
    NSString *text = self.nameTextField.text;
    if (text.length > 16) {
        self.nameTextField.text = [text substringToIndex:16];
    }
}

- (void)configTitle:(NSString *)title content:(NSString *)content {
    self.nameTextField.text = content;
    self.titleLabel.text = title;
}

- (void)setClickBlock:(ClickBlock)block {
    self.clickActionBlock = block;
}

- (void)setChangeNameBlock:(ChangeNameBlock)block {
    self.changeNameActionBlock = block;
}

- (void)keyboardWillHide:(NSNotification *) note {
    [self.nameTextField resignFirstResponder];
    BLOCK_EXEC(self.changeNameActionBlock,self.nameTextField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
