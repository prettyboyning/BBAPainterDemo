//
//  BBAPainterImageView+Display.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/31.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterImageView+Display.h"
#import "BBAPainterImageStorage.h"

@implementation BBAPainterImageView (Display)

- (void)painterSetImageWihtImageStorage:(BBAPainterImageStorage *)imageStorage
                                 resize:(painterImageResizeBlock)resizeBlock
                             completion:(painterAsyncCompleteBlock)completion {
    if ([imageStorage.contents isKindOfClass:[UIImage class]]) {
        [self createWebImageWithImageStorage:imageStorage resize:resizeBlock completion:completion];
    } else {
        [self createWebImageWithImageStorage:imageStorage resize:resizeBlock completion:completion];
    }
    
}

- (void)createLocalImageWithImageStorage:(BBAPainterImageStorage *)imageStorage
                                  resize:(painterImageResizeBlock)resizeBlock completion:(painterAsyncCompleteBlock)completion {
    
}

- (void)createWebImageWithImageStorage:(BBAPainterImageStorage *)imageStorage resize:(painterImageResizeBlock)resizeBlock completion:(painterAsyncCompleteBlock)completion {
    
}

@end
