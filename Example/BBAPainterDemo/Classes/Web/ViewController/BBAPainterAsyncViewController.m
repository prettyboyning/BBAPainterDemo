//
//  BBAPainterAsyncViewController.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/25.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterAsyncViewController.h"
#import "BBAAsyncImageTableViewCell.h"
#import "BBAPainterImageStorage.h"
#import "BBAPainterRecommendModel.h"

@interface BBAPainterAsyncViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BBAPainterAsyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self initLoadData];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.title = @"LWImageStorage使用示例";
}

- (void)initLoadData {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recommend.json" ofType:nil]];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *appList = [[dictionary objectForKey:@"data"] objectForKey:@"app_list"];
    [appList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BBAPainterRecommendModel *model = [BBAPainterRecommendModel new];
        [model setValueWithDict:obj];
        
        BBAPainterImageStorage* imageStorage = [[BBAPainterImageStorage alloc] init];
        imageStorage.contents = [NSURL URLWithString:model.icon];
//        imageStorage.backgroundColor = [UIColor grayColor];
        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
        imageStorage.frame = CGRectMake(0, 0, 54, 54);
        imageStorage.cornerRadius = 27;
        imageStorage.cornerBorderColor = [UIColor grayColor];
        imageStorage.cornerBorderWidth = 0.3;
//        imageStorage.userInteractionEnabled = NO;
        
        BBAPainterListLayout* layout = [[BBAPainterListLayout alloc] init];
        layout.name = model.name;
        layout.itemDescription = model.itemDescription;
        [layout addStorage:imageStorage];
        [self.dataSource addObject:layout];
        
    }];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    BBAAsyncImageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BBAAsyncImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    BBAPainterListLayout* layout = [self.dataSource objectAtIndex:indexPath.row];
    cell.layout = layout;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [[NSMutableArray alloc] init];
//    {
//
//        BBAPainterImageStorage* imageStorage = [[BBAPainterImageStorage alloc] init];
//        imageStorage.contents = [UIImage imageNamed:@"defult_mnp_entrance"];
//        imageStorage.backgroundColor = [UIColor grayColor];
//        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
//        imageStorage.frame = CGRectMake(self.view.bounds.size.width/2 + 15.0f, 15.0f, self.view.bounds.size.width/2 - 30.0f, 100.0f);
//
//
//        BBAPainterLayout* layout = [[BBAPainterLayout alloc] init];
//        [layout addStorage:imageStorage];
//        [_dataSource addObject:layout];
//    }
//    {
//        BBAPainterImageStorage* imageStorage = [[BBAPainterImageStorage alloc] init];
//        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
//        imageStorage.frame = CGRectMake(self.view.bounds.size.width/2 + 15.0f, 15.0f, self.view.bounds.size.width/2 - 30.0f, 100.0f);
//        imageStorage.contents = [NSURL URLWithString:@"https://b.bdstatic.com/searchbox/mappconsole/image/20180820/1534727783204376.png"];
//        imageStorage.clipsToBounds = YES;
//
//
//        BBAPainterLayout* layout = [[BBAPainterLayout alloc] init];
//        [layout addStorage:imageStorage];
//        [_dataSource addObject:layout];
//    }
//
//    {
//        BBAPainterImageStorage* imageStorage = [[BBAPainterImageStorage alloc] init];
//        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
//        imageStorage.frame = CGRectMake(self.view.bounds.size.width/2 + 15.0f, 15.0f, self.view.bounds.size.width/2 - 30.0f, 100.0f);
//        imageStorage.contents = [NSURL URLWithString:@"https://b.bdstatic.com/searchbox/mappconsole/image/20180712/1531376287148763.png"];
//        imageStorage.clipsToBounds = YES;
//
//
//        BBAPainterLayout* layout = [[BBAPainterLayout alloc] init];
//        [layout addStorage:imageStorage];
//        [_dataSource addObject:layout];
//    }
//
//    {
//        BBAPainterImageStorage* imageStorage = [[BBAPainterImageStorage alloc] init];
//        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
//        imageStorage.frame = CGRectMake(self.view.bounds.size.width/2 + 15.0f, 15.0f, self.view.bounds.size.width/2 - 30.0f, 100.0f);
//        imageStorage.contents = [NSURL URLWithString:@"https://b.bdstatic.com/searchbox/mappconsole/image/20180820/1534727783204376.png"];
//        imageStorage.clipsToBounds = YES;
//
//
//        BBAPainterLayout* layout = [[BBAPainterLayout alloc] init];
//        [layout addStorage:imageStorage];
//        [_dataSource addObject:layout];
//    }
//
//    {
//        BBAPainterImageStorage* imageStorage = [[BBAPainterImageStorage alloc] init];
//        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
//        imageStorage.frame = CGRectMake(self.view.bounds.size.width/2 + 15.0f, 15.0f, self.view.bounds.size.width/2 - 30.0f, 100.0f);
//        imageStorage.contents = [NSURL URLWithString:@"https://b.bdstatic.com/searchbox/mappconsole/image/20180712/1531376287148763.png"];
//        imageStorage.clipsToBounds = YES;
//
//
//        BBAPainterLayout* layout = [[BBAPainterLayout alloc] init];
//        [layout addStorage:imageStorage];
//        [_dataSource addObject:layout];
//    }
    
    return _dataSource;
}

@end
