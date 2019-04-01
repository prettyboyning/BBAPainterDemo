//
//  BBAPainterImageView+Display.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/31.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterImageView+Display.h"
#import "BBAPainterImageStorage.h"
#import "BBAPainterImageView+WebCache.h"
#import "BBAPainterDefine.h"
#import "UIImage+BBAGallop.h"

static CGSize _sizeFitWithAspectRatio(CGFloat aspectRatio, CGSize constraints);
static CGSize _sizeFillWithAspectRatio(CGFloat sizeToScaleAspectRatio, CGSize destinationSize);
static void _croppedImageBackingSizeAndDrawRectInBounds(CGSize sourceImageSize,CGSize boundsSize,UIViewContentMode contentMode,CGRect cropRect,BOOL forceUpscaling,CGSize* outBackingSize,CGRect* outDrawRect);

@implementation BBAPainterImageView (Display)

- (void)painterSetImageWihtImageStorage:(BBAPainterImageStorage *)imageStorage
                                 resize:(painterImageResizeBlock)resizeBlock
                             completion:(painterAsyncCompleteBlock)completion {
    if ([imageStorage.contents isKindOfClass:[UIImage class]]) {
        [self createWebImageWithImageStorage:imageStorage resize:resizeBlock completion:completion];
    } else {
        [self createWebImageWithImageStorage:imageStorage resize:resizeBlock completion:completion];
    }
    
}

- (void)createLocalImageWithImageStorage:(BBAPainterImageStorage *)imageStorage
                                  resize:(painterImageResizeBlock)resizeBlock completion:(painterAsyncCompleteBlock)completion {
    if (imageStorage.needRerendering) {
        dispatch_async(YYTextAsyncLayerGetDisplayQueue(), ^{
            UIImage *processImage = [self reRenderingImageWitImageStorage:imageStorage];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (processImage) {
                    self.image = processImage;
                }
                if (resizeBlock) {
                    resizeBlock(imageStorage, 0);
                }
                if (completion) {
                    completion();
                }
            });
        });
    } else {
        UIImage *image = (UIImage *)imageStorage.contents;
        self.image = image;
        if (resizeBlock) {
            resizeBlock(imageStorage, 0);
        }
        if (completion) {
            completion();
        }
    }
}

- (void)createWebImageWithImageStorage:(BBAPainterImageStorage *)imageStorage resize:(painterImageResizeBlock)resizeBlock completion:(painterAsyncCompleteBlock)completion {
    NSURL *url;
    id placeholder = imageStorage.placeholder;
    BOOL needResize = imageStorage.needResize;
    CGFloat cornerRaiuds = imageStorage.cornerRadius;
    UIColor *cornerBgColor = imageStorage.cornerBackgroundColor;
    UIColor *borderColor = imageStorage.cornerBorderColor;
    CGFloat borderWidth = imageStorage.cornerBorderWidth;
    CGSize imageSize = imageStorage.frame.size;
    UIViewContentMode contentMode = imageStorage.contentMode;
    BOOL isBlur = imageStorage.isBlur;
    BOOL isFadeShow = imageStorage.isFadeShow;
    
    if (isFadeShow) {
        [self.layer removeAnimationForKey:@"fadeshowAnimation"];
    }
    
    if ([imageStorage.contents isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:(NSString *)imageStorage.contents];
    } else if ([imageStorage.contents isKindOfClass:[NSURL class]]) {
        url = (NSURL *)imageStorage.contents;
    } else {
        if (resizeBlock) {
            resizeBlock(imageStorage, 0);
        }
        
        if (completion) {
            completion();
        }
        return;
    }
    
    SDWebImageOptions options = 0;
    if ([[url.absoluteString lowercaseString] hasPrefix:@".gif"]) {
        options |= SDWebImageProgressiveDownload;
    }
    __weak typeof(self) weakSelf = self;
    [self painter_asyncSetImageWithURL:url placeholderImage:placeholder cornerRadius:cornerRaiuds cornerBackgroundColor:cornerBgColor borderColor:borderColor borderWidth:borderWidth size:imageSize contentMode:contentMode isBlur:isBlur options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        
    } completed:^(UIImage *image, NSData *imageData, NSError *error) {
        if (!image) {
            if (completion) {
                completion();
            }
            return ;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
    }];
}

