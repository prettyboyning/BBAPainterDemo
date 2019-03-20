//
//  BBAPainterImageView.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterImageView.h"

@implementation BBAPainterImageView

#pragma mark - Init

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithImage:image highlightedImage:highlightedImage];
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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    self.animationRunLoopMode = [self defaultAnimatitonRunLoopMode];
    self.displayAsynchronously = YES;
    self.displayTransactionGroup = YES;
}


#pragma mark - UIView LifeCycle

//- (void)didMoveToSuperview {
//    [super didMoveToSuperview];
//    [self animateIfNeed];
//}
//
//
//- (void)didMoveToWindow {
//    [super didMoveToWindow];
//    [self animateIfNeed];
//}
//
//- (void)dealloc {
//    if (self.displayLink) {
//        [self.displayLink invalidate];
//        self.displayLink = nil;
//    }
//}

- (NSString *)defaultAnimatitonRunLoopMode {
    return NSRunLoopCommonModes;
}

@end
