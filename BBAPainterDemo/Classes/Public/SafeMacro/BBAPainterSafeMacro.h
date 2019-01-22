//
//  BBAPainterSafeMacro.h
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/22.
//

#import <Foundation/Foundation.h>

#ifndef BBAPainterSafeMacro_h
#define BBAPainterSafeMacro_h

// check对象的类
#define BBAPainterIsKindOfClass(anObject, aClass) [anObject isKindOfClass:aClass]
#define BBAPainterIsString(aString) [BBAPainterSafeMacro isString:aString]
#define BBAPainterIsArray(anArray) [BBAPainterSafeMacro isArray:anArray]
#define BBAPainterIsDictionary(aDictionary) [BBAPainterSafeMacro isDictionary:aDictionary]
#define BBAPainterIsNumber(aNumber) [BBAPainterSafeMacro isNumber:aNumber]

// check字符串
#define CHECK_STRING_VALID(targetString) \
[BBAPainterSafeMacro checkValidString:targetString]
#define CHECK_STRING_INVALID(targetString) \
(!CHECK_STRING_VALID(targetString))
#define CHECK_STRING_ISEMPTY(targetString) \
(BBAPainterIsString(targetString) && [(NSString *)targetString length] == 0)

// check数组
#define CHECK_ARRAY_VALID(targetArray) \
[BBAPainterSafeMacro checkValidArray:targetArray]
#define CHECK_ARRAY_INVALID(targetArray) \
(!CHECK_ARRAY_VALID(targetArray))

// check字典
#define CHECK_DICTIONARY_VALID(targetDictionary) \
[BBAPainterSafeMacro checkValidDictionary:targetDictionary]
#define CHECK_DICTIONARY_INVALID(targetDictionary) \
(!CHECK_DICTIONARY_VALID(targetDictionary))

// check数字
#define CHECK_NUMBER_ISZERO(targetNumber) \
(BBAPainterIsNumber(targetNumber) && [@0 isEqualToNumber:(NSNumber *)targetNumber])
#define CHECK_NUMBER_ISNONZERO(targetNumber) \
[BBAPainterSafeMacro checkNonzeroNumber:targetNumber]

// check Data
#define CHECK_DATA_VALID(targetData) \
[BBAPainterSafeMacro checkValidData:targetData]

// check URL
#define CHECK_URL_VALID(targetURL) \
[BBAPainterSafeMacro checkValidURL:targetURL]

// check Range
#define CHECK_RANGE_VALID(targetRange) \
[BBAPainterSafeMacro checkValidRange:targetRange]

// check 字典的 Key 值 （是否遵循 NSCopying 协议）
#define CHECK_KEY_VALID(targetKey) \
[targetKey conformsToProtocol:@protocol(NSCopying)]

// 浮点类型判零
#define IS_EQUALS_FLOAT_ZERO(val) \
((val) > -0.000001f && (val) < 0.000001f)

//  只作为sdk的兼容，请勿调用
//#define BBAPainterIsNonEmptyString(targetString) CHECK_STRING_VALID(targetString)

//  只作为sdk的兼容，请勿调用
#define INIT_STRING_WITH_STRING(resultString,originString)           \
do{                                                                  \
resultString = [BBAPainterSafeMacro initStringWithString:originString];    \
}while(0)

//  只作为sdk的兼容，请勿调用
#define INIT_DATA_WITH_DATA(resultData,originData)                   \
do{                                                                  \
resultData = [BBAPainterSafeMacro initDataWithData:originData];            \
}while(0)
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterSafeMacro : NSObject

+ (BOOL)isString:(id)target;

+ (BOOL)isArray:(id)target;

+ (BOOL)isDictionary:(id)target;

+ (BOOL)isNumber:(id)target;

+ (BOOL)checkValidString:(NSString *)string;

+ (BOOL)checkValidArray:(NSArray *)array;

+ (BOOL)checkValidDictionary:(NSDictionary *)dictionary;

+ (BOOL)checkNonzeroNumber:(NSNumber *)number;

+ (BOOL)checkValidData:(NSData *)data;

+ (BOOL)checkValidURL:(NSURL *)url;

+ (BOOL)checkValidRange:(NSRange)range;

+ (NSString *)initStringWithString:(NSString *)string;

+ (NSData *)initDataWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