- (UIImage *)reRenderingImageWitImageStorage:(BBAPainterImageStorage *)imageStorage {
    UIImage *image = (UIImage *)imageStorage.contents;
    
    if (!image) {
        return nil;
    }
    
    @autoreleasepool {
        if (imageStorage.isBlur) {
            image = [image painter_applyBlurWithRadius:20 tintColor:[UIColor whiteColor] saturationDeltaFactor:1.4 maskImage:nil];
        }
        
        BOOL forceupscaling = NO;
        BOOL cropEnabled = YES;
        BOOL isOpaque = imageStorage.opaque;
        UIColor *backgroundColor = imageStorage.backgroundColor;
        UIViewContentMode contentMode = imageStorage.contentMode;
        CGFloat contentScale = imageStorage.contentsScale;
        CGRect cropDisplayBounds = CGRectZero;
        CGRect cropRect = CGRectMake(0.5, 0.5, 0, 0);
        BOOL hasValidCropBounds = cropEnabled && !CGRectIsNull(cropDisplayBounds) && !CGRectIsEmpty(cropDisplayBounds);
        CGRect bounds = (hasValidCropBounds ? cropDisplayBounds : imageStorage.bounds);
        CGSize imageSize = image.size;
        CGSize imageSizeInPixels = CGSizeMake(imageSize.width * image.scale, imageSize.height * image.scale);
        CGSize boundsSizeInPixels = CGSizeMake(floorf(bounds.size.width * contentScale), floorf(bounds.size.height * contentScale));
        BOOL contentModeSupported = contentMode == UIViewContentModeScaleAspectFill ||
        contentMode == UIViewContentModeScaleAspectFit ||
        contentMode == UIViewContentModeCenter;
        CGSize backingSize   = CGSizeZero;
        CGRect imageDrawRect = CGRectZero;
        
        CGFloat cornerRadius = imageStorage.cornerRadius;
        UIColor* cornerBackgroundColor = imageStorage.cornerBackgroundColor;
        UIColor* cornerBorderColor = imageStorage.cornerBorderColor;
        CGFloat cornerBorderWidth = imageStorage.cornerBorderWidth;
        
        if (boundsSizeInPixels.width * contentScale < 1.0f || boundsSizeInPixels.height * contentScale < 1.0f ||
            imageSizeInPixels.width < 1.0f                  || imageSizeInPixels.height < 1.0f) {
            return nil;
        }
        
        if (!cropEnabled || !contentModeSupported) {
            backingSize = imageSizeInPixels;
            imageDrawRect = (CGRect){.size = backingSize};
        } else {
            _croppedImageBackingSizeAndDrawRectInBounds(imageSizeInPixels,
                                                        boundsSizeInPixels,
                                                        contentMode,
                                                        cropRect,
                                                        forceupscaling,
                                                        &backingSize,
                                                        &imageDrawRect);
        }
        if (backingSize.width <= 0.0f || backingSize.height <= 0.0f ||
            imageDrawRect.size.width <= 0.0f || imageDrawRect.size.height <= 0.0f) {
            return nil;
        }
        
        UIGraphicsBeginImageContextWithOptions(backingSize, isOpaque, contentScale);
        
        if (nil == UIGraphicsGetCurrentContext()) {
            return nil;
        }
        
        if (isOpaque && backgroundColor) {
            [backgroundColor setFill];
            UIRectFill(CGRectMake(0, 0, backingSize.width, backingSize.height));
        }
        
        UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:imageDrawRect cornerRadius:cornerRadius * contentScale];
        UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:imageDrawRect];
        if (cornerBackgroundColor) {
            [cornerBackgroundColor setFill];
        }
        [backgroundRect fill];
        [cornerPath addClip];
        
        [image drawInRect:imageDrawRect];
        if (cornerBorderColor) {
            [cornerBorderColor setStroke];
        }
        [cornerPath stroke];
        [cornerPath setLineWidth:cornerBorderWidth];
        
        CGImageRef processedImageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
        UIGraphicsEndPDFContext();
        return [UIImage imageWithCGImage:processedImageRef];
    }
}

@end

