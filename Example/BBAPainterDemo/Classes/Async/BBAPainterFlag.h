//
//  BBAPainterFlag.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  @brief 一个自增的标识符，用来取消绘制
 */
@interface BBAPainterFlag : NSObject

/**
 *  @brief 标示符值，当两次值不相等时，说明开始了一个新的绘制任务，取消当前的绘制
 *
 *  @return 标示符的值
 */
- (int32_t)value;

/**
 *  @brief 表示赋值增加1
 *
 *  @return 增加1后的标示符的值
 */
- (int32_t)increment;

@end

NS_ASSUME_NONNULL_END
