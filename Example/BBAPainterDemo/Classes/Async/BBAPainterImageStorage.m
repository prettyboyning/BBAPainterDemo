//
//  BBAPainterImageStorage.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/26.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterImageStorage.h"
#import "BBAPainterUtils.h"
#import "UIImage+BBAGallop.h"

@interface BBAPainterImageStorage()

@property (nonatomic, assign) BOOL needRerendering;

@end

@implementation BBAPainterImageStorage

@synthesize cornerRadius = _cornerRadius;
@synthesize cornerBorderWidth = _cornerBorderWidth;


#pragma mark - Override Hash & isEqual


- (BOOL)isEqual:(id)object {
    if (!object || ![object isMemberOfClass:[BBAPainterImageStorage class]]) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    
    BBAPainterImageStorage* imageStorage = (BBAPainterImageStorage *)object;
    return [imageStorage.contents isEqual:self.contents] && CGRectEqualToRect(imageStorage.frame, self.frame);
}


- (NSUInteger)hash {
    long v1 = (long)self.contents;
    long v2 = (long)[NSValue valueWithCGRect:self.frame];
    return v1 ^ v2;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.contents forKey:@"contents"];
    [aCoder encodeInteger:self.localImageType forKey:@"localImageType"];
    [aCoder encodeObject:self.placeholder forKey:@"placeholder"];
    [aCoder encodeBool:self.fadeShow forKey:@"fadeShow"];
    [aCoder encodeBool:self.userInteractionEnabled forKey:@"userInteractionEnabled"];
    [aCoder encodeBool:self.needRerendering forKey:@"needRerendering"];
    [aCoder encodeBool:self.needResize forKey:@"needResize"];
    [aCoder encodeBool:self.isBlur forKey:@"isBlur"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contents = [aDecoder decodeObjectForKey:@"contents"];
        self.placeholder = [aDecoder decodeObjectForKey:@"placeholder"];
        self.localImageType = [aDecoder decodeIntegerForKey:@"localImageType"];
        self.fadeShow = [aDecoder decodeBoolForKey:@"fadeShow"];
        self.userInteractionEnabled = [aDecoder decodeBoolForKey:@"userInteractionEnabled"];
        self.needResize = [aDecoder decodeBoolForKey:@"needResize"];
        self.needRerendering = [aDecoder decodeBoolForKey:@"needRerendering"];
        self.isBlur = [aDecoder decodeBoolForKey:@"isBlur"];
    }
    return self;
}

#pragma mark - LifeCycle

- (id)init {
    self = [super init];
    if (self) {
        self.contents = nil;
        self.userInteractionEnabled = YES;
        self.placeholder = nil;
        self.fadeShow = YES;
        self.clipsToBounds = NO;
        self.contentsScale = [BBAPainterUtils contentsScale];
        self.needRerendering = NO;
        self.needResize = NO;
        self.localImageType = PainterLocalImageDrawInLWAsyncDisplayView;
        self.isBlur = NO;
    }
    return self;
}

- (BOOL)needRerendering {
    //这个图片设置了圆角的相关属性，需要对原图进行处理
    if (self.cornerBorderWidth != 0 || self.cornerRadius != 0) {
        return YES;
    } else {
        return _needRerendering;
    }
}

#pragma mark - Methods

- (void)stretchableImageWithLeftCapWidth:(CGFloat)leftCapWidth topCapHeight:(NSInteger)topCapHeight {
    
    if ([self.contents isKindOfClass:[UIImage class]] &&
        self.localImageType == PainterLocalImageDrawInLWAsyncDisplayView) {
        self.contents = [(UIImage *)self.contents
                         stretchableImageWithLeftCapWidth:leftCapWidth
                         topCapHeight:topCapHeight];
    }
}

- (void)painter_drawInContext:(CGContextRef)context isCancelled:(painterAsyncDisplayIsCancelledBlock)isCancelld {
    
    if (isCancelld()) {
        return;
    }
    
    if ([self.contents isKindOfClass:[NSURL class]]) {
        return;
    }
    
    if ([self.contents isKindOfClass:[UIImage class]] &&
        self.localImageType == PainterLocalImageDrawInLWAsyncDisplayView) {
        
        UIImage* image = (UIImage *)self.contents;
        BOOL isOpaque = self.opaque;
        UIColor* backgroundColor = self.backgroundColor;
        CGFloat cornerRaiuds = self.cornerRadius;
        UIColor* cornerBackgroundColor = self.cornerBackgroundColor;
        UIColor* cornerBorderColor = self.cornerBorderColor;
        CGFloat cornerBorderWidth = self.cornerBorderWidth;
        CGRect rect = self.frame;
        rect = CGRectStandardize(rect);
        
        CGRect imgRect = {
            {rect.origin.x + cornerBorderWidth,rect.origin.y + cornerBorderWidth},
            {rect.size.width - 2 * cornerBorderWidth,rect.size.height - 2 * cornerBorderWidth}
        };
        
        if (!image) {
            return;
        }
        
        if (self.isBlur) {
            image = [image painter_applyBlurWithRadius:20.0
                                        tintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]
                            saturationDeltaFactor:1.4
                                        maskImage:nil];
        }
        
        CGContextSaveGState(context);
        if (isOpaque && backgroundColor) {
            [backgroundColor setFill];
            UIRectFill(imgRect);
        }
        
        UIBezierPath* backgroundRect = [UIBezierPath bezierPathWithRect:imgRect];
        UIBezierPath* cornerPath = [UIBezierPath bezierPathWithRoundedRect:imgRect
                                                              cornerRadius:cornerRaiuds];
        
        if (cornerBackgroundColor) {
            [cornerBackgroundColor setFill];
            [backgroundRect fill];
        }
        [cornerPath addClip];
        
        [image painter_drawInRect:imgRect
                 contentMode:self.contentMode
               clipsToBounds:YES];
        
        CGContextRestoreGState(context);
        if (cornerBorderColor && cornerBorderWidth != 0) {
            [cornerPath setLineWidth:cornerBorderWidth];
            [cornerBorderColor setStroke];
            [cornerPath stroke];
        }
        
        
    }
}

@end
