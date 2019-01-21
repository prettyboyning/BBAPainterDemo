//
//  BBARecommendViewModel.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/4.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBARecommendViewModel.h"


@implementation BBARecommendViewModel

- (void)reloadDataResultWithParams:(NSDictionary *)params completion:(BBAEngineLoadCompletion)completion {
    if (_loadState == BBARefreshLoadStatusLoading) {
        return;
    }
    
    _loadState = BBARefreshLoadStatusLoading;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recommend.json" ofType:nil]];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *appList = [[dictionary objectForKey:@"data"] objectForKey:@"app_list"];
    NSLog(@"%@", appList);
    _loadState = BBARefreshLoadStatusLoaded;
}


#pragma mark - setter & getter

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
