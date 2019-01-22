//
//  BBAPainterResultSet.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BBAPainterBaseModel;
@interface BBAPainterResultSet : NSObject

// 列表业务数据
@property (nonatomic, strong, readonly) NSMutableArray <NSMutableArray <BBAPainterBaseModel *> *> *items;
/// 如果有分页，代表总页数
@property (nonatomic, assign) NSUInteger pageSize;
/// 当前页数
@property (nonatomic, assign) NSUInteger currentPage;
/// 是否还有分页数据，通常情况下  hasMore = (currentPage = pageSize - 1)
@property (nonatomic, assign) BOOL hasMore;

/**
 * @brief 添加一批业务数据，一般情况下由BBABaseViewModel负责调用
 *
 * @param items  业务数据
 *
 */
- (void)addItems:(NSArray <BBAPainterBaseModel *> *)items;

@end

NS_ASSUME_NONNULL_END
