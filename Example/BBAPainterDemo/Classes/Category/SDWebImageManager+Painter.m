//
//  SDWebImageManager+Painter.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/1.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "SDWebImageManager+Painter.h"
#import "BBAPainterImageProcessor.h"
#import "BBAPainterDefine.h"
#import <objc/message.h>

@interface SDWebImageCombinedOperation : NSObject <SDWebImageOperation>

@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;
@property (nonatomic, copy) SDWebImageNoParamsBlock cancelBlock;
@property (nonatomic, strong) NSOperation* cacheOperation;

@end

@implementation SDWebImageManager (Painter)

@dynamic runningOperations;
@dynamic failedURLs;

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
                                               completed:(SDInternalCompletionBlock)completedBlock {
    __block SDWebImageCombinedOperation *operation = [SDWebImageCombinedOperation new];
    __weak SDWebImageCombinedOperation *weakOperation = operation;
    
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    BOOL isFailUrl = NO;
    if (url) {
        @synchronized (self.failedURLs) {
            isFailUrl = [self.failedURLs containsObject:url];
        }
    }
    
    if (url.absoluteString.length == 0 || (!(options & SDWebImageRetryFailed) && isFailUrl)) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
        [self painter_callCompletionBlockForOperation:operation
                                           completion:completedBlock
                                                error:error
                                                  url:url];
        return operation;
    }
    
    @synchronized (self.runningOperations) {
        [self.runningOperations addObject:operation];
    }
    
    // 将图片的圆角半径、模糊信息信息保存到key中
    NSString* key;
    if (cornerRadius != 0 || isBlur) {
        key = [BBAPainterImageProcessor painter_imageTransformCacheKeyForURL:url
                                                                cornerRadius:cornerRadius
                                                                        size:size
                                                       cornerBackgroundColor:cornerBackgroundColor
                                                                 borderColor:borderColor
                                                                 borderWidth:borderWidth
                                                                 contentMode:contentMode isBlur:isBlur];
    } else {
        key = [self cacheKeyForURL:url];
    }
    
    // 先从缓存中查找，先内存后硬盘
    operation.cacheOperation = [self.imageCache queryCacheOperationForKey:key done:^(UIImage * _Nullable cacheImage, NSData * _Nullable cacheData, SDImageCacheType cacheType) {
        // 如果取消了，从下载列表队列中移除
        if (operation.isCancelled) {
            [self painter_safeLyRemoveOperationFromRunning:operation];
            return ;
        }
        
        if ((!cacheImage || (options & SDWebImageRefreshCached)) && (![self.delegate respondsToSelector:@selector(imageManager:shouldDownloadImageForURL:)] || [self.delegate imageManager:self shouldDownloadImageForURL:url])) {
            
            if (cacheImage && options & SDWebImageRefreshCached) {
                [self painter_callCompletionBlockForOperation:weakOperation
                                                   completion:completedBlock
                                                        image:cacheImage
                                                         data:cacheData
                                                        error:nil
                                                    cacheType:cacheType
                                                     finished:YES
                                                          url:url];
            }
            
            // 开始下载图片
            SDWebImageDownloaderOptions downloaderOptions = 0;
            if (options & SDWebImageLowPriority) downloaderOptions |= SDWebImageDownloaderLowPriority;
            if (options & SDWebImageProgressiveDownload) downloaderOptions |= SDWebImageDownloaderProgressiveDownload;
            if (options & SDWebImageRefreshCached) downloaderOptions |= SDWebImageDownloaderUseNSURLCache;
            if (options & SDWebImageContinueInBackground) downloaderOptions |= SDWebImageDownloaderContinueInBackground;
            if (options & SDWebImageHandleCookies) downloaderOptions |= SDWebImageDownloaderHandleCookies;
            if (options & SDWebImageAllowInvalidSSLCertificates) downloaderOptions |= SDWebImageDownloaderAllowInvalidSSLCertificates;
            if (options & SDWebImageHighPriority) downloaderOptions |= SDWebImageDownloaderHighPriority;
            if (options & SDWebImageScaleDownLargeImages) downloaderOptions |= SDWebImageDownloaderScaleDownLargeImages;
            
            if (cacheImage && options & SDWebImageRefreshCached) {
                downloaderOptions &= ~SDWebImageDownloaderProgressiveDownload;
                downloaderOptions |= SDWebImageDownloaderIgnoreCachedResponse;
            }
            
            SDWebImageDownloadToken *subOperationToken = [self.imageDownloader downloadImageWithURL:url options:downloaderOptions progress:progressBlock completed:^(UIImage * _Nullable downloadImage, NSData * _Nullable downloadData, NSError * _Nullable error, BOOL finished) {
                __strong typeof(weakOperation) strongOperation = weakOperation;
                if (!strongOperation || strongOperation.isCancelled) {
                    
                } else if (error) {
                    [self painter_callCompletionBlockForOperation:strongOperation completion:completedBlock error:error url:url];
                    if (error.code != NSURLErrorNotConnectedToInternet
                        && error.code != NSURLErrorCancelled
                        && error.code != NSURLErrorTimedOut
                        && error.code != NSURLErrorInternationalRoamingOff
                        && error.code != NSURLErrorDataNotAllowed
                        && error.code != NSURLErrorCannotFindHost
                        && error.code != NSURLErrorCannotConnectToHost
                        && error.code != NSURLErrorNetworkConnectionLost) {
                        @synchronized (self.failedURLs) {
                            [self.failedURLs addObject:url];
                        }
                    }
                } else {
                    if (downloadImage) {
                        BOOL cacheOnDisk = !(options & SDWebImageCacheMemoryOnly);
                        if ((options & SDWebImageRetryFailed)) {
                            @synchronized (self.failedURLs) {
                                [self.failedURLs removeObject:url];
                            }
                        }
                        if (options & SDWebImageRefreshCached && cacheImage && !downloadImage ) {
                            
                        } else if (downloadImage && (!downloadImage.images || (options & SDWebImageTransformAnimatedImage)) && [self.delegate respondsToSelector:@selector(imageManager:shouldDownloadImageForURL:)]) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                UIImage *transformedImage = [self.delegate imageManager:self transformDownloadedImage:downloadImage withURL:url];
                                if (transformedImage && finished) {
                                    [self.imageCache storeImage:downloadImage imageData:(transformedImage ? nil : downloadData) forKey:key toDisk:cacheOnDisk completion:nil];
                                }
                                
                                [self painter_callCompletionBlockForOperation:strongOperation completion:completedBlock image:downloadImage data:downloadData error:nil cacheType:SDImageCacheTypeNone finished:finished   url:url];
                            });
                        } else {
                            if (downloadImage && finished) {
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                    [self.imageCache storeImage:downloadImage imageData:downloadData forKey:key toDisk:cacheOnDisk completion:^{
                                        dispatch_main_async_safe(^{
                                            if (operation && !operation.isCancelled && completedBlock ) {
                                                if ([key hasPrefix:[NSString stringWithFormat:@"%@", kBBAPainterImageProcessorPrefixKey]]) {
                                                    completedBlock([self.imageCache imageFromCacheForKey:key],
                                                                   downloadData,
                                                                   nil,
                                                                   SDImageCacheTypeNone,
                                                                   finished,
                                                                   url);
                                                } else {
                                                    completedBlock(downloadImage,
                                                                   downloadData,
                                                                   nil,
                                                                   SDImageCacheTypeNone,
                                                                   finished,
                                                                   url);
                                                }
                                            }
                                        });
                                    }];
                                });
                            }
                        }
                        
                    }
                }
                if (finished) {
                    [self painter_safeLyRemoveOperationFromRunning:strongOperation];
                }
            }];
            operation.cancelBlock = ^{
                [self.imageDownloader cancel:subOperationToken];
                __strong __typeof(weakOperation) strongOperation = weakOperation;
                [self painter_safeLyRemoveOperationFromRunning:strongOperation];
            };
        } else if (cacheImage) {
            __strong __typeof(weakOperation) strongOperation = weakOperation;
            [self painter_callCompletionBlockForOperation:strongOperation completion:completedBlock image:cacheImage data:cacheData error:nil cacheType:cacheType finished:YES url:url];
            [self painter_safeLyRemoveOperationFromRunning:operation];
        } else {
            
            __strong __typeof(weakOperation) strongOperation = weakOperation;
            [self painter_callCompletionBlockForOperation:strongOperation completion:completedBlock image:nil data:nil error:nil cacheType:SDImageCacheTypeNone finished:YES url:url];
            [self painter_safeLyRemoveOperationFromRunning:operation];
        }
    }];
    return operation;
}

