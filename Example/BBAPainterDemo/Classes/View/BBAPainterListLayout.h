//
//  BBAPainterListLayout.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/13.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAPainterLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterListLayout : BBAPainterLayout

//. 名称
@property (nonatomic, copy) NSString *name;

//. 图标
@property (nonatomic, copy) NSString *icon;

//. 描述
@property (nonatomic, copy) NSString *itemDescription;

@end

NS_ASSUME_NONNULL_END
