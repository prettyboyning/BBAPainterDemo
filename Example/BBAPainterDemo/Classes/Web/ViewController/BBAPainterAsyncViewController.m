//
//  BBAPainterAsyncViewController.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/25.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBAPainterAsyncViewController.h"
#import "BBAPainterAsyncView.h"

@interface BBAPainterAsyncViewController ()

@property (nonatomic, strong) BBAPainterAsyncView *asyncView;

@end

@implementation BBAPainterAsyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.asyncView = [[BBAPainterAsyncView alloc] init];
}

@end
