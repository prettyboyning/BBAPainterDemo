//
//  BBAPainterMutableAttributedItem.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterMutableAttributedItem : NSObject

/// 视觉元素对应的resultString
@property (nonatomic, strong, readonly) NSAttributedString *resultString;

/**
 * @brief 根据Text创建一个AttributedItem
 *
 * @param text 文本
 * @return BBAPainterMutableAttributedItem
 */
+ (instancetype)itemWithText:(nullable NSString *)text;

/**
 * @brief  根据指定text初始化
 *
 * @param  text 文本
 * @return BBAPainterMutableAttributedItem
 */
- (instancetype)initWithText:(nullable NSString *)text;

@end

NS_ASSUME_NONNULL_END
