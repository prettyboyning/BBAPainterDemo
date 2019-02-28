//
//  BBAPainterCanvasDrawView.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/2/25.
//

#import "BBAPainterCanvasDrawView.h"

NSString * const BBACanvasViewCornerRadiusKey      = @"painter-graver-canvas-cornerradius-key";
NSString * const BBACanvasViewBorderWidthKey       = @"painter-graver-canvas-borderwidth-key";
NSString * const BBACanvasViewBorderColorKey       = @"painter-graver-canvas-bordercolor-key";

NSString * const BBACanvasViewShadowColorKey       = @"painter-graver-canvas-shadowcolor-key";
NSString * const BBACanvasViewShadowOffsetKey      = @"painter-graver-canvas-shadowoffset-key";
NSString * const BBACanvasViewShadowBlurKey        = @"painter-graver-canvas-shadowblur-key";

NSString * const BBACanvasViewBackgroundColorKey   = @"painter-graver-canvas-backgroundcolor-key";
NSString * const BBACanvasViewBackgroundImageKey   = @"painter-graver-canvas-backgroundimage-key";

@interface BBAPainterCanvasDrawView ()
@property (nonatomic, strong) UIColor *fillColor;
@end

@implementation BBAPainterCanvasDrawView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.drawingPolicy = BBAPainterViewDrawingPolicyAsyncDrawWhenContentsChanged;
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
        
        _cornerRadius = 0.0;
        _borderWidth = 0.0;
        _borderColor = nil;
        
        _shadowColor = nil;
        _shadowOffset = UIOffsetZero;
        _shadowBlur = 0.0;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (_fillColor != backgroundColor) {
        _fillColor = backgroundColor;
        self.contentsChangedAfterLastAsyncDrawing = YES;
        [self setNeedsDisplay];
    }
}

- (UIColor *)backgroundColor {
    return _fillColor;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        
        self.contentsChangedAfterLastAsyncDrawing = YES;
        [self setNeedsDisplay];
    }
}

- (NSDictionary *)currentDrawingUserInfo {
    NSDictionary *dic = [super currentDrawingUserInfo];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (dic) {
        [userInfo addEntriesFromDictionary:dic];
    }
    
    if (self.borderWidth > 0.0) {
        [userInfo setValue:@(self.borderWidth) forKey:BBACanvasViewBorderWidthKey];
    }
    
    if (self.cornerRadius >= 0.0) {
        [userInfo setValue:@(self.cornerRadius) forKey:BBACanvasViewCornerRadiusKey];
    }
    
    if (self.borderColor) {
        [userInfo setValue:self.borderColor forKey:BBACanvasViewBorderColorKey];
    }
    
    if (self.shadowColor) {
        [userInfo setValue:self.shadowColor forKey:BBACanvasViewShadowColorKey];
    }
    
    if (!UIOffsetEqualToOffset(self.shadowOffset, UIOffsetZero)) {
        [userInfo setValue:[NSValue valueWithUIOffset:self.shadowOffset] forKey:BBACanvasViewShadowOffsetKey];
    }
    
    if (self.shadowBlur > 0.0) {
        [userInfo setValue:@(self.shadowBlur) forKey:BBACanvasViewShadowBlurKey];
    }
    
    if (self.fillColor) {
        [userInfo setValue:self.fillColor forKey:BBACanvasViewBackgroundColorKey];
    }
    
    if (self.backgroundImage) {
        [userInfo setValue:self.backgroundImage forKey:BBACanvasViewBackgroundImageKey];
    }
    
    return userInfo;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo {
    [super drawInRect:rect withContext:context asynchronously:asynchronously userInfo:userInfo];
    
    UIColor *backgroundColor = (UIColor *)[userInfo valueForKey:BBACanvasViewBackgroundColorKey];
    
    CGFloat borderWidth = [[userInfo valueForKey:BBACanvasViewBorderWidthKey] floatValue];
    CGFloat cornerRadius = [[userInfo valueForKey:BBACanvasViewCornerRadiusKey] floatValue];
    UIColor *borderColor = (UIColor *)[userInfo valueForKey:BBACanvasViewBorderColorKey];
    
    borderWidth *= [[UIScreen mainScreen] scale];
    
    if (cornerRadius == 0) {
        
        if (backgroundColor && backgroundColor != [UIColor clearColor]) {
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextFillRect(context, rect);
        }
        
        if(borderWidth > 0){
            CGContextAddPath(context, [UIBezierPath bezierPathWithRect:rect].CGPath);
        }
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        
        if(borderWidth > 0)  {
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, borderWidth);
            CGContextDrawPath(context, kCGPathFillStroke);
        } else {
            CGContextDrawPath(context, kCGPathFill);
        }
    } else {
        
        CGRect targetRect = CGRectMake(0, 0, rect.size.width , rect.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:targetRect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        [path setUsesEvenOddFillRule:YES];
        [path addClip];
        CGContextAddPath(context, path.CGPath);
        
        if (backgroundColor && backgroundColor != [UIColor clearColor]) {
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextFillRect(context, rect);
            CGContextAddPath(context, path.CGPath);
        }
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        
        if (borderWidth > 0) {
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, borderWidth);
            CGContextDrawPath(context, kCGPathFillStroke);
        } else {
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    
    // 阴影设置
    UIColor *shadowColor = (UIColor *)[userInfo valueForKey:BBACanvasViewShadowColorKey];
    CGFloat shadowBlur = [[userInfo valueForKey:BBACanvasViewShadowBlurKey] floatValue];
    UIOffset shadowOffset = [[userInfo valueForKey:BBACanvasViewShadowOffsetKey] UIOffsetValue];
    
    if (shadowColor) {
        CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.horizontal, shadowOffset.vertical), shadowBlur, shadowColor.CGColor);
    }
    
    UIGraphicsPushContext(context);
    UIImage *image = [userInfo valueForKey:BBACanvasViewBackgroundImageKey];
    [image drawInRect:rect];
    UIGraphicsPopContext();
    
    return YES;
}




@end
