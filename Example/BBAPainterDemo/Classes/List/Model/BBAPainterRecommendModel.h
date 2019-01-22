//
//  BBAPainterRecommendModel.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/21.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterRecommendModel : BBAPainterBaseModel

/// 记录时间
@property (nonatomic, copy) NSString *dateStamp;

/// 额外信息
@property (nonatomic, copy) NSString *extInfo;

/// 记录数据类型 BBAHistoryType->BBAHistoryTypeMiniProgram:107
@property (nonatomic, copy) NSString *historyID;

/// 图片地址
@property (nonatomic, copy) NSString *imageUrl;

/// 标题
@property (nonatomic, copy) NSString *title;

/// 数据标识（小程序APPID）
@property (nonatomic, copy) NSString *tag;

/// 端能力掉起URL
@property (nonatomic, copy) NSString *url;

/// 小游戏类型 （defualt-101 , dev-102 ,trial-103 ,experience=104）
@property (nonatomic, assign) NSInteger mnpType;

/// 小游戏类型名称 （标准版-101 , 开发版-102 ,审核版-103 ,体验版=104）
@property (nonatomic, copy) NSString * mnpTypeName;
/// 0为小程序，1为小游戏 默认值为0
@property (nonatomic, copy) NSString * smartAppType;
/// 添加和移到最前面是否要执行动画，默认是 NO
@property (nonatomic, assign) BOOL  isPlayAnimation;
/// 是否需要动画延时
@property (nonatomic, assign) BOOL  isNeedDelay;

- (void)setValueWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
