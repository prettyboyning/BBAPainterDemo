//
//  BBAPainterHomeViewController.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/2/18.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterHomeViewController.h"
#import "BBAPainterBaseViewController.h"
#import "BBAPainterListViewController.h"

typedef NS_ENUM(NSUInteger, PainterDemoSection) {
    PainterDemoSection_Basic,
    PainterDemoSection_List,
};

typedef NS_ENUM(NSInteger, PainterDemoListRow) {
    PainterDemoListRow_ResturantList,
    PainterDemoListRow_OrderList,
};


@interface BBAPainterHomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation BBAPainterHomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title =  @"Examples";
    
    _dataSource = [NSMutableArray array];
    _dataSource = @[@[@"基本使用", @"高级使用", @"文本计算", @"图片相关"], @[@"列表", @"订单列表"]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = [_dataSource objectAtIndex:section];
    return [list count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    //    view.backgroundColor = WMGHEXCOLOR(0xF4F4F4);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 25)];
    label.backgroundColor = [UIColor clearColor];
    //    label.textColor = WMGHEXCOLOR(0x333333);
    label.font = [UIFont systemFontOfSize:14];
    label.text = (section == 0) ? @"基本使用" : @"列表示例";
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *section = [_dataSource objectAtIndex:indexPath.section];
    NSString *text = [section objectAtIndex:indexPath.row];
    
    static NSString *PainterKey = @"PainterCellKey";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PainterKey];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PainterKey];
    }
    cell.textLabel.text = text;
    //    WMGBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:PainterKey];
    //    if (cell == nil) {
    //        cell = [[WMGBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PainterKey];
    //        cell.textLabel.textColor = WMGHEXCOLOR(0x333333);
    //        cell.textLabel.font = [UIFont systemFontOfSize:18];
    //    }
    //    cell.textLabel.text = text;
    //    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //
    //    WMGBaseCellData *data = [[WMGBaseCellData alloc] init];
    //    data.cellWidth = self.view.frame.size.width;
    //    data.cellHeight = 60;
    //    data.separatorStyle = WMGCellSeparatorLineStyleLeftPadding;
    //    [cell setupCellData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == PainterDemoSection_Basic) {
        BBAPainterBaseViewController *detailVC = [[BBAPainterBaseViewController alloc] initWithStyle:(PainterDemoBasicRow)indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (indexPath.section == PainterDemoSection_List){
        if (indexPath.row == PainterDemoListRow_ResturantList) {
            BBAPainterListViewController *resturantVC = [[BBAPainterListViewController alloc] init];
            [self.navigationController pushViewController:resturantVC animated:YES];
        }
        //        else if (indexPath.row == PainterDemoListRow_OrderList){
        //            DemoOrderListViewController *orderVC = [[DemoOrderListViewController alloc] init];
        //            [self.navigationController pushViewController:orderVC animated:YES];
        //        }
    }
}

@end
