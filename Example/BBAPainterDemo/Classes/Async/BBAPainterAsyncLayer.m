//
//  BBAPainterAsyncLayer.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterAsyncLayer.h"
#import "BBAPainterFlag.h"
#import "BBAPainterUtils.h"
#import "BBAPainterDefine.h"


@interface BBAPainterAsyncLayer ()

@property (nonatomic, strong) BBAPainterFlag* displayFlag;

@end

@implementation BBAPainterAsyncLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = [BBAPainterUtils contentsScale];
        _displayFlag = [BBAPainterFlag new];
        _displayAsynchronously = YES;
    }
    return self;
}

- (void)dealloc {
    [_displayFlag increment];
}

- (void)setNeedsDisplay {
    [self cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)displayImmediately {
    [_displayFlag increment];
    super.contents = super.contents;
    [self _displayAsync:NO];
}

- (void)display {
    super.contents = super.contents;
    [self _displayAsync:_displayAsynchronously];
}

#pragma mark - Private

- (void)_displayAsync:(BOOL)async {
    __strong id<BBAPainterAsyncDisplayLayerDelegate> delegate = (id)self.delegate;
    BBAPainterAsyncDisplayTransaction *task = [delegate asyncDisplayTransaction];
    if (!task.displayBlock) {
        if (task.willDisplayBlock) task.willDisplayBlock(self);
        self.contents = nil;
        if (task.didDisplayBlock) task.didDisplayBlock(self, YES);
        return;
    }
    
    if (async) {
        if (task.willDisplayBlock) task.willDisplayBlock(self);
        BBAPainterFlag *sentinel = _displayFlag;
        int32_t value = sentinel.value;
        BOOL (^isCancelled)() = ^BOOL() {
            return value != sentinel.value;
        };
        CGSize size = self.bounds.size;
        BOOL opaque = self.opaque;
        CGFloat scale = self.contentsScale;
        CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
        if (size.width < 1 || size.height < 1) {
            CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
            self.contents = nil;
            if (image) {
                dispatch_async(YYTextAsyncLayerGetReleaseQueue(), ^{
                    CFRelease(image);
                });
            }
            if (task.didDisplayBlock) task.didDisplayBlock(self, YES);
            CGColorRelease(backgroundColor);
            return;
        }
        
        dispatch_async(YYTextAsyncLayerGetDisplayQueue(), ^{
            if (isCancelled()) {
                CGColorRelease(backgroundColor);
                return;
            }
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (opaque && context) {
                CGContextSaveGState(context); {
                    if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                        CGContextFillPath(context);
                    }
                    if (backgroundColor) {
                        CGContextSetFillColorWithColor(context, backgroundColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                        CGContextFillPath(context);
                    }
                } CGContextRestoreGState(context);
                CGColorRelease(backgroundColor);
            }
            task.displayBlock(context, size, isCancelled);
            if (isCancelled()) {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplayBlock) task.didDisplayBlock(self, NO);
                });
                return;
            }
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (isCancelled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplayBlock) task.didDisplayBlock(self, NO);
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled()) {
                    if (task.didDisplayBlock) task.didDisplayBlock(self, NO);
                } else {
                    self.contents = (__bridge id)(image.CGImage);
                    if (task.didDisplayBlock) task.didDisplayBlock(self, YES);
                }
            });
        });
    } else {
        [_displayFlag increment];
        if (task.willDisplayBlock) task.willDisplayBlock(self);
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.opaque && context) {
            CGSize size = self.bounds.size;
            size.width *= self.contentsScale;
            size.height *= self.contentsScale;
            CGContextSaveGState(context); {
                if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
                if (self.backgroundColor) {
                    CGContextSetFillColorWithColor(context, self.backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
            } CGContextRestoreGState(context);
        }
        task.displayBlock(context, self.bounds.size, ^{return NO;});
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.contents = (__bridge id)(image.CGImage);
        if (task.didDisplayBlock) task.didDisplayBlock(self, YES);
    }
}

- (void)cancelAsyncDisplay {
    [_displayFlag increment];
}

@end

@implementation BBAPainterAsyncDisplayTransaction


@end