static void _croppedImageBackingSizeAndDrawRectInBounds(CGSize sourceImageSize,
                                                        CGSize boundsSize,
                                                        UIViewContentMode contentMode,
                                                        CGRect cropRect,
                                                        BOOL forceUpscaling,
                                                        CGSize* outBackingSize,
                                                        CGRect* outDrawRect) {
    size_t destinationWidth = boundsSize.width;
    size_t destinationHeight = boundsSize.height;
    CGFloat boundsAspectRatio = (float)destinationWidth / (float)destinationHeight;
    
    CGSize scaledSizeForImage = sourceImageSize;
    BOOL cropToRectDimensions = !CGRectIsEmpty(cropRect);
    
    if (cropToRectDimensions) {
        scaledSizeForImage = CGSizeMake(boundsSize.width / cropRect.size.width, boundsSize.height / cropRect.size.height);
    } else {
        if (contentMode == UIViewContentModeScaleAspectFill)
            scaledSizeForImage = _sizeFillWithAspectRatio(boundsAspectRatio, sourceImageSize);
        else if (contentMode == UIViewContentModeScaleAspectFit)
            scaledSizeForImage = _sizeFitWithAspectRatio(boundsAspectRatio, sourceImageSize);
    }
    if (forceUpscaling == NO && (scaledSizeForImage.width * scaledSizeForImage.height) < (destinationWidth * destinationHeight)) {
        destinationWidth = (size_t)roundf(scaledSizeForImage.width);
        destinationHeight = (size_t)roundf(scaledSizeForImage.height);
        if (destinationWidth == 0 || destinationHeight == 0) {
            *outBackingSize = CGSizeZero;
            *outDrawRect = CGRectZero;
            return;
        }
    }
    
    CGFloat sourceImageAspectRatio = sourceImageSize.width / sourceImageSize.height;
    CGSize scaledSizeForDestination = CGSizeMake(destinationWidth, destinationHeight);
    if (cropToRectDimensions) {
        scaledSizeForDestination = CGSizeMake(boundsSize.width / cropRect.size.width, boundsSize.height / cropRect.size.height);
    } else {
        if (contentMode == UIViewContentModeScaleAspectFill)
            scaledSizeForDestination = _sizeFillWithAspectRatio(sourceImageAspectRatio, scaledSizeForDestination);
        else if (contentMode == UIViewContentModeScaleAspectFit)
            scaledSizeForDestination = _sizeFitWithAspectRatio(sourceImageAspectRatio, scaledSizeForDestination);
    }
    
    CGRect drawRect = CGRectZero;
    if (cropToRectDimensions) {
        drawRect = CGRectMake(-cropRect.origin.x * scaledSizeForDestination.width,
                              -cropRect.origin.y * scaledSizeForDestination.height,
                              scaledSizeForDestination.width,
                              scaledSizeForDestination.height);
    } else {
        if (contentMode == UIViewContentModeScaleAspectFill) {
            drawRect = CGRectMake(((destinationWidth - scaledSizeForDestination.width) * cropRect.origin.x),
                                  ((destinationHeight - scaledSizeForDestination.height) * cropRect.origin.y),
                                  scaledSizeForDestination.width,
                                  scaledSizeForDestination.height);
            
        } else {
            drawRect = CGRectMake(((destinationWidth - scaledSizeForDestination.width) / 2.0),
                                  ((destinationHeight - scaledSizeForDestination.height) / 2.0),
                                  scaledSizeForDestination.width,
                                  scaledSizeForDestination.height);
        }
    }
    *outDrawRect = drawRect;
    *outBackingSize = CGSizeMake(destinationWidth, destinationHeight);
}

static CGSize _sizeFillWithAspectRatio(CGFloat sizeToScaleAspectRatio, CGSize destinationSize) {
    CGFloat destinationAspectRatio = destinationSize.width / destinationSize.height;
    if (sizeToScaleAspectRatio > destinationAspectRatio) {
        return CGSizeMake(destinationSize.height * sizeToScaleAspectRatio, destinationSize.height);
    } else {
        return CGSizeMake(destinationSize.width, floorf(destinationSize.width / sizeToScaleAspectRatio));
    }
}

static CGSize _sizeFitWithAspectRatio(CGFloat aspectRatio, CGSize constraints) {
    CGFloat constraintAspectRatio = constraints.width / constraints.height;
    if (aspectRatio > constraintAspectRatio) {
        return CGSizeMake(constraints.width, constraints.width / aspectRatio);
    } else {
        return CGSizeMake(constraints.height * aspectRatio, constraints.height);
    }
}

