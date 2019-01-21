//
//  BBAPainterResultSet.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterResultSet : NSObject

/// 如果有分页，代表总页数
@property (nonatomic, assign) NSUInteger pageSize;
/// 当前页数
@property (nonatomic, assign) NSUInteger currentPage;
/// 是否还有分页数据，通常情况下  hasMore = (currentPage = pageSize - 1)
@property (nonatomic, assign) BOOL hasMore;

@end

NS_ASSUME_NONNULL_END
