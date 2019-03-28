//
//  BBAPainterTransactionGroup.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  这个类用于管理所有transactions<BBAPainterTransaction *>容器不为空的CALayer对象
 *  BBAPainterTransactionGroup把这些CALayer对象放在一个哈希表layersContainers中
 *  BBAPainterTransactionGroup注册了一个主线程的runLoopObserver，当状态为(kCFRunLoopBeforeWaiting | kCFRunLoopExit)时，
 *  BBAPainterTransactionGroup会遍历layersContainers，来对这些CALayer上的所有BBAPainterTransaction执行 commit
 */

@interface BBAPainterTransactionGroup : NSObject

/**
 *  @brief 获取主线程CFRunLoopObserverRef，注册观察时间点并返回封装后的LWTransactionGroup对象
 *
 *  @return 一个BBAPainterTransactionGroup对象
 */
+ (BBAPainterTransactionGroup *)mainTransactionGroup;

/**
 *  @brief 将一个包含BBAPainterTransaction事物的CALayer添加到BBAPainterTransactionGroup
 *
 *  @param containerLayer CALayer容器
 */
- (void)addTransactionContainer:(CALayer *)containerLayer;

/**
 *  @brief 提交mainTransactionGroup当中所有容器中的所有任务的操作
 *
 */
+ (void)commit;


@end

NS_ASSUME_NONNULL_END
