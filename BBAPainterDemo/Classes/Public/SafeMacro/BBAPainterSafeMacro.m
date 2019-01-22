//
//  BBAPainterSafeMacro.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/22.
//

#import "BBAPainterSafeMacro.h"

@implementation BBAPainterSafeMacro

+ (BOOL)isString:(id)target {
    return BBAPainterIsKindOfClass(target, [NSString class]);
}

+ (BOOL)isArray:(id)target {
    return BBAPainterIsKindOfClass(target, [NSArray class]);
}

+ (BOOL)isDictionary:(id)target {
    return BBAPainterIsKindOfClass(target, [NSDictionary class]);
}

+ (BOOL)isNumber:(id)target {
    return BBAPainterIsKindOfClass(target, [NSNumber class]);
}

+ (BOOL)checkValidString:(NSString *)string {
    return (BBAPainterIsString(string) && [string length] > 0);
}

+ (BOOL)checkValidArray:(NSArray *)array {
    return (BBAPainterIsArray(array) && [array count] > 0);
}

+ (BOOL)checkValidDictionary:(NSDictionary *)dictionary {
    return (BBAPainterIsDictionary(dictionary) && [dictionary count] > 0);
}

+ (BOOL)checkNonzeroNumber:(NSNumber *)number {
    return (BBAPainterIsNumber(number) && ![@0 isEqualToNumber:number]);
}

+ (BOOL)checkValidData:(NSData *)data {
    return (BBAPainterIsKindOfClass(data, [NSData class]) && [data length] > 0);
}

+ (BOOL)checkValidURL:(NSURL *)url {
    return (BBAPainterIsKindOfClass(url, [NSURL class]) && CHECK_STRING_VALID([url scheme]) && CHECK_STRING_VALID([url host]));
}

+ (BOOL)checkValidRange:(NSRange)range {
    return (range.location != NSNotFound && range.length > 0);
}

+ (NSString *)initStringWithString:(NSString *)string {
    if (string != nil && [string length] > 0) {
        return [[NSString alloc] initWithString:string];
    }
    return nil;
}

+ (NSData *)initDataWithData:(NSData *)data {
    if (data != nil && [data length] > 0) {
        return [[NSData alloc] initWithData:data];
    }
    return nil;
}

@end
