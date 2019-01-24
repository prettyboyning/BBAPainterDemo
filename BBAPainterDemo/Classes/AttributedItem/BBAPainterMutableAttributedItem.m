//
//  BBAPainterMutableAttributedItem.m
//  BBAPainterDemo
//
//  Created by Ning,Liujie on 2019/1/24.
//

#import "BBAPainterMutableAttributedItem.h"
#import "BBAPainterSafeMacro.h"
#import "NSMutableAttributedString+GTextProperty.h"

@interface BBAPainterMutableAttributedItem () {
    NSMutableAttributedString *_textStorage;
}

@property (nonatomic, strong, readwrite) NSMutableAttributedString *resultString;

@end

@implementation BBAPainterMutableAttributedItem

+ (instancetype)itemWithText:(nullable NSString *)text {
    BBAPainterMutableAttributedItem *item = [[BBAPainterMutableAttributedItem alloc] init];
    return item;
}

- (instancetype)initWithText:(nullable NSString *)text {
    self = [super init];
    if (self) {
        _textStorage = [[NSMutableAttributedString alloc] initWithString:CHECK_STRING_VALID(text) ? text : @""];
        [_textStorage bba_setFont:[UIFont systemFontOfSize:11]];
        [_textStorage bba_setColor:[UIColor blackColor]];
        
    }
    return self;
}

@end
