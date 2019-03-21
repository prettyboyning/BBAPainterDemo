//
//  BBAPainterGifImage.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/21.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterGifImage : UIImage

/// 保存了帧索引对应的时间的字典
@property (nonatomic, strong) NSDictionary *timesForIndex;

/// 总帧数
@property (nonatomic, assign, readonly) NSUInteger frameCount;
/**
 *  @brief 获取帧索引对应的图片
 *  @param index 位置
 */
- (UIImage *)frameImageWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
