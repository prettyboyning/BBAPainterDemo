//
//  BBAPainterListViewController.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/4.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterListViewController.h"
#import "BBARecommendTableViewCell.h"
#import "BBARecommendViewModel.h"

static NSString *kBBARecommendTableViewCellIdentifier = @"kBBARecommendTableViewCellIdentifier";

@interface BBAPainterListViewController () <
UITableViewDelegate,
UITableViewDataSource>

/// 页面主tableView
@property (nonatomic, strong) UITableView *tableView;
/// 页面viewModel
@property (nonatomic, strong) BBARecommendViewModel *viewModel;


@end

@implementation BBAPainterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self loadNetworkRequestData];
}

#pragma mark - private

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.viewModel = [[BBARecommendViewModel alloc] init];
}

- (void)loadNetworkRequestData {
    [self.viewModel reloadDataWithParams:@{} completion:^(NSArray *cellLayouts, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arrayLayouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBARecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBBARecommendTableViewCellIdentifier forIndexPath:indexPath];
    
//    if ([self.recommendListModel.recommendList[indexPath.row] isKindOfClass:[BBAHomePageMNPRecommendItem class]]) {
//        BBAHomePageMNPRecommendItem *model = self.recommendListModel.recommendList[indexPath.row];
//        [cell updateRecommendTableViewCell:model];
//        if (!model.isShow) {
//            [self.recordShowAppItems safe_addObject:model];
//            model.isShow = YES;
//        }
//    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([self.recommendListModel.recommendList[indexPath.row] isKindOfClass:[BBAHomePageMNPRecommendItem class]]) {
//        BBAHomePageMNPRecommendItem *model = self.recommendListModel.recommendList[indexPath.row];
//        if (CHECK_STRING_VALID(model.schema)) {
//            [BBAHomePageMNPRecommendListModel openSchemeDispatcherWithUrl:model.schema];
//        }
//
//        /// 添加UBC打点
//        NSString *sext = @"";
//        if (CHECK_DICTIONARY_VALID(self.recommendListModel.recommendSext)) {
//            sext = [self.recommendListModel.recommendSext JSONString];
//        }
//        [BBAHomePageEntranceMNPUbc UBCClickListActionWithPage:@"index" andValue:[NSString stringWithFormat:@"%ld",indexPath.row + 1] andsource:@"rcm" andAppId:model.appkey andExt:sext];
//    }
}

#pragma mark - setter & getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[BBARecommendTableViewCell class] forCellReuseIdentifier:kBBARecommendTableViewCellIdentifier];
    }
    return _tableView;
}



@end
