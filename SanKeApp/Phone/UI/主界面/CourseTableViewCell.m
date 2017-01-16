//
//  CourseTableViewCell.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTableViewCell.h"
#import "PlayImageView.h"
@interface CourseTableViewCell ()
@property (nonatomic, strong) PlayImageView *posterImagView;
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
    self.posterImagView = [[PlayImageView alloc] init];
    self.posterImagView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.posterImagView];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"1d878b"];
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];
    
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImagView.mas_right).offset(12.0f);
        make.top.equalTo(self.contentView.mas_top).offset(16.0);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-20.0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.0);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0);
    }];
    
    [self.expertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(8.0);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0);
    }];
}
- (void)setElement:(ChannelIndexRequestItem_Data_Elements *)element {
    _element = element;
    self.titleLabel.text = _element.title;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_element.desc];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _element.desc.length)];
    self.contentLabel.attributedText = attString;
    self.expertLabel.text = [NSString stringWithFormat:@"主讲专家: %@ %@",_element.author,_element.thanks];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:self];
    if (CGRectContainsPoint(self.titleLabel.frame, location)) {
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
