//
//  AloneCourseTableViewCell.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AloneCourseTableViewCell.h"
#import "PlayImageView.h"
@interface AloneCourseTableViewCell ()
@property (nonatomic, strong) PlayImageView *posterImagView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *expertLabel;
@end
@implementation AloneCourseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.posterImagView = [[PlayImageView alloc] init];
    self.posterImagView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.posterImagView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    
    self.expertLabel = [[UILabel alloc] init];
    self.expertLabel.font = [UIFont systemFontOfSize:12.0f];
    self.expertLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.expertLabel.numberOfLines = 1;
    [self.contentView addSubview:self.expertLabel];
    
}

- (void)setupLayout {
    [self.posterImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.left.equalTo(self.contentView.mas_left).offset(19.0f);
        make.size.mas_offset(CGSizeMake(80.0f, 80.0f));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImagView.mas_right).offset(12.0f);
        make.top.equalTo(self.contentView.mas_top).offset(16.0);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0);
    }];
    
    [self.expertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(8.0);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0);
    }];
}
- (void)setElement:(CourseVideoRequestItem_Data_Elements *)element {
    _element = element;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_element.summary];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _element.summary.length)];
    self.contentLabel.attributedText = attString;
    self.expertLabel.text = [NSString stringWithFormat:@"%@ %@",_element.author,_element.thanks];
    [self.posterImagView sd_setImageWithURL:[NSURL URLWithString:_element.thumb] placeholderImage:[UIImage imageNamed:@"默认"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
