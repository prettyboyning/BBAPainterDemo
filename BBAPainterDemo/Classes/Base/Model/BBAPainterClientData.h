//
//  BBAPainterClientData.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/23.
//

#import <Foundation/Foundation.h>

@class BBAPainterBaseCellData;
NS_ASSUME_NONNULL_BEGIN

/*
 客户端可处理的业务数据封装协议
 通过该协议建立业务数据和排版UI数据之间的联系
 依托数据流刷新依赖该协议
 */

@protocol BBAPainterClientData <NSObject>

// 网络返回的业务数据对应的排版数据
@property (nonatomic, strong, nullable) BBAPainterBaseCellData *cellData;

/**
 * 该方法由业务模型数据来实现
 * 一般情况下，该方法由BBAPainterBaseModel来实现，实现方式如下：
 *   - (void)setNeedsUpdateUIData
 *   {
 *      self.cellData = nil;
 *   }
 *
 * 如果业务中已有网络业务数据父类，直接遵从该协议即可，同时在.m实现中添加上述代码实现
 * 该协议设计借鉴了系统UI更新的策略、机制，同时和RN单向数据流思想相结合
 *
 * 当发生业务数据变化时，响应的排版数据即失效，我们需要以此方式清除，而生成新的对应排版模型是在随后的刷新才会触发的。
 *
 */
- (void)setNeedsUpdateUIData;

@end

NS_ASSUME_NONNULL_END
