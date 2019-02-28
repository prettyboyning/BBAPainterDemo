//
//  BBAPainterRecommendModel.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/21.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterRecommendModel.h"

#define kSWANHistoryDicKeyDateStamp      @"dateStamp"
#define kSWANHistoryDicKeyImageUrl       @"iconUrl"
#define kSWANHistoryDicKeyTag            @"appid"
#define kSWANHistoryDicKeyUrl            @"scheme"
#define kSWANHistoryDicKeyMnpType        @"type"
#define kSWANHistoryDicKeyMnpTypeName    @"frameType"
#define kBBAHistoryDicKeyTitle           @"title"

@implementation BBAPainterRecommendModel

- (void)setValueWithDict:(NSDictionary *)dict {

    self.name = [dict objectForKey:@"name"];
    self.icon = [dict objectForKey:@"icon"];
    self.itemDescription = [dict objectForKey:@"description"];
    self.schema = [dict objectForKey:@"schema"];
    self.hotWord = [dict objectForKey:@"hot_word"];
    self.appkey = [dict objectForKey:@"appkey"];
    self.frame_type = [dict objectForKey:@"frame_type"];

}

#pragma mark - getter methods

//- (NSString *)mnpTypeName {
//    switch (_mnpType) {
//        case BBAHomepageMnpTypeDev:
//        {
//            return @"开发版";
//        }
//        case BBAHomepageMnpTypeTrial:
//        {
//            return @"审核版";
//        }
//        case BBAHomepageMnpTypeExperience:
//        {
//            return @"体验版";
//        }
//        default:
//            return nil;
//    }
//}

@end
