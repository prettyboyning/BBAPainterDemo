//
//  BBAPainterBaseViewModel.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/17.
//

#import "BBAPainterBaseViewModel.h"
#import "BBAPainterResultSet.h"
#import "BBAPainterBaseCellData.h"
#import "BBAPainterBaseModel.h"

@interface BBAPainterBaseViewModel () {
//    dispatch_queue_t prelayout_queue;
}

@property (nonatomic, strong) NSError *error;

@property(nonatomic, strong) dispatch_queue_t prelayout_queue;

@property (nonatomic, strong) NSMutableArray  *arrayLayouts;

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
        _prelayout_queue = dispatch_queue_create(queue_name, DISPATCH_QUEUE_SERIAL);
        
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
            [self _handleNetworkResult:resultSet error:error completion:completion];
        }];
    }];
}

- (void)reloadDataResultWithParams:(NSDictionary *)params completion:(BBAEngineLoadCompletion)completion {
    // 父类统一处理，否则子类覆盖
}

- (BBAPainterBaseCellData *)refreshCellDataWithMetaData:(BBAPainterBaseModel *)item {
    // override to subclass
    BBAPainterBaseCellData *cellData = [[BBAPainterBaseCellData alloc] init];
    return cellData;
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
        
        // 生成视图数据
        if (item.cellData == nil) {
//            //创建缓存
            BBAPainterBaseCellData *cellData = [self refreshCellDataWithMetaData:item];
            cellData.metaData = item;
//
            item.cellData = cellData;
        }
//
//        //入队
        [layouts addObject:item.cellData];
    }
}

- (void)bba_safe_invoke:(BBASafeInvokeBlock)block {
    if (block == NULL) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (dispatch_get_current_queue() == _prelayout_queue) assert(0);
#pragma clang diagnostic pop
    dispatch_async(_prelayout_queue, block);
}

- (void)bba_async_safe_invoke:(BBASafeInvokeBlock)block {
    if (block == NULL) return;
    
    dispatch_async(_prelayout_queue, block);
}

@end
