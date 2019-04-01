//
//  BBAPainterImageView+WebCache.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/1.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterImageView+WebCache.h"

@implementation BBAPainterImageView (WebCache)

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
                           completed:(painterWebImageDownloaderCompletionBlock)completedBlock {
    
}

@end
