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
#import "BBAPainterFlag.h"
#import "BBAPainterImageView.h"

@interface BBAPainterAsyncView ()

/// 缓存之前的BBAPainterImageView
@property (nonatomic, strong) NSMutableArray *reusePool;
/// 存放正在使用的BBAPainterImageView
@property (nonatomic, strong) NSMutableArray *imageContainers;
/// 一个自增的标识类，用于取消绘制
@property (nonatomic, strong) BBAPainterFlag *displayFlag;

@end

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
    self.layer.opaque = YES;
    self.displaysAsynchronously = YES;
    _displayFlag = [[BBAPainterFlag alloc] init];
}

#pragma mark - Getter & Setter

- (void)setLayout:(id<painterLayoutProtocol>)layout {
    if ([_layout isEqual:layout]) {
        return;
    }
    // 清除imageView 缓存
    [self cleanImageContainersAddReusePool];
    [self cleanupAndReleaseModelOnSubThread];
    
    [self.layer setNeedsDisplay];
}

- (void)cleanImageContainersAddReusePool {
    [self.displayFlag increment];
    
    for (int i = 0; i < self.imageContainers.count; i++) {
        BBAPainterImageView *imageView = self.imageContainers[i];
        imageView.image = nil;
        imageView.gifImage = nil;
        imageView.hidden = YES;
        [self.reusePool addObject:imageView];
    }
    [self.imageContainers removeAllObjects];
}

- (void)cleanupAndReleaseModelOnSubThread {
    
    id <painterLayoutProtocol> oldLayout = _layout;
    _layout = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [oldLayout class];
    });
}

+ (Class)layerClass {
    return [BBAPainterAsyncLayer class];
}

- (void)setDisplaysAsynchronously:(BOOL)displaysAsynchronously {
    if (_displaysAsynchronously != displaysAsynchronously) {
        _displaysAsynchronously = displaysAsynchronously;
        [(BBAPainterAsyncLayer *)self.layer setDisplayAsynchronously:_displaysAsynchronously];
    }
}

- (NSMutableArray *)reusePool {
    if (!_reusePool) {
        _reusePool = [NSMutableArray array];
    }
    return _reusePool;
}

- (NSMutableArray *)imageContainers {
    if (!_imageContainers) {
        _imageContainers = [NSMutableArray array];
    }
    return _imageContainers;
}

@end
