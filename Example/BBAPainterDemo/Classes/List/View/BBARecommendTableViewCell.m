//
//  BBARecommendTableViewCell.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/1/4.
//  Copyright © 2019年 Baidu. All rights reserved.
//

#import "BBARecommendTableViewCell.h"
#import "BBAPainterRecommendContenrView.h"
#import "BBAPainterRecommendCellData.h"

@interface BBARecommendTableViewCell ()

@property (nonatomic, strong) BBAPainterRecommendContenrView *recommendView;

@end

@implementation BBARecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.recommendView = [[BBAPainterRecommendContenrView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.recommendView];
}

- (void)setRecommendCellData:(BBAPainterRecommendCellData *)recommendCellData {
    if (recommendCellData) {
        _recommendCellData = recommendCellData;
        self.recommendView.recommendCellData = recommendCellData;
    }
}

@end
