//
//  BBAPainterAsyncDrawView.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/25.
//

#import "BBAPainterAsyncDrawView.h"

@interface BBAPainterAsyncDrawView ()

@property (nonatomic, weak) BBAPainterAsyncDrawLayer *drawingLayer;

@end

@implementation BBAPainterAsyncDrawView

static BOOL _globalAsyncDrawDisabled = NO;

#pragma mark - life cycle

+ (void)initialize {
    [super initialize];
    _globalAsyncDrawDisabled = NO;
}

- (void)dealloc {
    if (_dispatchDrawQueue) {
        _dispatchDrawQueue = NULL;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
        self.dispatchPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        self.drawingPolicy = BBAPainterViewDrawingPolicyAsyncDrawWhenContentsChanged;
        self.drawingPolicy = self.drawingPolicy;
        self.fadeDuration = self.fadeDuration;
        self.contentsChangedAfterLastAsyncDrawing = self.contentsChangedAfterLastAsyncDrawing;
        self.reserveContentsBeforeNextDrawingComplete = self.reserveContentsBeforeNextDrawingComplete;
        
        if ([self.layer isKindOfClass:[BBAPainterAsyncDrawLayer class]]) {
            _drawingLayer = (BBAPainterAsyncDrawLayer *)self.layer;
        }
    }
    return self;
}

#pragma mark - Override From UIView

+ (Class)layerClass {
    return [BBAPainterAsyncDrawLayer class];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    // 没有 Window 说明View已经没有显示在界面上，此时应该终止绘制
    if (!self.window) {
        [self interruptDrawingWhenPossible];
    } else if (!self.layer.contents){
        [self setNeedsDisplay];
    }
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect {
    [self drawingWillStartAsynchronously:NO];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        NSLog(@"may be memory warning");
    }
    
    [self drawInRect:self.bounds withContext:context asynchronously:NO userInfo:[self currentDrawingUserInfo]];
    [self drawingDidFinishAsynchronously:NO success:YES];
}

