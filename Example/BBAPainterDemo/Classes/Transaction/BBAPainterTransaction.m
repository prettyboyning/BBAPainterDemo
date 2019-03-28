//
//  BBAPainterTransaction.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/15.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterTransaction.h"
#import "BBAPainterTransactionGroup.h"
#import <objc/message.h>

@interface BBAPainterTransactionOperation : NSObject

@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id object;
@property (nonatomic, copy) BBAPainterAsyncTransactionOperationCompletionBlock completion;

- (id)initWithCompletion:(BBAPainterAsyncTransactionOperationCompletionBlock)completion;

- (void)callAndReleaseCompletionBlock:(BOOL)canceled;

@end

@implementation BBAPainterTransactionOperation


- (id)initWithCompletion:(BBAPainterAsyncTransactionOperationCompletionBlock)completion {
    self = [super init];
    if (self) {
        self.completion = [completion copy];
    }
    return self;
}

- (void)callAndReleaseCompletionBlock:(BOOL)canceled {
    void (*objc_msgSendToPerform)(id, SEL, id) = (void*)objc_msgSend;
    objc_msgSendToPerform(self.target,self.selector,self.object);
    if (self.completion) {
        self.completion(canceled);
        self.completion = nil;
    }
    self.target = nil;
    self.selector = nil;
    self.object = nil;
}

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
    BBAPainterTransactionOperation* operation = [[BBAPainterTransactionOperation alloc]
                                                     initWithCompletion:completion];
    operation.target = target;
    operation.selector = selector;
    operation.object = object;
    [self.operationsArray addObject:operation];
}

- (void)cancel {
    self.transactionState = BBAPainterAsyncTransactionStateCanceled;
}

- (void)commit {
    self.transactionState = BBAPainterAsyncTransactionStateCommitted;
    if ([_operationsArray count] == 0) {
        if (_completionBlock) {
            _completionBlock(self, NO);
        }
    } else {
        [self completeTransaction];
    }
}

- (void)completeTransaction {
    if (self.transactionState != BBAPainterAsyncTransactionStateComplete) {
        BOOL isCanceled = (self.transactionState == BBAPainterAsyncTransactionStateCanceled);
        for (BBAPainterTransactionOperation* operation in self.operationsArray) {
            [operation callAndReleaseCompletionBlock:isCanceled];
        }
        self.transactionState = BBAPainterAsyncTransactionStateComplete;
        if (_completionBlock) {
            _completionBlock(self, isCanceled);
        }
    }
}

#pragma Mark - getter

- (NSMutableArray *)operationsArray {
    if (!_operationsArray) {
        _operationsArray = [NSMutableArray array];
    }
    return _operationsArray;
}

@end
