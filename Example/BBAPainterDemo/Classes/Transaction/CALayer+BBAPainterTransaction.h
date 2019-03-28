//
//  CALayer+BBAPainterTransaction.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/15.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PainterTransactionContainerState) {
    /**
     *  没有操作需要处理
     */
    PainterTransactionContainerStateNoTransactions,
    /**
     *  正在处理操作
     */
    PainterTransactionContainerStatePendingTransactions,
};

@protocol BBAPainterTransactionContainerDelegate <NSObject>

/// 操作事务容器的状态
@property (nonatomic, readonly, assign) PainterTransactionContainerState transactionContainerState;

/**
 *  @brief 取消这个容器CALayer上的所有事务,如果这个事务已经在执行了，则执行完
 */
- (void)painter_cancelAsyncTransactions;

/**
 *  @brief 操作事务容器的状态改变时回调
 */
- (void)painter_asyncTransactionContainerStateDidChange;

@end

/**
 *  这个扩展给CALayer添加一个哈希表，用来保存这个CALayer上的BBAPainterTransaction对象
 *
 */

@class BBAPainterTransaction;
@interface CALayer (BBAPainterTransaction) <BBAPainterTransactionContainerDelegate>

/// 创建一个BBAPainterTransaction并添加到transactions当中
@property (nonatomic, readonly, strong) BBAPainterTransaction *painter_asyncTransaction;
/// 这个CALayer对象上的操作事务哈希表
@property (nonatomic, strong) NSHashTable *transactions;
/// 当前正在处理的事务
@property (nonatomic, strong, nullable) BBAPainterTransaction *currentTransaction;
/// 即将要开始处理一个LWTransaction
- (void)painter_transactionContainerWillBeginTransaction:(BBAPainterTransaction *)transaction;
/// BBAPainterTransaction处理完成
- (void)painter_transactionContainerrDidCompleteTransaction:(BBAPainterTransaction *)transaction;

@end

NS_ASSUME_NONNULL_END
