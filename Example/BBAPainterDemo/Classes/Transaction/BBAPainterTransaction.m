//
//  BBAPainterTransaction.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/15.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterTransaction.h"

@interface BBAPainterTransactionOperation : NSObject


@end


@interface BBAPainterTransaction ()

/// 回调队列
@property (nonatomic, assign) dispatch_queue_t callBackQueue;
/// 完成回调
@property (nonatomic, copy) BBAPainterAsyncTranscationCompletionBlock completionBlock;
/// 当前事务的状态
@property (nonatomic, assign) BBAPainterAsyncTransactionState transactionState;
/// 存放操作的数组
@property (nonatomic, strong) NSMutableArray *operationsArray;

@end

@implementation BBAPainterTransaction

- (BBAPainterTransaction *)initWithCallbackQueue:(dispatch_queue_t)callBackQueue completionBlock:(BBAPainterAsyncTranscationCompletionBlock)completion {
    self = [super init];
    if (self) {
        if (callBackQueue == NULL) {
            callBackQueue = dispatch_get_main_queue();
        }
        _callBackQueue = callBackQueue;
        _completionBlock = [completion copy];
        _transactionState = BBAPainterAsyncTransactionStateOpen;
    }
    return self;
}

- (void)addAsyncOperationWithTarget:(id)target selector:(SEL)selector object:(id)object completion:(BBAPainterAsyncTransactionOperationCompletionBlock)completion {
//    return YES;
}

- (NSMutableArray *)operationsArray {
    if (!_operationsArray) {
        _operationsArray = [NSMutableArray array];
    }
    return _operationsArray;
}

@end
