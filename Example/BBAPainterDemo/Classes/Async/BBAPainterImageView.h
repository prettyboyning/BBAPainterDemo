//
//  BBAPainterImageView.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterImageView : UIImageView

/// 是否启动异步绘制, 默认是 YES
@property (nonatomic, assign) BOOL displayAsynchronously;

/**
 *  一个标示符字符串，跟LWImageStorage中的同名属性对应.
 *  当LWAsyncImageView不需要时，会放入LWAsyncDisplayView的reusePool当中
 *  需要用到时，通过这个identifier为key去reusePool中取
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  YES时，会把对layer.conents，setFrame等赋值任务加入到BBAPainterTransactionGroup队列中
 *  然后通过观察主线程RunLoop的状态为 kCFRunLoopBeforeWaiting | kCFRunLoopExit 时才执行
 *  默认是 YES
 */
@property (nonatomic, assign) BOOL displayTransactionGroup;


@end

NS_ASSUME_NONNULL_END
