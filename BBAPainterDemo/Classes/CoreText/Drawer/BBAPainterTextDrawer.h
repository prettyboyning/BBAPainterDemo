//
//  BBAPainterTextDrawer.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/26.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class BBAPainterTextLayout;
@class BBAPainterAttachment;

@protocol BBAPainterTextDrawerDelegate;
NS_ASSUME_NONNULL_BEGIN

/*
 *  @brief 文本绘制器类是框架核心类，混排图文的绘制、size计算都依赖文本绘制器实现
 */

@interface BBAPainterTextDrawer : UIResponder

/// 文本绘制器的绘制起点和绘制区域的定义，Frame会被拆解成两部分，origin决定绘制起点，size决定绘制区域大小
@property (nonatomic, assign) CGRect frame;

// CoreText排版模型封装
@property (nonatomic, strong, readonly) BBAPainterTextLayout *textLayout;

// 文本绘制器的代理
@property (nonatomic, weak) id <BBAPainterTextDrawerDelegate> delegate;

/**
 *  @brief 文本绘制器的基本绘制方法，绘制到当前上下文中
 */
- (void)draw;

@end

@protocol BBAPainterTextDrawerDelegate <NSObject>

@optional

/**
 *  @brief textAttachment 渲染的回调方法，
 *  delegate 可以通过此方法定义 Attachment 的样式，具体显示的方式可以是绘制到 context 或者添加一个自定义 View
 *
 *  @param textDrawer   执行文字渲染的 textDrawer
 *  @param att          需要渲染的 TextAttachment
 *  @param frame        建议渲染到的 frame
 *  @param context      当前的 CGContext
 */
//- (void)textDrawer:(BBAPainterTextDrawer *)textDrawer replaceAttachment:(id <BBAPainterAttachment>)att frame:(CGRect)frame context:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END
