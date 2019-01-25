//
//  BBAPainterAsyncDrawView.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/25.
//

#import <UIKit/UIKit.h>
#import "BBAPainterAsyncDrawLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterAsyncDrawView : UIView

/// 绘制逻辑，定义同步绘制或异步，详细见枚举定义，默认为 BBAPainterViewDrawingPolicyAsyncDrawWhenContentsChanged
@property (nonatomic, assign) BBAPainterViewDrawingPolicy drawingPolicy;

/// 绘制完成后，内容经过此时间的渐变显示出来，默认为 0.0
@property (nonatomic, assign) NSTimeInterval fadeDuration;

/// 在drawingPolicy 为 BBAPainterViewDrawingPolicyAsyncDrawWhenContentsChanged 时使用
/// 需要异步绘制时设置一次 YES，默认为NO
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

/// 下次AsyncDrawing完成前保留当前的contents
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;

/// 绘制次数
@property (nonatomic, assign, readonly) NSUInteger drawingCount;

/// 用于异步绘制的队列，为nil时将使用GCD的global queue进行绘制，默认为nil
@property (nonatomic, assign) dispatch_queue_t dispatchDrawQueue;

/// 异步绘制时global queue的优先级，默认优先级为DEFAULT。在设置了drawQueue时此参数无效。
@property (nonatomic, assign) dispatch_queue_priority_t dispatchPriority;

@end

NS_ASSUME_NONNULL_END
