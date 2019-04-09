//
//  SDWebImageManager+Painter.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/1.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "SDWebImageManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDWebImageManager (Painter)

@property (strong, nonatomic) NSMutableSet *failedURLs;
@property (strong, nonatomic) NSMutableArray *runningOperations;

/**
 *  @brief 通过一个URL下载图片并缓存，如果缓存已经存在，则直接读取缓存的图片
 *
 *  @param cornerRadius 圆角半径值
 *  @param cornerBackgroundColor 圆角半径的背景颜色
 *  @param cornerBorderColor 圆角半径的描边颜色
 *  @param cornerBorderWidth 圆角半径的描边宽度
 *  @param url            图片的URL
 *  @param options        图片设置选项
 *  @param size           图片大小
 *  @param isBlur         是否模糊处理
 *  @param progressBlock  进度
 *  @param completedBlock 处理完成回调
 *
 * @return 一个遵循SDWebImageOperation协议的NSObject对象
 */
- (id <SDWebImageOperation>)painter_downloadImageWithURL:(NSURL *)url
                                            cornerRadius:(CGFloat)cornerRadius
                                   cornerBackgroundColor:(UIColor *)cornerBackgroundColor
                                             borderColor:(UIColor *)borderColor
                                             borderWidth:(CGFloat)borderWidth
                                                    size:(CGSize)size
                                             contentMode:(UIViewContentMode)contentMode
                                                  isBlur:(BOOL)isBlur
                                                 options:(SDWebImageOptions)options
                                                progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                               completed:(SDInternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
