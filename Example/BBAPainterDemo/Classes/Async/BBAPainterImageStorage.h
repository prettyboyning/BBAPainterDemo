//
//  BBAPainterImageStorage.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/26.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterStorage.h"
#import "BBAPainterDefine.h"

/**
 *  如果是本地图片，可以选择是直接绘制在BBAPainterAsyncView上还是新建一个BBAPainterImageView并add到BBAPainterAsyncView上
 */
typedef NS_ENUM(NSUInteger, PainterLocalImageType){
    /**
     *  直接绘制在BBAPainterAsyncView上
     */
    PainterLocalImageDrawInLWAsyncDisplayView,
    /**
     *  绘制在BBAPainterImageView上
     */
    PainterLocalImageTypeDrawInLWAsyncImageView,
};

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterImageStorage : BBAPainterStorage <NSCoding>

/// 内容（UIImage or NSURL）
@property (nonatomic, strong) id contents;
/// 本地图片的种类，默认是PainterLocalImageDrawInLWAsyncDisplayView
@property (nonatomic, assign) PainterLocalImageType localImageType;
/// 占位图
@property (nonatomic, strong, nullable) UIImage *placeholder;
/// 加载完成是否渐隐出现
@property (nonatomic, assign, getter = isFadeShow) BOOL fadeShow;
/// 是否响应用户事件，默认是YES
@property (nonatomic, assign, getter = isUserInteractionEnabled) BOOL userInteractionEnabled;
/// 是否需要重新绘制
@property (nonatomic, assign, readonly) BOOL needRerendering;
/// 是否需要重新设置大小,不要去设置这个值，这个用于LWHTMLDisplayView重新调整图片大小比例
@property (nonatomic, assign) BOOL needResize;
/// 是否模糊处理
@property (nonatomic,assign) BOOL isBlur;

/**
 *  @brief 绘制图片
 *
 *  @param context    一个CGContextRef对象，绘制上下文
 *  @param isCancelld 是否取消绘制
 */
- (void)painter_drawInContext:(CGContextRef)context isCancelled:(painterAsyncDisplayIsCanclledBlock)isCancelld;

/**
 *  @brief 伸缩绘制
 *
 *  @param leftCapWidth 图片左边伸缩点
 *  @param topCapHeight 图片的上边伸缩点
 */
- (void)stretchableImageWithLeftCapWidth:(CGFloat)leftCapWidth topCapHeight:(NSInteger)topCapHeight;


@end

NS_ASSUME_NONNULL_END
