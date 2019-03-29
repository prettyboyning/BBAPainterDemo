//
//  BBAPainterLayout.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/29.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterLayout.h"

@interface  BBAPainterLayout ()

/// 存储图片的数组
@property (nonatomic, strong) NSMutableArray <BBAPainterImageStorage *> *imageStorages;
/// 总的对象数组
@property (nonatomic, strong) NSMutableArray <BBAPainterStorage *>* totalStorages;

@end

@implementation BBAPainterLayout

#pragma mark - Override Hash & isEqual

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[BBAPainterLayout class]]) {
        return NO;
    }
    BBAPainterLayout* layout = (BBAPainterLayout *)object;
    return ([layout.imageStorages isEqual:self.imageStorages]);
}

- (NSUInteger)hash {
//    long v1 = (long)((__bridge void *)self.textStorages);
    long v2 = (long)((__bridge void *)self.imageStorages);
    return v2;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imageStorages forKey:@"imageStorages"];
    [aCoder encodeObject:self.totalStorages forKey:@"totalStorages"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.imageStorages = [aDecoder decodeObjectForKey:@"imageStorages"];
        self.totalStorages = [aDecoder decodeObjectForKey:@"totalStorages"];
    }
    return self;
}

#pragma mark - painterLayoutProtocol

- (void)addStorage:(BBAPainterStorage *)storage {
    if (!storage) {
        return;
    }
    
    if ([storage isMemberOfClass:[BBAPainterImageStorage class]]) {
        [self.imageStorages addObject:(BBAPainterImageStorage *)storage];
    }
    [self.totalStorages addObject:storage];
}

- (void)addStorages:(NSArray <BBAPainterStorage *> *)storages {
    if (!storages) {
        return;
    }
    for (BBAPainterStorage* storage in storages) {
        if ([storage isMemberOfClass:[BBAPainterImageStorage class]]) {
            [self.imageStorages addObject:(BBAPainterImageStorage *)storage];
        }
    }
    [self.totalStorages addObjectsFromArray:storages];
}


- (void)removeStorage:(BBAPainterStorage *)storage {
    if (!storage) {
        return;
    }
    if ([storage isMemberOfClass:[BBAPainterImageStorage class]]) {
        if ([self.imageStorages containsObject:(BBAPainterImageStorage *)storage]) {
            [self.imageStorages removeObject:(BBAPainterImageStorage *)storage];
            [self.totalStorages removeObject:(BBAPainterImageStorage *)storage];
        }
    }
}

- (void)removeStorages:(NSArray <BBAPainterStorage *> *)storages {
    if (!storages) {
        return;
    }
    for (BBAPainterStorage* storage in storages) {
        if ([storage isMemberOfClass:[BBAPainterImageStorage class]]) {
            if ([self.imageStorages containsObject:(BBAPainterImageStorage *)storage]) {
                [self.imageStorages removeObject:(BBAPainterImageStorage *)storage];
                [self.totalStorages removeObject:(BBAPainterImageStorage *)storage];
            }
        }
    }
}


- (CGFloat)suggestHeightWithBottomMargin:(CGFloat)bottomMargin {
    CGFloat suggestHeight = 0.0f;
    for (BBAPainterStorage* storage in self.totalStorages) {
        suggestHeight = suggestHeight > storage.bottom ? suggestHeight :storage.bottom;
    }
    return suggestHeight + bottomMargin;
}

#pragma mark - Getter

- (NSMutableArray *)imageStorages {
    if (!_imageStorages) {
        _imageStorages = [[NSMutableArray alloc] init];
    }
    return _imageStorages;
}

- (NSMutableArray *)totalStorages {
    if (!_totalStorages) {
        _totalStorages = [[NSMutableArray alloc] init];
    }
    return _totalStorages;
}

@end
