//
//  BBAPainterFontMetrics.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

struct BBAFontMetrics {
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
};

typedef struct BBAFontMetrics BBAFontMetrics;

static inline BBAFontMetrics BBAFontMetricsMake(CGFloat a, CGFloat d, CGFloat l)
{
    BBAFontMetrics metrics;
    metrics.ascent = a;
    metrics.descent = d;
    metrics.leading = l;
    return metrics;
}

extern const BBAFontMetrics BBAFontMetricsZero;
extern const BBAFontMetrics BBAFontMetricsNull;

static inline BBAFontMetrics BBAFontMetricsMakeFromUIFont(UIFont * font)
{
    if (!font) {
        return BBAFontMetricsNull;
    }
    
    BBAFontMetrics metrics;
    metrics.ascent = ABS(font.ascender);
    metrics.descent = ABS(font.descender);
    metrics.leading = ABS(font.lineHeight) - metrics.ascent - metrics.descent;
    return metrics;
}

static inline BBAFontMetrics BBAFontMetricsMakeFromCTFont(CTFontRef font)
{
    return BBAFontMetricsMake(ABS(CTFontGetAscent(font)), ABS(CTFontGetDescent(font)), ABS(CTFontGetLeading(font)));
}

static inline BBAFontMetrics BBAFontMetricsMakeWithTargetLineHeight(BBAFontMetrics metrics, CGFloat targetLineHeight)
{
    return BBAFontMetricsMake(targetLineHeight - metrics.descent - metrics.leading, metrics.descent, metrics.leading);
}

static inline CGFloat BBAFontMetricsGetLineHeight(BBAFontMetrics metrics)
{
    return ceil(metrics.ascent + metrics.descent + metrics.leading);
}

static inline BOOL BBAFontMetricsEqual(BBAFontMetrics m1, BBAFontMetrics m2)
{
    return m1.ascent == m2.ascent && m1.descent == m2.descent && m1.leading == m2.leading;
}

static inline NSInteger BBAFontMetricsHash(BBAFontMetrics metrics)
{
    CGRect concrete = CGRectMake(metrics.ascent, metrics.descent, metrics.leading, 0);
    return [NSStringFromCGRect(concrete) hash];
}

extern BBAFontMetrics WMGFontDefaultMetrics(NSInteger pointSize);
