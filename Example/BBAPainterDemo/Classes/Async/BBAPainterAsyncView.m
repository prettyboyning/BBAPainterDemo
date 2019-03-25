//
//  BBAPainterAsyncView.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterAsyncView.h"
#import "BBAPainterAsyncLayer.h"
#import "BBAPainterUtils.h"

@implementation BBAPainterAsyncView

#pragma mark - LifeCycle

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.contentsScale = [BBAPainterUtils contentsScale];
//    [self addGestureRecognizer:self.longPressGesture];
    self.layer.opaque = YES;
    self.displaysAsynchronously = YES;
    
//    _showingHighlight = NO;
//    _highlight = nil;
//    _touchBeganPoint = CGPointZero;
//    _highlightAdjustPoint = CGPointZero;
//    _displayFlag = [[LWFlag alloc] init];
}

#pragma mark - Getter & Setter

+ (Class)layerClass {
    return [BBAPainterAsyncLayer class];
}

- (void)setDisplaysAsynchronously:(BOOL)displaysAsynchronously {
    if (_displaysAsynchronously != displaysAsynchronously) {
        _displaysAsynchronously = displaysAsynchronously;
        [(BBAPainterAsyncLayer *)self.layer setDisplayAsynchronously:_displaysAsynchronously];
    }
}

@end
