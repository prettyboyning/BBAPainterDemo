//
//  BBAPainterRecommendCellData.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/23.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterBaseCellData.h"
#import "BBAPainterVisionObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterRecommendCellData : BBAPainterBaseCellData

@property (nonatomic, strong) BBAPainterVisionObject *nameObj;

@property (nonatomic, copy) NSAttributedString *name;

@property (nonatomic, copy) NSAttributedString *icon;

@property (nonatomic, copy) NSAttributedString *descriptionText;


@end

NS_ASSUME_NONNULL_END
