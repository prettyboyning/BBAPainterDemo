//
//  NSMutableAttributedString+GTextProperty.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/24.
//

#import "NSMutableAttributedString+GTextProperty.h"

static NSString * const kBBATextDefaultForegroundColorAttributeName = @"kBBATextDefaultForegroundColorAttributeName";

@implementation NSMutableAttributedString (GTextProperty)

- (void)bba_setFont:(UIFont *)font {
    [self bba_setFont:font inRange:[self bba_stringRange]];
}

- (void)bba_setFont:(UIFont *)font inRange:(NSRange)range {
    range = [self bba_effectiveRangeWithRange:range];
    
    if (!font) {
        [self removeAttribute:(NSString *)kCTFontAttributeName range:range];
    } else {
        [self addAttribute:(NSString *)kCTFontAttributeName value:font range:range];
    }
}

- (void)bba_setColor:(UIColor *)color {
    [self bba_setColor:color inRange:[self bba_stringRange]];
}

- (void)bba_setColor:(UIColor *)color inRange:(NSRange)range {
    range = [self bba_effectiveRangeWithRange:range];
    
    if (!color) {
        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
    } else {
        CGColorRef cg_color = [color CGColor];
        
        if (cg_color) {
            [self addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)cg_color range:range];
            
            if (NSEqualRanges(range, [self bba_stringRange])) {
                [self addAttribute:kBBATextDefaultForegroundColorAttributeName value:(__bridge id)cg_color range:range];
            }
        }
    }
}


#pragma mark - private

- (NSRange)bba_stringRange {
    return NSMakeRange(0, [self length]);
}

- (NSRange)bba_effectiveRangeWithRange:(NSRange)range {
    NSInteger stringLength = self.length;
    
    if (range.location == NSNotFound ||
        range.location > stringLength) {
        range.location = 0;
    }
    
    if (range.location + range.length > stringLength) {
        range.length = stringLength - range.location;
    }
    
    return range;
}

@end
