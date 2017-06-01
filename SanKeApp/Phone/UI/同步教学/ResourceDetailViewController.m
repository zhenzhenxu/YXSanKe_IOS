//
//  ResourceDetailViewController.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceDetailViewController.h"
#import "ResourceDetailHeaderView.h"
#import "CommentCell.h"
#import "MakeCommentViewController.h"
#import "ResourceAskListFetcher.h"
#import "ResourceDataManger.h"
#import "PhotoBrowserController.h"

@interface ResourceDetailViewController ()<MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ResourceDetailRequestItem_Data *item;
@property (nonatomic, strong) YXFileItemBase *fileItem;

@end

@implementation ResourceDetailViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    ResourceDetailHeaderView *headerView = [[ResourceDetailHeaderView alloc] init];
    headerView.item = self.item;
    WEAK_SELF
    headerView.resourceButtonBlock = ^{
        STRONG_SELF
        [self previewResource];
    };
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-49.0f);
    }];
    
    [self setupBottomView];
}

- (void)setupTitle {
    UserModel *model = [UserManager sharedInstance].userModel;
    [StageSubjectDataManager fetchStageSubjectWithStageID:model.stageID subjectID:model.subjectID completeBlock:^(FetchStageSubjectRequestItem_stage *stage, FetchStageSubjectRequestItem_subject *subject) {
        NSString *title = [stage.name stringByAppendingString:subject.name];
        self.navigationItem.title = title;
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
    [viewCommentsButton setTitle:@"我要评论" forState:UIControlStateNormal];
    [viewCommentsButton setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    [viewCommentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [viewCommentsButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"4691a6"]] forState:UIControlStateHighlighted];
    [viewCommentsButton addTarget:self action:@selector(answerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:lineView];
    [self.bottomView addSubview:viewCommentsButton];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49.0f);
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

- (void)previewResource {
    YXFileType type = [QAFileTypeMappingTable fileTypeWithString:self.item.resType];
    if(type == YXFileTypeUnknown || type == YXFileTypeAudio) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    } else if (type == YXFileTypePhoto) {
        [self setupPhotoBrowser];
        return;
    }
    [self.fileItem browseFile];
}

- (YXFileItemBase *)fileItem {
    if (_fileItem == nil) {
        _fileItem = [FileBrowserFactory browserWithFileType:[QAFileTypeMappingTable fileTypeWithString:self.item.resType]];
        _fileItem.name = self.item.resName;
        _fileItem.url = self.item.resThumb;
        _fileItem.baseViewController = self;
    }
    return _fileItem;
}

- (void)setupPhotoBrowser {
    PhotoBrowserController *browser = [[PhotoBrowserController alloc] init];
    browser.imageUrls = @[self.item.resThumb];
    [self.navigationController pushViewController:browser animated:NO];
}

- (void)answerButtonAction:(UIButton *)sender {
    if ([UserManager sharedInstance].userModel.isAnonymous) {
        [self showToast:@"请先登录"];
        return;
    }
    MakeCommentViewController *vc = [[MakeCommentViewController alloc] init];
    vc.resourceID = self.resourceID;
    vc.resName = self.item.resName;
    vc.resAuthorID = self.item.userId;
    SKNavigationController *navVc = [[SKNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:nil];
}

- (void)setupQuestionData {
    WEAK_SELF
    [ResourceDataManger requestResourceDetailWithID:self.resourceID completeBlock:^(ResourceDetailRequestItem *item, NSError *error) {
        STRONG_SELF
        if (error) {
            if (error.code == ASIConnectionFailureErrorType || error.code == ASIRequestTimedOutErrorType) { //网络错误/请求超时
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
            [self stopLoading];
            return;
        }
        [self.errorView removeFromSuperview];
        [self.dataErrorView removeFromSuperview];
        
        self.item = item.data;
        [self setupUI];
        self.tableView.hidden = NO;
        
        ResourceAskListFetcher *fetcher = [[ResourceAskListFetcher alloc] init];
        fetcher.resourceID = self.resourceID;
        fetcher.pageSize = 10;
        self.dataFetcher = fetcher;
        self.requestDelegate = self.dataFetcher;
        [self startLoading];
        [self firstPageFetch];
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kCreateResourceAskSuccessNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResourceAskListItem_Element *item = self.dataArray[indexPath.row];
    return [item.cellHeight doubleValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
