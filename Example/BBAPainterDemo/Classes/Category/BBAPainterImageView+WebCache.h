//
//  BBAPainterImageView+WebCache.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/1.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterImageView.h"
#import "SDWebImageManager+Painter.h"
#import "SDWebImageCompat.h"
#import "BBAPainterDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterImageView (WebCache)

/**
 *  @param url                   图片的URL
 *  @param placeholder           占位图
 *  @param cornerRadius          圆角半径值
 *  @param cornerBackgroundColor 圆角背景颜色
 *  @param borderColor           圆角描边颜色
 *  @param borderWidth           圆角描边宽度
 *  @param size                  图片的大小
 *  @param options               图片设置选项
 *  @param progressBlock         一个下载进度回调Block
 *  @param completedBlock        一个下载完毕回调Block
 */
- (void)painter_asyncSetImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                        cornerRadius:(CGFloat)cornerRadius
               cornerBackgroundColor:(UIColor *)cornerBackgroundColor
                         borderColor:(UIColor *)borderColor
                         borderWidth:(CGFloat)borderWidth
                                size:(CGSize)size
                         contentMode:(UIViewContentMode)contentMode
                              isBlur:(BOOL)isBlur
                             options:(SDWebImageOptions)options
                            progress:(painterWebImageDownloaderProgressBlock)progressBlock
                           completed:(painterWebImageDownloaderCompletionBlock)completedBlock;

/**
 *  获取当前图片的URL
 *
 */
- (NSURL *)painter_imageURL;

/**
 *  取消当前的图片下载
 */
- (void)painter_cancelCurrentImageLoad;

@end

NS_ASSUME_NONNULL_END
