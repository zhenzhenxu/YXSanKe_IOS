//
//  QAQuestionDetailViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionDetailViewController.h"
#import "QAReplyDetailViewController.h"
#import "QAQuestionDetailView.h"
#import "QAReplyCell.h"
#import "QAReplyListFetcher.h"
#import "QAReplyQuestionViewController.h"

@interface QAQuestionDetailViewController ()
@property (nonatomic, strong) QAQuestionDetailView *headerView;
@property (nonatomic, strong) YXFileItemBase *fileItem;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation QAQuestionDetailViewController

- (void)viewDidLoad {
    QAReplyListFetcher *fetcher = [[QAReplyListFetcher alloc]init];
    fetcher.ask_id = self.item.elementID;
    fetcher.pageSize = 20;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTitle];
    [self setupUI];
    [self setupObserver];
    if ([YXShareManager isQQSupport]||[YXShareManager isWXAppSupport]) {
        [self setupRightWithImageNamed:@"分享" highlightImageNamed:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kStageSubjectDidChangeNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupTitle];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kQAReplyInfoUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSString *replyID = dic[kQAReplyIDKey];
        NSString *favorCount = dic[kQAReplyFavorCountKey];
        NSMutableArray *indexPathArray = [NSMutableArray array];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QAReplyListRequestItem_Element *item = (QAReplyListRequestItem_Element *)obj;
            if ([item.elementID isEqualToString:replyID]) {
                item.likeInfo.likeNum = favorCount;
                [indexPathArray addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }
        }];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kQAQuestionInfoUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSString *questionID = dic[kQAQuestionIDKey];
        NSString *replyCount = dic[kQAQuestionReplyCountKey];
        NSString *browseCount = dic[kQAQuestionBrowseCountKey];
        if ([self.item.elementID isEqualToString:questionID]) {
            if (!isEmpty(replyCount)) {
                self.item.answerNum = replyCount;
            }
            if (!isEmpty(browseCount)) {
                self.item.viewNum = browseCount;
            }
            [self.headerView updateWithReplyCount:replyCount browseCount:browseCount];
        }
    }];
}

- (void)setupTitle {
    UserModel *model = [UserManager sharedInstance].userModel;
    [StageSubjectDataManager fetchStageSubjectWithStageID:model.stageID subjectID:model.subjectID completeBlock:^(FetchStageSubjectRequestItem_stage *stage, FetchStageSubjectRequestItem_subject *subject) {
        NSString *title = [stage.name stringByAppendingString:subject.name];
        self.navigationItem.title = title;
    }];
}

- (void)naviRightAction {
    [[YXShareManager shareManager]yx_shareMessageWithImageIcon:nil title:@"分享标题" message:nil url:@"www.baidu.com" shareType:YXShareType_WeChat];
}

- (void)setupUI {
    self.headerView = [[QAQuestionDetailView alloc]init];
    self.headerView.item = self.item;
    WEAK_SELF
    [self.headerView setAttachmentClickAction:^{
        STRONG_SELF
        [self previewAttachment];
    }];
    CGFloat height = [QAQuestionDetailView heightForWidth:self.view.width item:self.item];
    self.headerView.frame = CGRectMake(0, 0, self.view.width, height);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 112;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QAReplyCell class] forCellReuseIdentifier:@"QAReplyCell"];
    
    [self setupBottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    UIButton *viewCommentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    viewCommentsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [viewCommentsButton setTitle:@"我来回答" forState:UIControlStateNormal];
    [viewCommentsButton setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    [viewCommentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [viewCommentsButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"4691a6"]] forState:UIControlStateHighlighted];
    [viewCommentsButton addTarget:self action:@selector(answerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:lineView];
    [self.bottomView addSubview:viewCommentsButton];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bottomView);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    [viewCommentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.bottom.equalTo(bottomView);
    }];
}

- (void)answerButtonAction:(UIButton *)sender {
    QAReplyQuestionViewController *vc = [[QAReplyQuestionViewController alloc]init];
    SKNavigationController *navVc = [[SKNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:nil];
}
- (void)previewAttachment {
    QAQuestionListRequestItem_Attachment *attach = self.item.attachmentList.firstObject;
    YXFileType type = [QAFileTypeMappingTable fileTypeWithString:attach.resType];
    self.fileItem = [FileBrowserFactory browserWithFileType:type];
    self.fileItem.name = attach.resName;
    self.fileItem.url = attach.previewUrl;
    self.fileItem.baseViewController = self;
    [self.fileItem browseFile];
}

// 本页上方是问题详情，不应该有任何错误或为空界面覆盖，所以只需要弹个toast提示即可
- (BOOL)handleRequestData:(UnhandledRequestData *)data inView:(UIView *)view {
    if (data.error) {
        [self showToast:data.error.localizedDescription];
        return YES;
    }
    return NO;
}

#pragma mark - tableview datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAReplyCell"];
    QAReplyListRequestItem_Element *item = self.dataArray[indexPath.row];
    cell.item = item;
    return cell;
}

#pragma tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QAReplyListRequestItem_Element *item = self.dataArray[indexPath.row];
    QAReplyDetailViewController *vc = [[QAReplyDetailViewController alloc]init];
    vc.item = item;
    vc.questionTitle = self.item.title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
