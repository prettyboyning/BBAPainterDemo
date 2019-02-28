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
    [_resultSet addItems:result];
    [_resultSet addItems:result];
    if (completion) {
        completion(_resultSet, nil);
    }
    _loadState = BBARefreshLoadStatusLoaded;
}

- (BBAPainterBaseCellData *)refreshCellDataWithMetaData:(BBAPainterBaseModel *)item {
    BBAPainterRecommendCellData *cellData = [BBAPainterRecommendCellData new];
    if ([item isKindOfClass:[BBAPainterRecommendModel class]]) {
        BBAPainterRecommendModel *itemModel = (BBAPainterRecommendModel*)item;
        NSMutableAttributedString *nameAttributed = [[NSMutableAttributedString alloc] initWithString:itemModel.name];
        [nameAttributed addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, nameAttributed.string.length)];
        cellData.name = nameAttributed.copy;
        
        NSMutableAttributedString *desAttributed = [[NSMutableAttributedString alloc] initWithString:itemModel.itemDescription];
        [desAttributed addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, desAttributed.string.length)];
        cellData.descriptionText = desAttributed.copy;
        
        cellData.icon = itemModel.icon;
    }
    
    return cellData;
}

@end
