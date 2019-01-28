//
//  BBAPainterTextDrawer+Private.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/28.
//

#import "BBAPainterTextDrawer.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterTextDrawer ()

// 绘制原点，一般情况下，经过预排版之后，通过BBAPainterTextDrawer的Frame设置，仅供框架内部使用，请勿直接操作
@property (nonatomic, assign) CGPoint drawOrigin;

@end

NS_ASSUME_NONNULL_END
