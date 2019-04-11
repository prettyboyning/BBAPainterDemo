//
//  BBAPainterAsyncLayer.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BBAPainterDefine.h"


NS_ASSUME_NONNULL_BEGIN
@class BBAPainterFlag;
@protocol BBAPainterAsyncDisplayLayerDelegate;
@interface BBAPainterAsyncLayer : CALayer

/// 是否开启异步执行，默认是 YES
@property (nonatomic, assign) BOOL displayAsynchronously;
/// 一个自增的标识类，用于取消绘制
@property (nonatomic, strong, readonly) BBAPainterFlag* displayFlag;

/**
 *  @brief 取消异步绘制
 */
- (void)cancelAsyncDisplay;

/**
 *  @brief 立即绘制，在主线程
 */
- (void)displayImmediately;

@end

@interface BBAPainterAsyncDisplayTransaction : NSObject

/// 即将开始绘制
@property (nullable, nonatomic, copy) painterLayerDisplayWillDisplayBlock willDisplayBlock;

/// 绘制的具体实现
@property (nullable, nonatomic, copy) painterLayerDisplayBlock displayBlock;

/// 绘制已经完成
@property (nullable, nonatomic, copy) painterLayerDidDisplayBlock didDisplayBlock;

@end

@protocol BBAPainterAsyncDisplayLayerDelegate <NSObject>

@required
/**
 *  @brief 异步绘制协议的协议方法
 *  @return 返回一个异步绘制任务的抽象BBAPainterAsyncDisplayTransaction对象，可以通过这个对象的属性来得到将要开始绘制时，绘制时，和绘制完成时的回调。
 */
- (BBAPainterAsyncDisplayTransaction *)asyncDisplayTransaction;

@end

NS_ASSUME_NONNULL_END
