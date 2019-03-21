//
//  BBAPainterUtils.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterUtils.h"

@implementation BBAPainterUtils

+ (CGFloat)contentsScale {
    static dispatch_once_t once;
    static CGFloat contentsScale;
    dispatch_once(&once, ^{
        contentsScale = [UIScreen mainScreen].scale;
    });
    return contentsScale;
}

+ (NSUInteger)greatestCommonDivisorWithNumber:(NSUInteger)a another:(NSUInteger)b {
    if (a < b) {
        return [self greatestCommonDivisorWithNumber:b another:a];
    } else if (a == b) {
        return b;
    }
    while (true) {
        NSUInteger remainder = a % b;
        if (remainder == 0) {
            return b;
        }
        a = b;
        b = remainder;
    }
}

@end
