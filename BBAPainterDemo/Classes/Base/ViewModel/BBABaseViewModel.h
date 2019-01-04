//
//  BBABaseViewModel.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/4.
//

#import <Foundation/Foundation.h>

@protocol  BBABaseViewModelNetworkRequestProtocol <NSObject>



@end

NS_ASSUME_NONNULL_BEGIN

@interface BBABaseViewModel : NSObject <BBABaseViewModelNetworkRequestProtocol>

@end


@interface BBABaseViewModel (SafeInvoke)

@end

NS_ASSUME_NONNULL_END
