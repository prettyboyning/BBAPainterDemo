//
//  BBAPainterCGRectTransform.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/28.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterCGRectTransform : NSObject

/**
 *  根据contentMode获取绘制的CGRect
 *
 */
+ (CGRect)painter_CGRectFitWithContentMode:(UIViewContentMode)contentMode
                                 rect:(CGRect)rect
                                 size:(CGSize)siz;


@end

NS_ASSUME_NONNULL_END
