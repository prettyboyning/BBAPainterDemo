//
//  BBAPainterBaseCellData.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/23.
//

#import <Foundation/Foundation.h>
#import "BBAPainterClientData.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterBaseCellData : NSObject

// UI数据对应的业务数据
@property (nonatomic, weak) id <BBAPainterClientData> metaData;

@end

NS_ASSUME_NONNULL_END
