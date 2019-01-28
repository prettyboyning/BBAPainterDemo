//
//  BBAPainterTextLayout.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/28.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class BBAPainterTextLayout;
@protocol BBAPainterTextLayoutDelegate <NSObject>

/**
 * 当发生截断时，获取截断行的高度
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

@end

NS_ASSUME_NONNULL_END
