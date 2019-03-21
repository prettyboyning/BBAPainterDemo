//
//  BBAPainterProxy.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/21.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  这个代理对象有一个weak的target对象，用来实现转发消息,并避免循环引用
 */

@interface BBAPainterProxy : NSProxy

/// 持有的外部对象
@property (nonatomic, weak) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithObject:(id)object;

@end

NS_ASSUME_NONNULL_END
