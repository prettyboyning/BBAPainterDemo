//
//  BBAPainterTextLayout.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/28.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "BBAPainterFontMetrics.h"

@class BBAPainterTextLayout;
@protocol BBAPainterTextLayoutDelegate <NSObject>

/**
 * @brief 当发生截断时，获取截断行的高度
 *
 * @param textLayout 排版模型
 * @param lineRef CTLineRef类型，截断行
 * @param index 截断行的行索引号
 *
 */
@optional
- (CGFloat)textLayout:(BBAPainterTextLayout *)textLayout maximumWidthForTruncatedLine:(CTLineRef)lineRef atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterTextLayout : NSObject

/// 待排版的AttributedString
@property (nonatomic, strong, nullable) NSAttributedString *attributedString;

/// 可排版区域的size
@property (nonatomic, assign) CGSize size;

/// 最大排版行数，默认为0即不限制排版行数
@property (nonatomic, assign) NSUInteger maximumNumberOfLines;

/// 是否自动获取 baselineFontMetrics，如果为 YES，将第一行的 fontMetrics 作为 baselineFontMetrics
@property (nonatomic, assign) BOOL retriveFontMetricsAutomatically;

/// 待排版的AttributedString的基线FontMetrics，当retriveFontMetricsAutomatically=YES时，该值框架内部会自动获取
@property (nonatomic, assign) BBAFontMetrics baselineFontMetrics;

/// 布局受高度限制，如自动截断超过高度的部分，默认为 YES
@property (nonatomic, assign) BOOL heightSensitiveLayout;

/// 如果发生截断，由truncationString指定截断显示内容，默认"..."
@property (nonatomic, strong, nullable) NSAttributedString *truncationString;

// 排版模型的代理
//@property (nonatomic, weak, nullable) id<WMGTextLayoutDelegate> delegate;

// 标记当前排版结果需要更新
- (void)setNeedsLayout;

@end

NS_ASSUME_NONNULL_END
