//
//  BBAPainterRecommendContenrView.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/2/18.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterRecommendContenrView.h"
#import "BBAPainterRecommendCellData.h"
#import <CoreText/CoreText.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BBAPainterRecommendContenrView ()

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation BBAPainterRecommendContenrView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)setRecommendCellData:(BBAPainterRecommendCellData *)recommendCellData {
    if (recommendCellData) {
        _recommendCellData = recommendCellData;
        [self setNeedsDisplayAsync];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_recommendCellData.icon] placeholderImage:[UIImage imageNamed:@"bba_homepage_mnp_defult_logo"]];
    }
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo
{
    [super drawInRect:rect withContext:context asynchronously:asynchronously userInfo:userInfo];
//    [self.textDrawerDatas enumerateObjectsUsingBlock:^(WMGVisionObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        self.textDrawer.frame = obj.frame;
//        self.textDrawer.textLayout.attributedString = obj.value;
//        [self.textDrawer drawInContext:context];
//    }];
    
//    UIGraphicsPushContext(context);
//    UIImage *image = [UIImage imageNamed:(NSString *)att.contents];
//    [image drawInRect:frame];
//    UIGraphicsPopContext();
    CGContextSaveGState(context);
    [_recommendCellData.name drawInRect:CGRectMake(88, 21, 150, 17)];
    
    [_recommendCellData.descriptionText drawInRect:CGRectMake(88, 45, 200, 17)];
    
    CGContextRestoreGState(context);
//
//    CGContextSaveGState(context);
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextTranslateCTM(context, 0, rect.size.height);
//    CGContextRestoreGState(context);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddEllipseInRect(path, NULL, CGRectMake(15, 15, 100, 15));
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_recommendCellData.name);
//    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [_recommendCellData.name length]), path, NULL);
//
//    // 步骤6：进行绘制
//    CTFrameDraw(frame, context);
//
//    // 步骤7.内存管理
//    CFRelease(path);
//    CFRelease(frame);
//    CFRelease(frameSetter);
    return YES;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 54, 54)];
        _iconImageView.backgroundColor = [UIColor whiteColor];
        _iconImageView.layer.cornerRadius = 27;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = NO;
        _iconImageView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        _iconImageView.layer.borderWidth = 0.3;
        _iconImageView.image = [UIImage imageNamed:@"bba_homepage_mnp_defult_logo"];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

@end
