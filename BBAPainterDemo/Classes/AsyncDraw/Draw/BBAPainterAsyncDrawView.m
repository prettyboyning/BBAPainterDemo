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

#pragma mark - getter and setter

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
