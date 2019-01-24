//
//  BBARecommendViewModel.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/4.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBARecommendViewModel.h"
#import "BBAPainterRecommendModel.h"
#import "BBAPainterResultSet.h"
#import "BBAPainterRecommendCellData.h"

@implementation BBARecommendViewModel

- (void)reloadDataResultWithParams:(NSDictionary *)params completion:(BBAEngineLoadCompletion)completion {
    if (_loadState == BBARefreshLoadStatusLoading) {
        return;
    }
    
    _loadState = BBARefreshLoadStatusLoading;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recommend.json" ofType:nil]];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *appList = [[dictionary objectForKey:@"data"] objectForKey:@"app_list"];
    NSMutableArray *result = [NSMutableArray array];
    [appList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BBAPainterRecommendModel *model = [BBAPainterRecommendModel new];
        [model setValueWithDict:obj];
        [result addObject:model];
    }];
    [_resultSet addItems:result];
    if (completion) {
        completion(_resultSet, nil);
    }
    _loadState = BBARefreshLoadStatusLoaded;
}

- (BBAPainterBaseCellData *)refreshCellDataWithMetaData:(BBAPainterBaseCellData *)item {
    BBAPainterRecommendCellData *cellData = [BBAPainterRecommendCellData new];
    
    return cellData;
}

@end
