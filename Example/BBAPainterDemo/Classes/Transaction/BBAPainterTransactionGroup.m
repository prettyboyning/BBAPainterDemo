//
//  BBAPainterTransactionGroup.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/20.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterTransactionGroup.h"
#import "CALayer+BBAPainterTransaction.h"
#import "BBAPainterTransaction.h"

static void _transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer,
                                                     CFRunLoopActivity activity,
                                                     void* info);

@interface BBAPainterTransactionGroup ()

/// 存储layer的BBAPainterTransaction 对象
@property (nonatomic, strong) NSHashTable *layersContainers;

@end

@implementation BBAPainterTransactionGroup

+ (BBAPainterTransactionGroup *)mainTransactionGroup {
    static BBAPainterTransactionGroup *mainTransactionGroup;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainTransactionGroup = [[BBAPainterTransactionGroup alloc] init];
        [self registerTransactionGroupAsMainRunloopObserver:mainTransactionGroup];
    });
    return mainTransactionGroup;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.layersContainers = [NSHashTable hashTableWithOptions:NSPointerFunctionsObjectPointerPersonality];
    }
    return self;
}

+ (void)registerTransactionGroupAsMainRunloopObserver:(BBAPainterTransactionGroup *)transactionGroup {
    static CFRunLoopObserverRef observer;
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | kCFRunLoopExit);
    
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)transactionGroup,
        &CFRetain,
        &CFRelease,
        NULL
    };
    observer = CFRunLoopObserverCreate(NULL,
                                       activities,
                                       YES,
                                       INT_MAX,
                                       &_transactionGroupRunLoopObserverCallback,
                                       &context);
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

- (void)addTransactionContainer:(CALayer *)layerContainer {
    [self.layersContainers addObject:layerContainer];
}

+ (void)commit {
    [[BBAPainterTransactionGroup mainTransactionGroup] commit];
}

- (void)commit {
    if ([self.layersContainers count]) {
        NSHashTable *containerLayersToCommit = self.layersContainers;
        for (CALayer *containerLayer in containerLayersToCommit) {
            BBAPainterTransaction* transaction = containerLayer.currentTransaction;
            containerLayer.currentTransaction = nil;
            [transaction commit];
        }
    }
}

@end

static void _transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void* info) {
    BBAPainterTransactionGroup* group = (__bridge BBAPainterTransactionGroup *)info;
    [group commit];
}
