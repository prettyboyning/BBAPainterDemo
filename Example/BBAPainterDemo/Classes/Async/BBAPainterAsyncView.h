//
//  BBAPainterAsyncView.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBAPainterDefine.h"
#import "BBAPainterLayout.h"

NS_ASSUME_NONNULL_BEGIN
@class BBAPainterImageStorage, BBAPainterImageView, BBAPainterLayout;
@protocol BBAPainterAsyncViewDelegate <NSObject>
@optional

/**
 *  @brief 点击BBAPainterImageView时，可以在这个代理方法里收到回调
 *
 *  @param asyncDisplayView BBAPainterImageStorage所处的BBAPainterImageView
 *  @param imageStorage     点击的那个LWImageStorage对象
 *  @param touch            点击事件的UITouch对象
 */
- (void)lwAsyncDisplayView:(BBAPainterImageView *)asyncDisplayView didCilickedImageStorage:(BBAPainterImageStorage *)imageStorage touch:(UITouch *)touch;

/**
 *  @brief 可以在这个代理方法里完成额外的绘制任务，相当于UIView的“drawRect:”方法。但是在这里绘制任务的都是在子线程完成的。
 *
 *  @param context     CGContextRef对象
 *  @param size        绘制空间的大小，需要在这个size的范围内绘制
 *  @param isCancelled 是否取消
 */
- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size isCancelled:(painterAsyncDisplayIsCancelledBlock)isCancelled;


@end

@interface BBAPainterAsyncView : UIView

/// 是否异步绘制，默认是YES
@property (nonatomic, assign) BOOL displaysAsynchronously;
/// 代理
@property (nonatomic, weak) id <BBAPainterAsyncViewDelegate> delegate;
/// 布局模型对象
@property (nonatomic, strong) id <painterLayoutProtocol> layout;

@end

NS_ASSUME_NONNULL_END
