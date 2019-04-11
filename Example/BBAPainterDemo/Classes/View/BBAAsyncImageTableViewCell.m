//
//  BBAAsyncImageTableViewCell.m
//  BBAPainterDemo_Example
//
//  Created by Ning,Liujie on 2019/4/10.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "BBAAsyncImageTableViewCell.h"
#import "BBAPainterAsyncView.h"

@interface BBAAsyncImageTableViewCell ()

@property (nonatomic,strong) BBAPainterAsyncView* displayView;

@end


@implementation BBAAsyncImageTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.displayView = [[BBAPainterAsyncView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.displayView];
        
    }
    return self ;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.displayView.frame = self.bounds;
}

- (void)setLayout:(BBAPainterLayout *)layout {
    if (_layout != layout) {
        _layout = layout;
        
        self.displayView.layout = self.layout;
    }
}

@end
