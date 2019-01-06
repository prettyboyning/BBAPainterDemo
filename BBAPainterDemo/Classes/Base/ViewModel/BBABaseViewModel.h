//
//  BBABaseViewModel.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/4.
//

#import <Foundation/Foundation.h>

typedef void(^BBAPrelayoutCompletionBlock)(NSArray *cellLayouts, NSError *error);
typedef void(^BBASafeInvokeBlock)(void);

@protocol  BBABaseViewModelNetworkRequestProtocol <NSObject>

@optional
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

@end

NS_ASSUME_NONNULL_BEGIN

@interface BBABaseViewModel : NSObject <BBABaseViewModelNetworkRequestProtocol>

/// 网络请求返回的错误
@property (nonatomic, strong, readonly) NSError *error;

@end

/// 安全调用
@interface BBABaseViewModel (SafeInvoke)

/**
 *  @brief  同步安全调用
 *  该类其他方法均已线程安全，禁止再该block里面再调用同类的其他方法
 *
 *  @param block  : 一切数据操作都放到这个block里面执行。
 *
 */
- (void)bba_safe_invoke:(BBASafeInvokeBlock)block;

/**
 *  @brief  异步安全调用
 *
 *  @param block  :  一切数据操作都放到这个block里面执行。
 *
 */
- (void)bba_async_safe_invoke:(BBASafeInvokeBlock)block;

@end

NS_ASSUME_NONNULL_END
