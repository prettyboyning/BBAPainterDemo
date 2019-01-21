//
//  BBAPainterBaseViewModel.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/17.
//

#import "BBAPainterBaseViewModel.h"

@interface BBAPainterBaseViewModel () {
    dispatch_queue_t prelayout_queue;
}

@property (nonatomic, strong) NSError *error;

@end

@implementation BBAPainterBaseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _error = nil;
        _loadState = BBARefreshLoadStatusUnload;
        const char *queue_name = [[NSString stringWithFormat:@"%@_prelayout_queue", [self class]] cStringUsingEncoding:NSUTF8StringEncoding];
        prelayout_queue = dispatch_queue_create(queue_name, DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}

- (void)reloadDataWithParams:(NSDictionary *)params completion:(BBAPrelayoutCompletionBlock)completion {
    _error = nil;
    [self bba_async_safe_invoke:^{
        [self reloadDataResultWithParams:@{} completion:^(BBAPainterResultSet * _Nonnull resultSet, NSError * _Nonnull error) {
            
        }];
    }];
}

- (void)reloadDataResultWithParams:(NSDictionary *)params completion:(BBAEngineLoadCompletion)completion {
    // 父类统一处理，否则子类覆盖
}

- (void)dealloc {
    NSLog(@"sgh");
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
