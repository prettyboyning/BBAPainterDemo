//
//  BBAPainterLayout.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/29.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBAPainterStorage.h"
#import "BBAPainterImageStorage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol painterLayoutProtocol <NSObject>

/**
 *  @brief 添加一个BBAPainterStorage对象
 *
 *  @param storage 一个BBAPainterStorage对象
 */
- (void)addStorage:(BBAPainterStorage *)storage;

/**
 *  @brief 添加一个包含BBAPainterStorage对象的数组的所有元素到BBAPainterLayout
 *
 *  @param storages 一个包含BBAPainterStorage对象的数组
 */
- (void)addStorages:(NSArray <BBAPainterStorage *> *)storages;

/**
 *  @brief 移除一个BBAPainterStorage对象
 *
 *  @param storage 一个BBAPainterStorage对象
 */
- (void)removeStorage:(BBAPainterStorage *)storage;

/**
 *  @brief 移除一个包含BBAPainterStorage对象的数组的所有元素
 *
 *  @param storages 一个包含BBAPainterStorage对象的数组
 */
- (void)removeStorages:(NSArray <BBAPainterStorage *> *)storages;

/**
 *  @brief 获取到一个建议的高度，主要用于UITabelViewCell的高度设定。
 *  你可以在UITableVeiw的代理方法中直接返回这个高度，来方便的动态设定Cell高度
 *
 *  @param bottomMargin 距离底部的间距
 *
 *  @return 建议的高度
 */
- (CGFloat)suggestHeightWithBottomMargin:(CGFloat)bottomMargin;

/**
 *  @brief 获取包含BBAPainterImageStorage的数组
 *
 */
- (NSMutableArray<BBAPainterImageStorage *>*)imageStorages;


/**
 *  @brief 获取包含所有的LWStorage的数组
 *
 */
- (NSMutableArray<BBAPainterStorage *>*) totalStorages;

@end

@interface BBAPainterLayout : NSObject <painterLayoutProtocol, NSCoding>

@end

NS_ASSUME_NONNULL_END