- (void)setNeedsDisplay {
    [self.layer setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
    [self.layer setNeedsDisplayInRect:rect];
}

- (void)displayLayer:(CALayer *)layer {
    if (!layer) return;
    
    NSAssert([layer isKindOfClass:[BBAPainterAsyncDrawLayer class]], @"WMGAsyncDrawingView can only display BBAPainterAsyncDrawLayer");
    
    if (layer != self.layer) return;
    
    [self _displayLayer:(BBAPainterAsyncDrawLayer *)layer rect:self.bounds drawingStarted:^(BOOL drawInBackground) {
        [self drawingWillStartAsynchronously:drawInBackground];
    } drawingFinished:^(BOOL drawInBackground) {
        [self drawingDidFinishAsynchronously:drawInBackground success:YES];
    } drawingInterrupted:^(BOOL drawInBackground) {
        [self drawingDidFinishAsynchronously:drawInBackground success:NO];
    }];
}

- (void)_displayLayer:(BBAPainterAsyncDrawLayer *)layer
                 rect:(CGRect)rectToDraw
       drawingStarted:(BBAPainterAsyncDrawCallback)startCallback
      drawingFinished:(BBAPainterAsyncDrawCallback)finishCallback
   drawingInterrupted:(BBAPainterAsyncDrawCallback)interruptCallback {
    BOOL drawInBackground = layer.isAsyncDrawsCurrentContent && ![[self class] globalAsyncDrawingDisabled];
    
    [layer increaseDrawingCount];
    
    NSUInteger targetDrawingCount = layer.drawingCount;
    
    NSDictionary *drawingUserInfo = [self currentDrawingUserInfo];
    
    void (^drawBlock)(void) = ^{
        
        void (^failedBlock)(void) = ^{
            if (interruptCallback) {
                interruptCallback(drawInBackground);
            }
        };
        
        if (layer.drawingCount != targetDrawingCount) {
            failedBlock();
            return;
        }
        
        CGSize contextSize = layer.bounds.size;
        BOOL contextSizeValid = contextSize.width >= 1 && contextSize.height >= 1;
        CGContextRef context = NULL;
        BOOL drawingFinished = YES;
        
        if (contextSizeValid) {
            UIGraphicsBeginImageContextWithOptions(contextSize, layer.isOpaque, layer.contentsScale);
            
            context = UIGraphicsGetCurrentContext();
            
            if (!context) {
                NSLog(@"may be memory warning");
            }
            
            CGContextSaveGState(context);
            
            if (rectToDraw.origin.x || rectToDraw.origin.y) {
                CGContextTranslateCTM(context, rectToDraw.origin.x, -rectToDraw.origin.y);
            }
            
            if (layer.drawingCount != targetDrawingCount) {
                drawingFinished = NO;
            } else {
                drawingFinished = [self drawInRect:rectToDraw withContext:context asynchronously:drawInBackground userInfo:drawingUserInfo];
            }
            
            CGContextRestoreGState(context);
        }
        
        // 所有耗时的操作都已完成，但仅在绘制过程中未发生重绘时，将结果显示出来
        if (drawingFinished && targetDrawingCount == layer.drawingCount)
        {
            CGImageRef CGImage = context ? CGBitmapContextCreateImage(context) : NULL;
            
            {
                // 让 UIImage 进行内存管理
                UIImage *image = CGImage ? [UIImage imageWithCGImage:CGImage] : nil;
                
                void (^finishBlock)(void) = ^{
                    
                    // 由于block可能在下一runloop执行，再进行一次检查
                    if (targetDrawingCount != layer.drawingCount)
                    {
                        failedBlock();
                        return;
                    }
                    
                    layer.contents = (id)image.CGImage;
                    
                    [layer setContentsChangedAfterLastAsyncDrawing:NO];
                    [layer setReserveContentsBeforeNextDrawingComplete:NO];
                    if (finishCallback)
                    {
                        finishCallback(drawInBackground);
                    }
                    
                    // 如果当前是异步绘制，且设置了有效fadeDuration，则执行动画
                    if (drawInBackground && layer.fadeDuration > 0.0001)
                    {
                        layer.opacity = 0.0;
                        
                        [UIView animateWithDuration:layer.fadeDuration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            layer.opacity = 1.0;
                        } completion:NULL];
                    }
                };
                
                if (drawInBackground)
                {
                    dispatch_async(dispatch_get_main_queue(), finishBlock);
                }
                else
                {
                    finishBlock();
                }
            }
            
            if (CGImage) {
                CGImageRelease(CGImage);
            }
        }
        else
        {
            failedBlock();
        }
        
        UIGraphicsEndImageContext();
    };
    
    if (startCallback)
    {
        startCallback(drawInBackground);
    }
    
    if (drawInBackground)
    {
        // 清空 layer 的显示
        if (!layer.reserveContentsBeforeNextDrawingComplete)
        {
            layer.contents = nil;
        }
        
        dispatch_async([self drawQueue], drawBlock);
    }
    else
    {
        void (^block)(void) = ^{
            @autoreleasepool {
                drawBlock();
            }
        };
        
        if ([NSThread isMainThread])
        {
            // 已经在主线程，直接执行绘制
            block();
        }
        else
        {
            // 不应当在其他线程，转到主线程绘制
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (!self.alwaysUsesOffscreenRendering) {
        // 此方法在 -[super initWithFrame:frame] 时检查，因此必须通过重写保证此时的drawingPolicy已设置正确
        if ([NSStringFromSelector(aSelector) isEqual:@"displayLayer:"]) {
            return self.drawingPolicy != BBAPainterViewDrawingPolicySyncDraw;
        }
    }
    return [super respondsToSelector:aSelector];
}

#pragma mark - public

- (void)setNeedsDisplayAsync {
    self.contentsChangedAfterLastAsyncDrawing = YES;
    [self setNeedsDisplay];
}

- (void)redraw {
    [self displayLayer:self.layer];
}

- (BOOL)alwaysUsesOffscreenRendering {
    return YES;
}

#pragma mark - private

- (void)interruptDrawingWhenPossible {
    [_drawingLayer increaseDrawingCount];
}

- (dispatch_queue_t)drawQueue {
    if (self.dispatchDrawQueue) {
        return self.dispatchDrawQueue;
    }
    return dispatch_get_global_queue(self.dispatchPriority, 0);
}

#pragma mark - Methods for subclass overriding

- (NSDictionary *)currentDrawingUserInfo {
    return nil;
}

- (void)drawingWillStartAsynchronously:(BOOL)asynchronously {
    
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously {
    return YES;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo {
    return [self drawInRect:rect withContext:context asynchronously:asynchronously];
}

- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success {
    
}

#pragma mark - getter and setter

+ (BOOL)globalAsyncDrawingDisabled {
    return _globalAsyncDrawDisabled;
}

+ (void)setGlobalAsyncDrawingDisable:(BOOL)disable {
    _globalAsyncDrawDisabled = disable;
}

- (void)setDrawingPolicy:(BBAPainterViewDrawingPolicy)drawingPolicy {
    _drawingLayer.drawingPolicy = drawingPolicy;
}

- (BBAPainterViewDrawingPolicy)drawingPolicy {
    return _drawingLayer.drawingPolicy;
}

- (void)setFadeDuration:(NSTimeInterval)fadeDuration {
    _drawingLayer.fadeDuration = fadeDuration;
}

- (NSTimeInterval)fadeDuration {
    return _drawingLayer.fadeDuration;
}

- (BOOL)contentsChangedAfterLastAsyncDrawing {
    return _drawingLayer.contentsChangedAfterLastAsyncDrawing;
}

- (void)setContentsChangedAfterLastAsyncDrawing:(BOOL)contentsChangedAfterLastAsyncDrawing {
    _drawingLayer.contentsChangedAfterLastAsyncDrawing = contentsChangedAfterLastAsyncDrawing;
}

- (BOOL)reserveContentsBeforeNextDrawingComplete {
    return _drawingLayer.reserveContentsBeforeNextDrawingComplete;
}

- (void)setReserveContentsBeforeNextDrawingComplete:(BOOL)reserveContentsBeforeNextDrawingComplete {
    _drawingLayer.reserveContentsBeforeNextDrawingComplete = reserveContentsBeforeNextDrawingComplete;
}

- (NSUInteger)drawingCount {
    return _drawingLayer.drawingCount;
}

- (void)setDispatchDrawQueue:(dispatch_queue_t)dispatchDrawQueue {
    if (_dispatchDrawQueue) {
        _dispatchDrawQueue = NULL;
    }
    _dispatchDrawQueue = dispatchDrawQueue;
}



@end
