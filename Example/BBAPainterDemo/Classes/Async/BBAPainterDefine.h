//
//  BBAPainterDefine.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/3/27.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#ifndef BBAPainterDefine_h
#define BBAPainterDefine_h

#import <libkern/OSAtomic.h>

@class BBAPainterImageStorage;

//通过RGB返回UIColor
#ifndef RGB
#define RGB(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#endif

static const NSString* kBBAPainterImageProcessorPrefixKey = @"kBBAPainterImageProcessorPrefixKey";


typedef BOOL(^painterAsyncDisplayIsCancelledBlock)(void);
typedef void(^painterLayerDisplayWillDisplayBlock)(CALayer *layer);
typedef void(^painterLayerDisplayBlock)(CGContextRef context, CGSize size, painterAsyncDisplayIsCancelledBlock isCancellBlock);
typedef void(^painterLayerDidDisplayBlock)(CALayer *layer, BOOL finished);
typedef void(^painterImageResizeBlock)(BBAPainterImageStorage *imageStorage, CGFloat delta);
typedef void(^painterAsyncCompleteBlock)(void);
typedef void(^painterWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL);
typedef void(^painterWebImageDownloaderCompletionBlock)(UIImage *image, NSData *imageData, NSError *error);

/// Global display queue, used for content rendering.
static dispatch_queue_t YYTextAsyncLayerGetDisplayQueue() {
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.baidu.layer.render", attr);
            }
        } else {
            for (NSUInteger i = 0; i < queueCount; i++) {
                queues[i] = dispatch_queue_create("com.baidu.layer.render", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    uint32_t cur = (uint32_t)OSAtomicIncrement32(&counter);
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
}

static dispatch_queue_t YYTextAsyncLayerGetReleaseQueue() {
#ifdef YYDispatchQueuePool_h
    return YYDispatchQueueGetForQOS(NSQualityOfServiceDefault);
#else
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
#endif
}

#endif /* BBAPainterDefine_h */
