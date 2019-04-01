//
//  BBAPainterDefine.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/3/27.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#ifndef BBAPainterDefine_h
#define BBAPainterDefine_h

@class BBAPainterImageStorage;
typedef BOOL(^painterAsyncDisplayIsCanclledBlock)(void);

typedef void(^painterImageResizeBlock)(BBAPainterImageStorage *imageStorage, CGFloat delta);
typedef void(^painterAsyncCompleteBlock)(void);

#endif /* BBAPainterDefine_h */
