//
//  BBAPainterImageView+WebCache.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/1.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterImageView+WebCache.h"
#import "BBAPainterImageView+WebCacheOperation.h"
#import "SDWebImageManager+Painter.h"
#import "NSData+ImageContentType.h"
#import "BBAPainterGifImage.h"
#import <objc/runtime.h>

static char imageURLKey;
#define PainterAsyncImageVeiewLoadKey @"PainterAsyncImageVeiewLoadKey"

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
    // 如果当前BBAPainterImageView 上还有其他下载任务，取消掉
    [self painter_cancelCurrentImageLoad];
    if (!url) {
        return;
    }
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^ {
            self.image = placeholder;
        });
    }
    
    if (url) {
        __weak typeof(self) weakSelf = self;
        id <SDWebImageOperation> opertion = [[SDWebImageManager sharedManager] painter_downloadImageWithURL:url
                                                                                               cornerRadius:cornerRadius cornerBackgroundColor:cornerBackgroundColor
                                                                                                borderColor:borderColor
                                                                                                borderWidth:borderWidth
                                                                                                       size:size
                                                                                                contentMode:contentMode
                                                                                                     isBlur:isBlur
                                                                                                    options:options
                                                                                                   progress:progressBlock
                                                                                                  completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (!strongSelf || !image) {
                    completedBlock(image, data, error);
                        return ;
                    }
                    
                  dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                      SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
                      if (imageFormat == SDImageFormatGIF) {
                          //GIF
                          BBAPainterGifImage* gif = [[BBAPainterGifImage alloc] initWithGIFData:data];
                          dispatch_main_async_safe(^{
                              if (gif && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                                  completedBlock(gif, data, error);
                                  return;

                              } else if (gif) {
                                  strongSelf.image = nil;
                                  strongSelf.gifImage = gif;
                                  [strongSelf setNeedsLayout];

                              } else {

                                  if ((options & SDWebImageDelayPlaceholder)) {
                                      strongSelf.gifImage = nil;
                                      strongSelf.image = placeholder;
                                      [strongSelf setNeedsLayout];
                                  }
                              }

                              if (completedBlock && finished) {
                                  completedBlock(gif, data, error);
                              }
                          });
                      
                      } else {
        //                   普通图片
                          dispatch_main_async_safe(^{

                              if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                                  completedBlock(image,data,error);
                                  return ;

                              } else if (image) {
                                  strongSelf.gifImage = nil;
                                  strongSelf.image = image;
                                  [strongSelf setNeedsLayout];

                              } else {

                                  if ((options & SDWebImageDelayPlaceholder)) {
                                      strongSelf.gifImage = nil;
                                      strongSelf.image = placeholder;
                                      [strongSelf setNeedsLayout];

                                  }
                              }

                              if (completedBlock && finished) {
                                  completedBlock(image, data, error);
                              }
                          });
                      }
                  });
        }];
        
        
        //把operation设置到LWAsyncImageView的关联对象operationDictionary上，用于取消操作
        [self painter_setImageLoadOperationWithKey:opertion for:PainterAsyncImageVeiewLoadKey];
    } else {
        dispatch_main_async_safe(^{
            NSError* error = [NSError errorWithDomain:SDWebImageErrorDomain
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil,nil,error);
            }
        });
    }
}

- (NSURL *)painter_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)painter_cancelCurrentImageLoad {
    [self painter_cancelImageLoadOperationWithKey:PainterAsyncImageVeiewLoadKey];
}

@end
