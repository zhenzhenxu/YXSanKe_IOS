//
//  PlayRecordCell.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PlayRecordCell.h"
#import "PlayImageView.h"
@interface PlayRecordCell ()
@property (nonatomic, strong) PlayImageView *posterImagView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *allTimeLabel;
@property (nonatomic, strong) UILabel *playTimeLabel;
@end

@implementation PlayRecordCell
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
    [self.contentView addSubview:self.posterImagView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    
    self.allTimeLabel = [[UILabel alloc] init];
    self.allTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.allTimeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.allTimeLabel];
    
    self.playTimeLabel = [[UILabel alloc] init];
    self.playTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.playTimeLabel.textColor = [UIColor colorWithHexString:@"d65b4b"];
    [self.contentView addSubview:self.playTimeLabel];
}
- (void)setupLayout {
    [self.posterImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.left.equalTo(self.contentView.mas_left).offset(18.0f);
        make.size.mas_offset(CGSizeMake(80.0f, 80.0f));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImagView.mas_right).offset(12.0f);
        make.top.equalTo(self.posterImagView).offset(1.0);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0);
    }];
    
    [self.allTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.bottom.equalTo(self.posterImagView).offset(1.0f);
    }];
    
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLabel.mas_right).offset(-2.0f);
        make.top.equalTo(self.allTimeLabel.mas_top);
    }];
}
- (void)setHistory:(PlayHistoryRequestItem_Data_History *)history {
    _history = history;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_history.title];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _history.title.length)];
    self.contentLabel.attributedText = attString;
    self.allTimeLabel.text = [self formatShowTime:_history.totalTime];
    CGFloat historyTime;
    if ([_history.totalTime isEqualToString:@"0"]) {
        historyTime = 0;
    }else{
        historyTime = _history.watchRecord.floatValue/_history.totalTime.floatValue * 100;
    }
    self.playTimeLabel.text = [NSString stringWithFormat:@"已观看%0.1f%%", _history.watchRecord.floatValue/_history.totalTime.floatValue * 100];
    [self.posterImagView sd_setImageWithURL:[NSURL URLWithString:_history.thumb] placeholderImage:[UIImage imageNamed:@"默认"]];
}
- (NSString *)formatShowTime:(NSString *)time {
    NSString *format = [NSString stringWithFormat:@"%0.2zd:%0.2zd:%0.2zd",time.integerValue/60/60, time.integerValue/60%60, time.integerValue%60];
    NSLog(@"%@, %@", format, time);
    return format;
    
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
