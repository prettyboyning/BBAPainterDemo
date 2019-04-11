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
#import "BBAPainterImageStorage.h"
#import "BBAPainterDefine.h"

#import "BBAPainterImageView+Display.h"

@interface BBAPainterAsyncView () <BBAPainterAsyncDisplayLayerDelegate>

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

#pragma mark - Private

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


- (void)setImageStoragesResizeBlock:(void(^)(BBAPainterImageStorage *imageStorage, CGFloat delta))ressizeBlock {
    BBAPainterFlag *flag = self.displayFlag;
    int32_t value = flag.value;
    
    painterAsyncDisplayIsCancelledBlock isCancllBlock = ^ BOOL() {
        return value != _displayFlag.value;
    };
    
    for (int i = 0; i < self.layout.imageStorages.count; i++) {
        
        @autoreleasepool {
            if (isCancllBlock()) {
                return;
            }
            
            // 取出imageSorage
            BBAPainterImageStorage *imageStorage = self.layout.imageStorages[i];
            if ([imageStorage.contents isKindOfClass:[UIImage class]]) {
                imageStorage.localImageType = PainterLocalImageDrawInLWAsyncDisplayView;
                continue;
            }
            
            BBAPainterImageView *container = [self dequeueReusableImageContainerWithIdentifier:imageStorage.identifier];
            if (!container) {
                container = [[BBAPainterImageView alloc] init];
                container.identifier = imageStorage.identifier;
                [self addSubview:container];
            }
            container.displayAsynchronously = self.displaysAsynchronously;
            container.backgroundColor = imageStorage.backgroundColor;
            container.clipsToBounds = imageStorage.clipsToBounds;
            container.contentMode = imageStorage.contentMode;
            container.frame = imageStorage.frame;
            container.layer.shadowColor = imageStorage.shadowColor.CGColor;
            container.layer.shadowOffset = imageStorage.shadowOffset;
            container.layer.shadowOpacity = imageStorage.shadowOpacity;
            container.layer.shadowRadius = imageStorage.shadowRadius;
            container.hidden = NO;
            
            [container painterSetImageWihtImageStorage:imageStorage resize:ressizeBlock completion:^{
                
            }];
            [self.imageContainers addObject:container];
            
        }
    }
}


- (BBAPainterImageView *)dequeueReusableImageContainerWithIdentifier:(NSString *)identifier {
    if (self.reusePool.count > 0) {
        for (int i = 0; i < self.reusePool.count; i++) {
            BBAPainterImageView *currentImageView = self.reusePool[i];
            if ([currentImageView.identifier isEqualToString:identifier]) {
                [self.reusePool removeObject:currentImageView];
                return currentImageView;
            }
        }
    }
    return nil;
}

- (void)drawStoragesInContext:(CGContextRef)context cancellBlock:(painterAsyncDisplayIsCancelledBlock)cancellBlock {
    if ([self.delegate respondsToSelector:@selector(extraAsyncDisplayIncontext:size:isCancelled:)]) {
        if (cancellBlock()) {
            return;
        }
        [self.delegate extraAsyncDisplayIncontext:context size:self.bounds.size isCancelled:cancellBlock];
    }
    
    for (BBAPainterImageStorage *imageStorage in self.layout.imageStorages) {
        if (cancellBlock()) {
            return;
        }
        [imageStorage painter_drawInContext:context isCancelled:cancellBlock];
    }
}

#pragma mark - BBAPainterAsyncDisplayLayerDelegate

- (BBAPainterAsyncDisplayTransaction *)asyncDisplayTransaction {
    BBAPainterAsyncDisplayTransaction* transaction = [[BBAPainterAsyncDisplayTransaction alloc] init];
    transaction.willDisplayBlock = ^(CALayer *layer) {
        
//        for (LWTextStorage* textStorage in self.layout.textStorages) {
//            //先移除之前的附件
//            [textStorage.textLayout removeAttachmentFromSuperViewOrLayer];
//        }
    };
    
    transaction.displayBlock = ^(CGContextRef context,
                                 CGSize size,
                                 painterAsyncDisplayIsCancelledBlock cancellBlock) {
        
        [self drawStoragesInContext:context cancellBlock:cancellBlock];
    };
    
    transaction.didDisplayBlock = ^(CALayer *layer, BOOL finished) {
        if (!finished) {
//            for (LWTextStorage* textStorage in self.layout.textStorages) {
//                [textStorage.textLayout removeAttachmentFromSuperViewOrLayer];
//            }
        }
    };
    return transaction;
}

#pragma mark - Getter & Setter

- (void)setLayout:(id<painterLayoutProtocol>)layout {
    if ([_layout isEqual:layout]) {
        return;
    }
    // 清除imageView 缓存
    [self cleanImageContainersAddReusePool];
    [self cleanupAndReleaseModelOnSubThread];
    _layout = layout;
    [self.layer setNeedsDisplay];
    
    [self setImageStoragesResizeBlock:^(BBAPainterImageStorage *imageStorage, CGFloat delta) {
        
    }];
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
