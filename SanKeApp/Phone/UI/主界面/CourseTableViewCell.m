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

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
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
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:self.topView];
    self.middleView = [[UIView alloc] init];
    self.middleView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:self.middleView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:self.bottomView];
    
    self.posterImagView = [[UIImageView alloc] init];
    self.posterImagView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.posterImagView];
    UIView *shadeView = [[UIView alloc] init];
    shadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    [self.posterImagView addSubview:shadeView];
    [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.posterImagView);
    }];
    
    UIImageView *playImageView = [[UIImageView alloc] init];
    playImageView.backgroundColor = [UIColor blueColor];
    [self.posterImagView addSubview:playImageView];
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
        make.center.equalTo(self.posterImagView);
    }];

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
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:self.lineView];
}

- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.middleView.mas_top).offset(2.0f);
        make.height.mas_offset(7.0f);
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top).offset(2.0f);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(7.0f);
    }];
    
    [self.posterImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.left.equalTo(self.contentView.mas_left).offset(19.0f);
        make.size.mas_offset(CGSizeMake(80.0f, 80.0f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImagView.mas_right).offset(12.0f);
        make.top.equalTo(self.contentView.mas_top).offset(16.0);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0);
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
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
}
- (void)setupMokeData:(NSString *)string {
    self.titleLabel.text = [NSString stringWithFormat:@"%@小学语文七年级下册第一课",string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSString *contentString = @"啊啊大书法家饭店;阿卡京东方;看家;看京东方;阿卡京东方;卡死;打飞机;阿里看见是否;了空间啊;大理石开房间大";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentString.length)];
    self.contentLabel.attributedText = attString;
    self.expertLabel.text = @"主讲专家: 孙敏 湖北省武汉啊骄傲的加法";
}

#pragma mark - set
- (void)setCellStatus:(CourseTableViewCellStatus)cellStatus {
    _cellStatus = cellStatus;
    self.lineView.hidden = YES;
    if (_cellStatus == CourseTableViewCellStatus_Top) {
        self.topView.layer.cornerRadius = 2.0f;
        self.bottomView.layer.cornerRadius = 0.0f;
        self.lineView.hidden = NO;
    }else if (_cellStatus == CourseTableViewCellStatus_Middle) {
        self.topView.layer.cornerRadius = 0.0f;
        self.bottomView.layer.cornerRadius = 0.0f;
        self.lineView.hidden = NO;
    }else if (_cellStatus == CourseTableViewCellStatus_Bottom){
        self.topView.layer.cornerRadius = 0.0f;
        self.bottomView.layer.cornerRadius = 2.0f;
        self.lineView.hidden = YES;
    }else if (_cellStatus == (CourseTableViewCellStatus_Top|CourseTableViewCellStatus_Bottom)){
        self.topView.layer.cornerRadius = 2.0f;
        self.bottomView.layer.cornerRadius = 2.0f;
        self.lineView.hidden = YES;
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
