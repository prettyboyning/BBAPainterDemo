//
//  SDImageCache+Painter.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/1.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "SDImageCache+Painter.h"
#import "BBAPainterImageProcessor.h"
#import "BBAPainterDefine.h"
#import <objc/runtime.h>

@implementation SDImageCache (Painter)

+ (void)load {
    [super load];
    Method originMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"storeImage:imageData:forKey:toDisk:completion:"));
    Method newMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"painter_storeImage:imageData:forKey:toDisk:completion:"));
    if (!class_addMethod([self class], @selector(painter_storeImage:imageData:forKey:toDisk:completion:), method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        method_exchangeImplementations(newMethod, originMethod);
    }
}

- (void)painter_storeImage:(nullable UIImage *)image
                 imageData:(nullable NSData *)imageData
                    forKey:(nullable NSString *)key
                    toDisk:(BOOL)toDisk
                completion:(nullable SDWebImageNoParamsBlock)completionBlock {
    
    //根据从key中取出相关绘制信息，处理图片，然后将处理完的图片缓存
    image = [BBAPainterImageProcessor painter_cornerRadiusImageWithImage:image withKey:key];
    if (key && [key hasPrefix:[NSString stringWithFormat:@"%@",kBBAPainterImageProcessorPrefixKey]]) {
        if (image) {
            imageData = UIImagePNGRepresentation(image);
        }
    }
    [self painter_storeImage:image imageData:imageData forKey:key toDisk:toDisk completion:completionBlock];
}


@end
