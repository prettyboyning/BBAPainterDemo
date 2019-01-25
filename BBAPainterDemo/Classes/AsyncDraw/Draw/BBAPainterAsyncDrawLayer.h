//
//  BBAPainterAsyncDrawLayer.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/25.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, BBAPainterViewDrawingPolicy) {
    /// 当 contentsChangedAfterLastAsyncDrawing 为 YES 时异步绘制
    BBAPainterViewDrawingPolicyAsyncDrawWhenContentsChanged,
    /// 同步绘制
    BBAPainterViewDrawingPolicySyncDraw,
    /// 异步绘制
    BBAPainterViewDrawingPolicyAsyncDraw,
};

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterAsyncDrawLayer : CALayer

/// 绘制完成后，内容经过此时间的渐变显示出来，默认为 0.0
@property (nonatomic, assign) NSTimeInterval fadeDuration;

/// 绘制逻辑，定义同步绘制或异步，详细见枚举定义，默认为 BBAPainterViewDrawingPolicyAsyncDrawWhenContentsChanged
@property (nonatomic, assign) BBAPainterViewDrawingPolicy drawingPolicy;

/// 在drawingPolicy 为 BBAPainterViewDrawingPolicyAsyncDrawWhenContentsChanged 时使用
/// 需要异步绘制时设置一次 YES，默认为NO
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

/// 下次AsyncDrawing完成前保留当前的contents
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;

/// 绘制次数
@property (nonatomic, assign, readonly) NSInteger drawingCount;

/**
 * @brief 增加异步绘制次数
 */
- (void)increaseDrawingCount;
/**
 * @brief 当前内容是否异步绘制
 */
- (BOOL)isAsyncDrawsCurrentContent;

@end

NS_ASSUME_NONNULL_END
