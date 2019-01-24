//
//  NSMutableAttributedString+GTextProperty.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/24.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (GTextProperty)

/**
 * @brief 设置字体 range默认 （0，s.length）
 *
 * @param font 字体
 *
 */
- (void)bba_setFont:(UIFont *)font;

/**
 * @brief 设置字体，对AttributedString的指定Range生效
 *
 * @param font 字体
 *
 */
- (void)bba_setFont:(UIFont *)font inRange:(NSRange)range;

/**
 * @brief 设置文本颜色 range默认 （0，s.length）
 *
 * @param color   字体颜色
 *
 */
- (void)bba_setColor:(UIColor *)color;

/**
 * @brief 设置文本颜色，仅对指定range生效
 *
 * @param color     字间距
 * @param range     range
 *
 */
- (void)bba_setColor:(UIColor *)color inRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
