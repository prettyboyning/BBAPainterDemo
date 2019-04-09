//
//  BBAPainterImageView+WebCacheOperation.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/3.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterImageView (WebCacheOperation)

/**
 *  把NSOperation对象设置到BBAPainterImageView的关联对象operationDictionary上，用于取消操作
 *
 *  @param operation operation对象
 *  @param key       operation对象存在字典中的key
 */
- (void)painter_setImageLoadOperationWithKey:(nullable id)operation for:(nullable NSString *)key;

/**
 *  将一个operation对象从关联对象operationDictionary中取消
 *
 *  @param key       operation对象存在字典中的key
 */
- (void)painter_cancelImageLoadOperationWithKey:(nullable NSString *)key;

/**
 *  将一个operation对象从关联对象operationDictionary中移除
 *
 *  @param key       operation对象存在字典中的key
 */
- (void)painter_removeImageLoadOperationWithKey:(nullable NSString *)key;

@end

NS_ASSUME_NONNULL_END
