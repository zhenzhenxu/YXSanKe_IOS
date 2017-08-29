//
//  CourseTableViewCell.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTableViewCell.h"

@interface CourseTableViewCell ()
@property (nonatomic, strong) UIImageView *posterImagView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *expertLabel;

@end

@implementation CourseTableViewCell
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
    self.posterImagView = [[UIImageView alloc] init];
    self.posterImagView.userInteractionEnabled = YES;
    self.posterImagView.layer.cornerRadius = 2;
    self.posterImagView.clipsToBounds = YES;
    [self.contentView addSubview:self.posterImagView];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:11.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    
    self.expertLabel = [[UILabel alloc] init];
    self.expertLabel.font = [UIFont systemFontOfSize:11.0f];
    self.expertLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.expertLabel.numberOfLines = 1;
    [self.contentView addSubview:self.expertLabel];
    
}

- (void)setupLayout {    
    [self.posterImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.left.equalTo(self.contentView.mas_left).offset(20.0f);
        make.size.mas_offset(CGSizeMake(112.0f, 84.0f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImagView.mas_right).offset(10.0f);
        make.top.equalTo(self.posterImagView.mas_top).offset(5.0f);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-25.0);
    }];
    
    [self.expertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.0);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.expertLabel.mas_bottom).offset(10.0);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0);
        make.bottom.lessThanOrEqualTo(self.posterImagView.mas_bottom).offset(-5.0f);
    }];
}
- (void)setElement:(GetResListRequestItem_Data_Element *)element {
    _element = element;
    self.titleLabel.text = _element.title;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_element.summary];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _element.summary.length)];
    self.contentLabel.attributedText = attString;
    self.expertLabel.text = [NSString stringWithFormat:@"%@",_element.author];
    [self.posterImagView sd_setImageWithURL:[NSURL URLWithString:_element.thumb] placeholderImage:[UIImage imageNamed:@"默认"]];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:self];
    CGRect frame = CGRectMake(self.posterImagView.maxX, 0, self.width - self.posterImagView.maxX, self.height);
    if (CGRectContainsPoint(frame, location)) {
        BLOCK_EXEC(self.ClickCourseTitleBlock);
    }
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
