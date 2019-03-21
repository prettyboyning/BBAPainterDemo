//
//  CALayer+BBAPainterTransaction.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/15.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@class BBAPainterTransaction;
@interface CALayer (BBAPainterTransaction)

/// 创建一个LWTransaction并添加到transactions当中
@property (nonatomic, readonly, strong) BBAPainterTransaction* painter_asyncTransaction;

@end

NS_ASSUME_NONNULL_END
