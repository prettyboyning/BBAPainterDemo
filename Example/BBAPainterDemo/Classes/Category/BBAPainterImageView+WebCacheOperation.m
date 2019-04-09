//
//  BBAPainterImageView+WebCacheOperation.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/3.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterImageView+WebCacheOperation.h"
#import "BBAPainterSafeMacro.h"
#import "SDWebImageManager.h"
#import <objc/runtime.h>

static char loadOperationKey;

typedef NSMutableDictionary <NSString *, id> painterOperationsDictionary;

@implementation BBAPainterImageView (WebCacheOperation)

- (void)painter_setImageLoadOperationWithKey:(nullable id)operation for:(nullable NSString *)key {
    
    if (CHECK_STRING_VALID(key)) {
        painterOperationsDictionary *operationsDictionary = [self operationsDictionary];
        [self painter_cancelImageLoadOperationWithKey:key];
        if (operation) {
            operationsDictionary[key] = operation;
        }
    }
}

- (void)painter_removeImageLoadOperationWithKey:(nullable NSString *)key {
    painterOperationsDictionary *operationsDictionary = [self operationsDictionary];
    if (CHECK_STRING_VALID(key)) {
        [operationsDictionary removeObjectForKey:key];
    }
}

- (void)painter_cancelImageLoadOperationWithKey:(nullable NSString *)key {
    painterOperationsDictionary *operationsDictionary = [self operationsDictionary];
    if (CHECK_STRING_VALID(key)) {
        id operations = [operationsDictionary objectForKey:key];
        if (operations) {
            if ([operations isKindOfClass:[NSArray class]]) {
                for (id <SDWebImageOperation> operation in operations) {
                    if (operation) {
                        [operation cancel];
                    }
                }
            } else if ([operations conformsToProtocol:@protocol(SDWebImageOperation)]) {
                [(id<SDWebImageOperation>) operations cancel];
            }
        }
    }
}

- (painterOperationsDictionary *)operationsDictionary {
    painterOperationsDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

@end
