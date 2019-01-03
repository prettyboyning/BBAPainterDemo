//
//  BBAPainterBaseViewController.h
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/3.
//  Copyright © 2019年 ningliujie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PainterDemoBasicRow) {
    PainterDemoBasicRow_BasicUse,
    PainterDemoBasicRow_AdvancedUse,
    PainterDemoBasicRow_TextCaculate,
    PainterDemoBasicRow_ImageRelated,
};

@interface BBAPainterBaseViewController : UIViewController

- (id)initWithStyle:(PainterDemoBasicRow)rowStyle;

@end

NS_ASSUME_NONNULL_END
