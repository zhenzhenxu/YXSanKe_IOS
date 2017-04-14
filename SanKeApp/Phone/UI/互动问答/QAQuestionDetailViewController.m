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
#import "QAShareView.h"
#import "QAQuestionDetailRequest.h"
static CGFloat const kBottomViewHeight = 49.0f;
@interface QAQuestionDetailViewController ()
@property (nonatomic, strong) QAQuestionDetailRequestItem_Ask *item;
@property (nonatomic, strong) QAQuestionDetailView *headerView;
@property (nonatomic, strong) YXFileItemBase *fileItem;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) QAShareView *shareView;
@property (nonatomic, assign) BOOL isWaitBool;
@end

@implementation QAQuestionDetailViewController

- (void)viewDidLoad {
    [self setupQuestionData];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self setupQuestionData];
    }];
    self.tableView.hidden = YES;
    [self setupTitle];
    [self setupObserver];
    if ([YXShareManager isQQSupport]||[YXShareManager isWXAppSupport]) {
        [self setupRightWithImageNamed:@"分享" highlightImageNamed:nil];
    }
}

- (void)firstPageFetch {
    if (!self.isWaitBool) {
        return;
    }
    [super firstPageFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupQuestionData{
    WEAK_SELF
    [QADataManager requestQuestionDetailWithID:self.askID completeBlock:^(QAQuestionDetailRequestItem *item, NSError *error) {
        STRONG_SELF
        if (error) {
            if (error.code == ASIConnectionFailureErrorType || error.code == ASIRequestTimedOutErrorType) {//网络错误/请求超时
                [self.contentView addSubview:self.errorView];
                [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];
            }else {
                [self.contentView addSubview:self.dataErrorView];
                [self.dataErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];
            }
            return;
        }
        [self.errorView removeFromSuperview];
        [self.dataErrorView removeFromSuperview];
        
        self.item = item.data.ask;
        self.tableView.hidden = NO;
        [self setupUI];
        
        QAReplyListFetcher *fetcher = [[QAReplyListFetcher alloc]init];
        fetcher.ask_id = self.item.askID;
        fetcher.pageSize = 20;
        self.dataFetcher = fetcher;
        self.isWaitBool = YES;
        self.requestDelegate = self.dataFetcher;
        [self startLoading];
        [self firstPageFetch];
    }];
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
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomViewHeight);
    }];
    
    [self setupBottomView];
}

- (void)previewAttachment {
    QAQuestionDetailRequestItem_Attachment *attach = self.item.attachmentList.firstObject;
    YXFileType type = [QAFileTypeMappingTable fileTypeWithString:attach.resType];
    if(type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    self.fileItem = [FileBrowserFactory browserWithFileType:type];
    self.fileItem.name = attach.resName;
    self.fileItem.url = attach.previewUrl;
    self.fileItem.baseViewController = self;
    [self.fileItem browseFile];
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
        make.height.mas_equalTo(kBottomViewHeight);
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
    if ([UserManager sharedInstance].userModel.isAnonymous) {
        [self showToast:@"请先登录"];
        return;
    }
    QAReplyQuestionViewController *vc = [[QAReplyQuestionViewController alloc]init];
    vc.questionID = self.item.askID;
    SKNavigationController *navVc = [[SKNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:nil];
}

- (void)setupTitle {
    UserModel *model = [UserManager sharedInstance].userModel;
    [StageSubjectDataManager fetchStageSubjectWithStageID:model.stageID subjectID:model.subjectID completeBlock:^(FetchStageSubjectRequestItem_stage *stage, FetchStageSubjectRequestItem_subject *subject) {
        NSString *title = [stage.name stringByAppendingString:subject.name];
        self.navigationItem.title = title;
    }];
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
        NSString *userFavor = dic[kQAReplyUserFavorKey];
        NSMutableArray *indexPathArray = [NSMutableArray array];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QAReplyListRequestItem_Element *item = (QAReplyListRequestItem_Element *)obj;
            if ([item.elementID isEqualToString:replyID]) {
                item.likeInfo.likeNum = favorCount;
                item.likeInfo.isLike = userFavor;
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
        NSString *updateTime = dic[kQAQuestionUpdateTimeKey];
        if ([self.item.askID isEqualToString:questionID]) {
            if (!isEmpty(replyCount)) {
                self.item.answerNum = replyCount;
            }
            if (!isEmpty(browseCount)) {
                self.item.viewNum = browseCount;
            }
            if (!isEmpty(updateTime)) {
                self.item.updateTime = updateTime;
            }
            [self.headerView updateWithReplyCount:replyCount browseCount:browseCount updateTime:updateTime];
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kQACreateReplySuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch];
    }];
}

- (void)naviRightAction {
    self.shareView = [[QAShareView alloc]init];
    [self.view addSubview:self.shareView];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    alert.contentView = self.shareView;
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.top.equalTo(view.mas_bottom).offset(0);
                make.height.mas_equalTo(153.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.equalTo(view.mas_bottom).offset(0);
            make.height.mas_equalTo(153.0f);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.height.mas_equalTo(153.0f);
                make.bottom.equalTo(view);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [self.shareView setShareActionBlock:^(YXShareType type) {
        STRONG_SELF
        NSString *url = [NSString stringWithFormat:@"http://main.zgjiaoyan.com/hddy/view?id=%@&biz_id=%@_%@_720175",self.item.askID,[UserManager sharedInstance].userModel.stageID,[UserManager sharedInstance].userModel.subjectID];
        [[YXShareManager shareManager]yx_shareMessageWithImageIcon:nil title:self.item.title message:self.item.content url:url shareType:type];
    }];
    [self.shareView setCancelActionBlock:^{
        STRONG_SELF
        [alert hide];
    }];
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
    vc.questionItem = self.item;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
