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

//. 名称
@property (nonatomic, copy) NSString *name;

//. 图标
@property (nonatomic, copy) NSString *icon;

//. 描述
@property (nonatomic, copy) NSString *itemDescription;

//. 图片路径
@property (nonatomic, copy) NSString *schema;

//. 副标题推荐
@property (nonatomic, copy) NSString *hotWord;

@property (nonatomic, copy) NSString *appkey;

@property (nonatomic, copy) NSString *frame_type;

- (void)setValueWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
