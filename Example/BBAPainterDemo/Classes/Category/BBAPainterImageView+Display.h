//
//  BBAPainterImageView+Display.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/31.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterImageView.h"
#import "BBAPainterDefine.h"

NS_ASSUME_NONNULL_BEGIN

@class BBAPainterImageStorage;
@interface BBAPainterImageView (Display)

/**
 *  @brief 设置LWAsyncImageView的图片内容
 *  @param imageStorage          BBAPainterImageStorage对象
 *  @param placeholder           这个block用于LWHTMLDisplayView渲染时，自动调整图片的比例
 *  @param cornerRadius          这个block图像显示完毕后回调
 */

- (void)painterSetImageWihtImageStorage:(BBAPainterImageStorage *)imageStorage
                             resize:(painterImageResizeBlock)resizeBlock
                         completion:(painterAsyncCompleteBlock)completion;

@end

NS_ASSUME_NONNULL_END
