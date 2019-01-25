//
//  BBAPainterAsyncDrawLayer.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/25.
//

#import "BBAPainterAsyncDrawLayer.h"

@implementation BBAPainterAsyncDrawLayer

- (void)increaseDrawingCount {
    _drawingCount = (_drawingCount + 1) % 10000;
}

- (void)setNeedsDisplay {
    [self increaseDrawingCount];
    [super setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)r {
    [self increaseDrawingCount];
    [super setNeedsDisplayInRect:r];
}

- (BOOL)isAsyncDrawsCurrentContent {
    switch (_drawingPolicy) {
        case BBAPainterViewDrawingPolicyAsyncDrawWhenContentsChanged:
            return _contentsChangedAfterLastAsyncDrawing;
        case BBAPainterViewDrawingPolicyAsyncDraw:
            return YES;
        case BBAPainterViewDrawingPolicySyncDraw:
            return NO;
        default:
            return NO;
    }
}

@end
