//
//  BBAPainterBaseViewController.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/3.
//  Copyright © 2019年 ningliujie. All rights reserved.
//

#import "BBAPainterBaseViewController.h"

#import "BBARecommendViewModel.h"

@interface BBAPainterBaseViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    PainterDemoBasicRow _rowStyle;
    UIScrollView *_scrollView;
    
    UITextView *text;
    UITextField *width;
    UITextField *linenumber;
    
//    WMGMixedView *effectView;
}
@end

@implementation BBAPainterBaseViewController


- (id)initWithStyle:(PainterDemoBasicRow)rowStyle
{
    self = [super init];
    if (self) {
        _rowStyle = rowStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *title = @"";
    switch (_rowStyle) {
        case PainterDemoBasicRow_BasicUse:
            title = @"基本使用";
            [self painaterDemoBasicUse];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - private

- (void)painaterDemoBasicUse {
    BBARecommendViewModel *viewModel = [BBARecommendViewModel new];
    [viewModel reloadDataWithParams:@{} completion:^(NSArray *cellLayouts, NSError *error) {
        
    }];
}

@end
