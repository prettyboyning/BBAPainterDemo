//
//  BBAPainterBaseModel.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/17.
//

#import "BBAPainterBaseModel.h"

@implementation BBAPainterBaseModel

@synthesize cellData;

- (void)setNeedsUpdateUIData {
    self.cellData = nil;
}

@end