- (void)painter_callCompletionBlockForOperation:(nullable SDWebImageCombinedOperation *)operation
                                     completion:(nullable SDInternalCompletionBlock)completionBlock
                                          error:(nullable NSError *)error
                                            url:(nullable NSURL *)url {
    [self painter_callCompletionBlockForOperation:operation
                                       completion:completionBlock
                                            image:nil data:nil
                                            error:error
                                        cacheType:SDImageCacheTypeNone
                                         finished:YES
                                              url:url];
}

- (void)painter_callCompletionBlockForOperation:(nullable SDWebImageCombinedOperation *)operation
                                     completion:(nullable SDInternalCompletionBlock)completionBlock
                                          image:(nullable UIImage *)image
                                           data:(nullable NSData *)data
                                          error:(nullable NSError *)error
                                      cacheType:(SDImageCacheType)cacheType
                                       finished:(BOOL)finished
                                            url:(nullable NSURL *)url {
    dispatch_main_async_safe(^{
        if (operation && !operation.isCancelled && completionBlock) {
            completionBlock(image, data, error, cacheType, finished, url);
        }
    });
}

- (void)painter_safeLyRemoveOperationFromRunning:(SDWebImageCombinedOperation *)operation {
    @synchronized (self.runningOperations) {
        if (operation) {
            if ([self.runningOperations containsObject:operation]) {
                [self.runningOperations removeObject:operation];
            }
        }
    }
}

@end
