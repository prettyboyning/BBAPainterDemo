//
//  BBAPainterResultSet.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/17.
//

#import "BBAPainterResultSet.h"
#import "BBAPainterSafeMacro.h"

@implementation BBAPainterResultSet

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)addItems:(NSArray <BBAPainterBaseModel *> *)items {
    if (BBAPainterIsArray(items)) {
        [self.items addObjectsFromArray:items];
    }
}

@end
