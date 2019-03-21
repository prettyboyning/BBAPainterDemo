//
//  BBAPainterTransaction.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/15.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBAPainterTransaction;
typedef void(^BBAPainterAsyncTranscationCompletionBlock)(BBAPainterTransaction *complete, BOOL isCancelled);
typedef void(^BBAPainterAsyncTransactionOperationCompletionBlock)(BOOL canceled);

typedef NS_ENUM(NSUInteger, BBAPainterAsyncTransactionState) {
    BBAPainterAsyncTransactionStateOpen = 0,     /// 开始处理一个事务
    BBAPainterAsyncTransactionStateCommitted,    /// 提交一个事务
    BBAPainterAsyncTransactionStateCanceled,     /// 事务取消
    BBAPainterAsyncTransactionStateComplete      /// 事务完成
};

@interface BBAPainterTransaction : NSObject

/**
 * @brief 生成一个 BBAPainterTransaction
 *
 * @param callBackQueue 回调队列,默认是主队列
 * @param completion 完成回调
 */
- (BBAPainterTransaction *)initWithCallbackQueue:(dispatch_queue_t)callBackQueue completionBlock:(BBAPainterAsyncTranscationCompletionBlock)completion;

/**
 *  @brief 添加一个操作到LWTransaction
 *
 *  @param target             消息接收者
 *  @param selector           消息选择子
 *  @param object             消息参数
 *  @param operationComletion 操作完成回调
 */
- (void)addAsyncOperationWithTarget:(id)target
                           selector:(SEL)selector
                             object:(id)object
                         completion:(BBAPainterAsyncTransactionOperationCompletionBlock)operationComletion;

/// 回调队列
@property (nonatomic, assign, readonly) dispatch_queue_t callBackQueue;
/// 完成回调
@property (nonatomic, copy, readonly) BBAPainterAsyncTranscationCompletionBlock completionBlock;
/// 当前事务的状态
@property (nonatomic, assign, readonly) BBAPainterAsyncTransactionState transactionState;

@end

