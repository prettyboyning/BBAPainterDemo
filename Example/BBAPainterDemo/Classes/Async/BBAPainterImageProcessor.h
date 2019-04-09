//
//  BBAPainterImageProcessor.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/2.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterImageProcessor : NSObject

/**
 *  @brief 将绘制圆角半径图片信息保存到key中
 *
 *  @param url          图片的URL
 *  @param cornerRadius 圆角半径值
 *  @param size         图片的大小
 *
 *  @return 包含了用于绘制圆角半径图片信息的字符串
 */
+ (NSString *)painter_imageTransformCacheKeyForURL:(NSURL *)url
                                      cornerRadius:(CGFloat)cornerRadius
                                              size:(CGSize)size
                             cornerBackgroundColor:(UIColor *)cornerBackgroundColor
                                       borderColor:(UIColor *)borderColor
                                       borderWidth:(CGFloat)borderWidth
                                       contentMode:(UIViewContentMode)contentMode
                                            isBlur:(BOOL)isBlur;

/**
 *  @brief 通过Key来返回一个圆角半径图片
 *
 *  @param image 原始图片
 *  @param key   包含了用于绘制圆角半径图片信息的字符串
 *
 *  @return 经过圆角半径绘制后的图片
 */
+ (UIImage *)painter_cornerRadiusImageWithImage:(UIImage*)image withKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
