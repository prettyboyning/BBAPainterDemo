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

/// 主标题
@property (nonatomic, strong) UILabel     *titleLabel;
/// 子标题
@property (nonatomic, strong) UILabel     *subTitleLabel;
/// 分割线
@property (nonatomic, strong) UIView      *seperatorLine;

@end


@implementation BBAAsyncImageTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.displayView = [[BBAPainterAsyncView alloc] initWithFrame:CGRectMake(17, 14, 54, 54)];
        [self.contentView addSubview:self.displayView];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor grayColor];
        self.titleLabel.frame = CGRectMake(84, 21, self.contentView.bounds.size.width - 100, 18);
        self.subTitleLabel.frame = CGRectMake(84, 45, self.contentView.bounds.size.width - 100, 18);
        self.seperatorLine.frame = CGRectMake(16, self.contentView.bounds.size.height - 1, self.contentView.bounds.size.width - 100, 1);
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
//        [self.contentView addSubview:self.seperatorLine];
        
        
    }
    return self ;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.displayView.frame = CGRectMake(17, 14, 54, 54);
}

- (void)setLayout:(BBAPainterListLayout *)layout {
    if (_layout != layout) {
        _layout = layout;
        
        self.displayView.layout = self.layout;
        self.titleLabel.text = _layout.name;
        self.subTitleLabel.text = _layout.itemDescription;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        // Recover backgroundColor of subviews.
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        // Recover backgroundColor of subviews.
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:(17.f)];
        _titleLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.userInteractionEnabled = NO;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:(14)];
        _subTitleLabel.textColor = [UIColor colorWithRed:153/255 green:153/255 blue:153/255 alpha:1];
        _subTitleLabel.backgroundColor = [UIColor whiteColor];
        _subTitleLabel.userInteractionEnabled = NO;
    }
    return _subTitleLabel;
}

- (UIView *)seperatorLine {
    if (!_seperatorLine) {
        _seperatorLine = [[UIView alloc] init];
        [_seperatorLine setBackgroundColor:[UIColor colorWithRed:230/255 green:230/255 blue:230/255 alpha:1]];
        _seperatorLine.userInteractionEnabled = NO;
    }
    return _seperatorLine;
}

@end
