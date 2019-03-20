//
//  BBASimpleWebBrowerViewController.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/3/8.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBASimpleWebBrowerViewController.h"

@interface BBASimpleWebBrowerViewController ()

@end

@implementation BBASimpleWebBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    sel
}

- (void)loadLocalData {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recommend.json" ofType:nil]];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
