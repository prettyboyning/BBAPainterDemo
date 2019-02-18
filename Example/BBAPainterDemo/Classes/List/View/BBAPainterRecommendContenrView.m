//
//  BBAPainterRecommendContenrView.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/2/18.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterRecommendContenrView.h"
#import "BBAPainterRecommendCellData.h"

@implementation BBAPainterRecommendContenrView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setRecommendCellData:(BBAPainterRecommendCellData *)recommendCellData {
    if (recommendCellData) {
        _recommendCellData = recommendCellData;
        [self setNeedsDisplay];
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
    [_recommendCellData.name drawInRect:CGRectMake(15, 15, 200, 15)];
    return YES;
}

@end
