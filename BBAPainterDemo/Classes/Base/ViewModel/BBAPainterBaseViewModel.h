//
//  BBAPainterBaseViewModel.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/17.
//

#import <Foundation/Foundation.h>

@class BBAPainterResultSet, BBAPainterBaseModel, BBAPainterBaseCellData;

typedef void(^BBAPrelayoutCompletionBlock)(NSArray *cellLayouts, NSError *error);
typedef void (^BBAEngineLoadCompletion)(BBAPainterResultSet *resultSet, NSError *error);
typedef void(^BBASafeInvokeBlock)(void);

typedef NS_ENUM(NSUInteger, BBARefreshLoadStatus) {
    BBARefreshLoadStatusUnload,     // 未载入状态
    BBARefreshLoadStatusLoading,    // 网络载入中
    BBARefreshLoadStatusLoaded,     // 网络载入完成
};

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterBaseViewModel : NSObject {
    BBARefreshLoadStatus _loadState;
    BBAPainterResultSet *_resultSet;
@protected
    NSMutableArray *_arrayLayouts;
}

/// 网络请求返回的错误
@property (nonatomic, strong, readonly) NSError *error;
/// 网络加载状态
@property (nonatomic, assign, readonly) BBARefreshLoadStatus loadState;
/// 业务列表数据、是否有下一页、当前处于第几页的封装，适用于流式列表结构
@property (nonatomic, strong, readonly) BBAPainterResultSet *resultSet;
// 预排版结果，该数组内装的对象均为排版结果
// 对于该数组的增删改查务必要使用BBABaseViewModel (Operation)中的方式由业务数据驱动
// 排版模型和业务模型的关联关系如下图所示:
//
//  |-------------|  ---weak---->   |---------------|
//  | LayoutModel |                 | BusinessModel |
//  |-------------|  <——strong——    |---------------|
//
@property (nonatomic, strong, readonly) NSMutableArray  *arrayLayouts;

/**
 * UI数据生成的单元方法，该方法会根据业务数据模型刷新出其对应的UI数据
 * 一般情况下，我们需要通过子类集成的方式覆写该方法实现
 * 注意：该方法会在多线程环境调用，注意保证线程安全
 *
 * @param item 一条业务数据，这里的WMGBusinessModel是网络数据模型的一个抽象类,可根据业务实际进行改造.
 *
 * @return WMGBaseCellData 列表场景下的抽象UI数据，亦即排版模型
 */

- (BBAPainterBaseCellData *)refreshCellDataWithMetaData:(BBAPainterBaseModel *)item;

/**
 * 根据指定参数对业务数据进行重载
 * 我们把网络请求、磁盘等本地数据读取均定义到数据层。
 * 按此逻辑，该重载方法多数场景下代表着网络请求，当然也会包含读取本地磁盘等形式的数据
 *
 * @param params 请求参数
 * @param completion 请求完成的回调,当实质性的数据重载请求完成之后，预排版内部会根据业务数据进行UI排版操作
 *
 */
- (void)reloadDataWithParams:(NSDictionary *)params completion:(BBAPrelayoutCompletionBlock)completion;

/**
 * @brief 子类覆盖重写，发起请求
 *
 * @param params 网络请求参数
 * @param completion 请求完成的回调block,该block返回(BBAEngineLoadCompletion *resultSet, NSError *error)
 *
 */
- (void)reloadDataResultWithParams:(NSDictionary *)params completion:(BBAEngineLoadCompletion)completion;


//@end
//
///// 安全调用
//@interface BBAPainterBaseViewModel (SafeInvoke)

/**
 *  @brief  同步安全调用
 *  该类其他方法均已线程安全，禁止再该block里面再调用同类的其他方法
 *
 *  @param block  : 一切数据操作都放到这个block里面执行。
 *
 */
//- (void)bba_safe_invoke:(BBASafeInvokeBlock)block;

/**
 *  @brief  异步安全调用
 *
 *  @param block  :  一切数据操作都放到这个block里面执行。
 *
 */
//- (void)bba_async_safe_invoke:(BBASafeInvokeBlock)block;

@end

NS_ASSUME_NONNULL_END
