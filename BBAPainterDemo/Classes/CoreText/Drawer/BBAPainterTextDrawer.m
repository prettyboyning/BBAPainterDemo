//
//  BBAPainterTextDrawer.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/26.
//

#import "BBAPainterTextDrawer.h"
#import "BBAPainterTextLayout.h"

@interface BBAPainterTextDrawer () {
    CGPoint _drawOrigin;
    BOOL drawing;
}

@end

@implementation BBAPainterTextDrawer

- (void)setFrame:(CGRect)frame {
    if (drawing && !CGSizeEqualToSize(frame.size, self.textLayout.size)) {
        
    }
}

@end
