//
//  BBAPainterUtils.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterUtils : NSObject

/**
 *  @brief 获取当前屏幕的contentScale
 *
 *  @return [UIScreen mainScreen].contentsScale
 */
+ (CGFloat)contentsScale;

/**
 *  @brief 求两个数的最大公约数
 *
 *  @param aView 一个UIView对象
 *
 *  @return 最大公约数
 */
+ (NSUInteger)greatestCommonDivisorWithNumber:(NSUInteger)numb1 another:(NSUInteger)numb2;

@end

NS_ASSUME_NONNULL_END
