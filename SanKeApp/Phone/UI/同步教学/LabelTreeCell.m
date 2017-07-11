//
//  LabelTreeCell.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LabelTreeCell.h"

#import "GetLabelListRequest.h"

@interface LabelTreeCell ()
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *contentBgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, copy) ExpandBlock expandBlock;
@property (nonatomic, copy) ClickBlock clickBlock;
@end

@implementation LabelTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupUI {
    [super setupUI];
    
    self.expandButton = [[UIButton alloc]init];
    [self.expandButton addTarget:self action:@selector(expandButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.expandButton];

    self.contentBgButton = [[UIButton alloc]init];
    self.contentBgButton.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.contentBgButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentBgButton addSubview:self.titleLabel];
    
    self.level = 0;
    self.isExpand = NO;
}

- (void)setLevel:(NSInteger)level {
    _level = level;
    if (level == 0) {
        [self setupUIForFirstLevel];
    }else if (level == 1) {
        [self setupUIForSecondLevel];
    }
}

- (void)setupUIForFirstLevel {
    [self.accessoryImageView removeFromSuperview];
    [self.containerView addSubview:self.lineView];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(46);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView.mas_left).mas_offset(-8);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
   
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-2);
        make.left.mas_equalTo(self.lineView.mas_right).mas_offset(1);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.right.mas_equalTo(-35);
        make.centerY.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
    }];
    
    if (self.isExpand) {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"收回"] forState:UIControlStateNormal];
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
    }
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setupUIForSecondLevel {
    [self.lineView removeFromSuperview];
    [self.contentBgButton addSubview:self.accessoryImageView];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-20-10-35);
    }];
    
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.contentBgButton.layer.cornerRadius = 2.0f;
    self.contentBgButton.clipsToBounds = YES;
}

- (void)setIsExpand:(BOOL)isExpand {
    _isExpand = isExpand;
    if (isExpand) {
        if (self.level == 0) {
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"收回"] forState:UIControlStateNormal];
        }else {
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
        }
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
    }
}

- (void)setElement:(GetLabelListRequestItem_Element *)element {
    _element = element;
    if (self.level == 0) {
        self.titleLabel.text = element.name;
        self.expandButton.hidden = NO;
        return;
    } else {
        self.expandButton.hidden = YES;
    }
    CGSize titleSize = [element.name boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 50 - 1 - 5- 10 -20, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    CGFloat labelHeight = titleSize.height;
    if (labelHeight / self.titleLabel.font.lineHeight > 1) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:element.name];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5.f];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [element.name length])];
        self.titleLabel.attributedText = attributedString1;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-23-10-35);
        }];
    }else {
        self.titleLabel.text = element.name;
    }
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
}

- (void)setTreeExpandBlock:(ExpandBlock)block {
    self.expandBlock = block;
}

- (void)setTreeClickBlock:(ClickBlock)block {
    self.clickBlock = block;
}

#pragma mark - Actions
- (void)expandButtonAction {
    BLOCK_EXEC(self.expandBlock,self);
}

- (void)contentBgButtonAction {
    if (self.level == 0) {
        BLOCK_EXEC(self.expandBlock,self);
        return;
    }
    BLOCK_EXEC(self.clickBlock, self);
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    }
    return _lineView;
}

- (UIImageView *)accessoryImageView {
    if (_accessoryImageView == nil) {
        _accessoryImageView = [[UIImageView alloc] init];
        _accessoryImageView.contentMode = UIViewContentModeScaleAspectFill;
        _accessoryImageView.image = [UIImage imageNamed:@"单元解读icon"];
    }
    return _accessoryImageView;
}
@end
