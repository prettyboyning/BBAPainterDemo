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
    self.dateStamp = [dict objectForKey:kSWANHistoryDicKeyDateStamp];
    self.imageUrl  = [dict objectForKey:kSWANHistoryDicKeyImageUrl];
    self.title     = [dict objectForKey:kBBAHistoryDicKeyTitle];
    self.tag       = [dict objectForKey:kSWANHistoryDicKeyTag];
    self.url       = [dict objectForKey:kSWANHistoryDicKeyUrl];
    
//    NSString *mnpType = [dict objectForKey:kSWANHistoryDicKeyMnpType];
//    if ([mnpType isEqualToString:@"default"]) {
//        self.mnpType = BBAHomepageMnpTypeDefault;
//    } else if ([mnpType isEqualToString:@"dev"]) {
//        self.mnpType = BBAHomepageMnpTypeDev;
//    } else if ([mnpType isEqualToString:@"trial"]) {
//        self.mnpType = BBAHomepageMnpTypeTrial;
//    } else if ([mnpType isEqualToString:@"experience"]) {
//        self.mnpType = BBAHomepageMnpTypeExperience;
//    }
    
    self.smartAppType = [dict objectForKey:kSWANHistoryDicKeyMnpTypeName];
    // 配置extInfo
    NSMutableDictionary *extDic = [NSMutableDictionary new];
//    if (CHECK_STRING_VALID(mnpType)) {
//        [extDic setObject:mnpType forKey:kBBAHistoryDicKeyMnpType];
//    }
//    if (CHECK_STRING_VALID(self.smartAppType)) {
//        [extDic setObject:self.smartAppType forKey:kBBAHistoryDicKeySmartAppType];
//    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extDic options:NSJSONWritingPrettyPrinted error:nil];
    if (jsonData) {
        self.extInfo = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
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
