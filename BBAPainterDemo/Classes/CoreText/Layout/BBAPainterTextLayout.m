//
//  BBAPainterTextLayout.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/28.
//

#import "BBAPainterTextLayout.h"
#import "BBAPainterFontMetrics.h"

@interface BBAPainterTextLayout () {
    struct {
        unsigned int needsLayout : 1;
    } _flags;
}

@end

@implementation BBAPainterTextLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _flags.needsLayout = YES;
        _heightSensitiveLayout = YES;
        
    }
    return self;
}

@end
