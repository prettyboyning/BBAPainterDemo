//
//  BBAPainterStorage.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/25.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBAPainterStorage : NSObject <NSCoding>

/// 一个标示字符串，可以用于复用时取到属性相同的UIView对象
@property (nullable, nonatomic, copy) NSString* identifier;
/// 一个标示符，跟UIView对象的tag属性作用一样
@property (nonatomic, assign) NSInteger tag;
/// 是否在边缘剪切，跟UIView对象的clipsToBounds属性作用一样
@property (nonatomic, assign) BOOL clipsToBounds;
/// 跟UIView对象的同名属性作用一样
@property (nonatomic, getter = isOpaque) BOOL opaque;
/// 跟UIView对象的同名属性作用一样
@property (nonatomic, getter = isHidden) BOOL hidden;
/// 跟UIView对象的同名属性作用一样
@property (nonatomic, assign) CGFloat alpha;
/// 跟UIView对象的同名属性作用一样
@property (nonatomic, assign) CGRect frame;
/// 跟UIView对象的同名属性作用一样
@property (nonatomic, assign) CGRect bounds;
/// 跟UIView对象的frame.size.height作用一样
@property (nonatomic, assign, readonly) CGFloat height;
/// 跟UIView对象的frame.size.width作用一样
@property (nonatomic, assign, readonly) CGFloat width;
/// 跟UIView对象的frame.origin.x作用一样
@property (nonatomic, assign, readonly) CGFloat left;
/// 跟UIView对象的frame.origin.x+frame.size.width作用一样
@property (nonatomic, assign,readonly) CGFloat right;
/// 跟UIView对象的frame.origin.y作用一样
@property (nonatomic, assign, readonly) CGFloat top;
/// 跟UIView对象的frame.origin.y+frame.size.height作用一样
@property (nonatomic, assign, readonly) CGFloat bottom;

/// 跟UIView对象的同名属性作用一样
@property (nonatomic, assign) CGPoint center;
/// 跟UIView对象的同名属性作用一样
@property (nonatomic, assign) CGPoint position;
/// 跟CALayer对象的同名属性作用一样
@property (nonatomic, assign) CGFloat cornerRadius;
/// 圆角半径部分的背景颜色
@property (nonatomic, strong, nullable) UIColor* cornerBackgroundColor;
/// 圆角半径的描边颜色
@property (nonatomic, strong, nullable) UIColor* cornerBorderColor;
/// 圆角半径的描边宽度
@property (nonatomic, assign) CGFloat cornerBorderWidth;
/// 跟CALayer对象的同名属性作用一样
@property (nonatomic, assign, nullable) UIColor* shadowColor;
/// 跟CALayer对象的同名属性作用一样
@property (nonatomic, assign) CGFloat shadowOpacity;
/// 跟CALayer对象的同名属性作用一样
@property (nonatomic, assign) CGSize shadowOffset;
/// 跟CALayer对象的同名属性作用一样
@property (nonatomic, assign) CGFloat shadowRadius;
/// 跟CALayer对象的同名属性作用一样
@property (nonatomic, assign) CGFloat contentsScale;
/// 跟UIView对象的同名属性作用一样
@property (nonatomic, strong, nullable) UIColor* backgroundColor;
/// 跟UIView对象的同名属性作用一样
@property (nonatomic, assign) UIViewContentMode contentMode;

#pragma mark - HTMLDisplayView

/// 私有属性，用于LWHTMLDisplayView设置内容的UIEdgeInsets
@property (nonatomic, assign) UIEdgeInsets htmlLayoutEdgeInsets;
/// 额外绘制的标记字符串
@property (nonatomic, copy, nullable) NSString* extraDisplayIdentifier;

/**
 *  @brief 设置一个标示字符串并初始化一个LWStorage对象
 *
 *  @param identifier 一个标示字符串
 *
 *  @return 一个BBAPainterStorage对象
 */
- (_Nonnull id)initWithIdentifier:(NSString * _Nullable )identifier;

@end

NS_ASSUME_NONNULL_END
