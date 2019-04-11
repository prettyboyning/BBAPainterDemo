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

@interface BBAPainterAsyncViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BBAPainterAsyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.title = @"LWImageStorage使用示例";
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
    BBAPainterLayout* layout = [self.dataSource objectAtIndex:indexPath.row];
    cell.layout = layout;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0f;
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
    {
        
        BBAPainterImageStorage* imageStorage = [[BBAPainterImageStorage alloc] init];
        imageStorage.contents = [UIImage imageNamed:@"defult_mnp_entrance"];
        imageStorage.backgroundColor = [UIColor grayColor];
        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
        imageStorage.frame = CGRectMake(self.view.bounds.size.width/2 + 15.0f, 15.0f, self.view.bounds.size.width/2 - 30.0f, 100.0f);
        
        
        BBAPainterLayout* layout = [[BBAPainterLayout alloc] init];
        [layout addStorage:imageStorage];
        [_dataSource addObject:layout];
    }
    return _dataSource;
}

@end
