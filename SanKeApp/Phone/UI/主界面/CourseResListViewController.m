//
//  CourseResListViewController.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseResListViewController.h"
#import "CourseResCell.h"
#import "GetResListRequest.h"
#import "YXFileVideoItem.h"

@interface CourseResListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXFileVideoItem *videoItem;

@end

@implementation CourseResListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitle];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTitle {
    UserModel *model = [UserManager sharedInstance].userModel;
    [StageSubjectDataManager fetchStageSubjectWithStageID:model.stageID subjectID:model.subjectID completeBlock:^(FetchStageSubjectRequestItem_stage *stage, FetchStageSubjectRequestItem_subject *subject) {
        NSString *title = [stage.name stringByAppendingString:subject.name];
        self.navigationItem.title = title;
    }];
}

- (void)setupUI {
    if (self.resListArray.count < 2) {
        self.emptyView = [[EmptyView alloc]init];
        self.emptyView.title = @"很抱歉,该标签下暂无资源";
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        return;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[CourseResCell class] forCellReuseIdentifier:@"CourseResCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseResCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseResCell"];
    GetResListRequestItem_Data_Element_Res *res = self.resListArray[indexPath.row];
    cell.level = indexPath.row == 0 ? 0 : 1;
    cell.title = res.title;
    WEAK_SELF
    cell.clickBlock = ^(CourseResCell *cell) {
        STRONG_SELF
        if (cell.level == 0) {
            return;
        }
        YXFileVideoItem *videoItem = [[YXFileVideoItem alloc] init];
        videoItem.name = res.title;
        videoItem.url = res.videosMp4;
        videoItem.baseViewController = self;
        videoItem.record = res.watchRecord;
        videoItem.duration = res.totalTime;
        videoItem.resourceID = res.resoucrId;
        self.videoItem = videoItem;
        [videoItem browseFile];
        
        YXProblemItem *item = [[YXProblemItem alloc]init];
        item.grade = [UserManager sharedInstance].userModel.stageID;
        item.subject = [UserManager sharedInstance].userModel.subjectID;
        item.section_id = self.catID;
        item.edition_id = self.recordItem.edition_id ?self.recordItem.edition_id : [NSString string];
        item.volume_id = self.recordItem.volume_id ? self.recordItem.volume_id :[NSString string];
        item.unit_id = self.recordItem.unit_id ? self.recordItem.unit_id : [NSString string];
        item.course_id = self.recordItem.course_id ? self.recordItem.course_id : [NSString string];
        item.object_id = videoItem.resourceID;
        item.object_name = videoItem.name;
        item.type = YXRecordClickType;
        item.objType = @"video";
        [YXRecordManager addRecord:item];
    };
    return cell;
}

@end
