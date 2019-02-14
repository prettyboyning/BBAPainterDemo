//
//  BBAPainterFontMetrics.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/28.
//

#import "BBAPainterFontMetrics.h"

const BBAFontMetrics BBAFontMetricsZero = {0, 0, 0};
const BBAFontMetrics BBAFontMetricsNull = {NSNotFound, NSNotFound, NSNotFound};

static BBAFontMetrics WMGCachedFontMetrics[13];

BBAFontMetrics WMGFontDefaultMetrics(NSInteger pointSize)
{
    if (pointSize < 8 || pointSize > 20)
    {
        UIFont *font = [UIFont systemFontOfSize:pointSize];
        return BBAFontMetricsMakeFromUIFont(font);
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            for (NSInteger i = 0; i < 13; i++) {
                NSUInteger pointSize = i + 8;
                UIFont * font = [UIFont systemFontOfSize:pointSize];
                WMGCachedFontMetrics[i] = BBAFontMetricsMakeFromUIFont(font);
            }
        }
    });
    
    return WMGCachedFontMetrics[pointSize - 8];
}
