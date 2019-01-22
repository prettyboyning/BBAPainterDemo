//
//  BBAPainterBaseViewModel.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/17.
//

#import "BBAPainterBaseViewModel.h"
#import "BBAPainterResultSet.h"

@interface BBAPainterBaseViewModel () {
    dispatch_queue_t prelayout_queue;
}

@property (nonatomic, strong) NSError *error;

@end

@implementation BBAPainterBaseViewModel

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _error = nil;
        _loadState = BBARefreshLoadStatusUnload;
        _resultSet = [BBAPainterResultSet new];
        _arrayLayouts = [NSMutableArray array];
        const char *queue_name = [[NSString stringWithFormat:@"%@_prelayout_queue", [self class]] cStringUsingEncoding:NSUTF8StringEncoding];
        prelayout_queue = dispatch_queue_create(queue_name, DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"sgh");
}

#pragma mark - public

- (void)reloadDataWithParams:(NSDictionary *)params completion:(BBAPrelayoutCompletionBlock)completion {
    _error = nil;
    [self bba_async_safe_invoke:^{
        [self reloadDataResultWithParams:@{} completion:^(BBAPainterResultSet * _Nonnull resultSet, NSError * _Nonnull error) {
            [self _handleNetworkResult:resultSet error:error completion:^(NSArray *cellLayouts, NSError *error) {
                
            }];
        }];
    }];
}

- (void)reloadDataResultWithParams:(NSDictionary *)params completion:(BBAEngineLoadCompletion)completion {
    // 父类统一处理，否则子类覆盖
}

#pragma mark - Private

- (void)_handleNetworkResult:(BBAPainterResultSet *)resultSet error:(NSError *)error completion:(BBAPrelayoutCompletionBlock)completion {
    NSMutableArray *layouts = [NSMutableArray array];
    [self _refreshModelWithResultSet:resultSet correspondingLayouts:layouts];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.arrayLayouts removeAllObjects];
        if (layouts.count > 0) {
            [self.arrayLayouts addObjectsFromArray:layouts];
        }

//        [self safe_invoke:^{
//            [self _updateListLoadedState];
//        }];

        if (completion) {
            completion(self.arrayLayouts, error);
        }
    });
}

- (void)_refreshModelWithResultSet:(BBAPainterResultSet *)resultSet correspondingLayouts:(NSMutableArray *)layouts {
    for (BBAPainterBaseModel *item in resultSet.items) {

        //生成视图数据
//        if (item.cellData == nil) {
//            //创建缓存
//            WMGBaseCellData *cellData = [self refreshCellDataWithMetaData:item];
//            cellData.metaData = item;
//
//            item.cellData = cellData;
//        }
//
//        //入队
//        [layouts addObject:item.cellData];
    }
}

@end

@implementation BBAPainterBaseViewModel (SafeInvoke)

- (void)bba_safe_invoke:(BBASafeInvokeBlock)block {
    if (block == NULL) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (dispatch_get_current_queue() == prelayout_queue) assert(0);
#pragma clang diagnostic pop
    dispatch_async(prelayout_queue, block);
}

- (void)bba_async_safe_invoke:(BBASafeInvokeBlock)block {
    if (block == NULL) return;
    dispatch_async(prelayout_queue, block);
}

@end
