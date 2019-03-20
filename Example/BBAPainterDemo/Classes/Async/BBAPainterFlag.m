//
//  BBAPainterFlag.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterFlag.h"
#import <libkern/OSAtomic.h>
#import "objc/runtime.h"

@implementation BBAPainterFlag {
    int32_t _value;
}

- (int32_t)value {
    return _value;
}

- (int32_t)increment {
    return OSAtomicIncrement32(&_value);
}

@end
