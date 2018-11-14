//
//  FSTaskListCell07.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/13.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSTaskListCell07.h"
#import "FSFileItem.h"


@interface FSTaskListCell07 ()

@property (nonatomic, weak) UIButton *dlButton;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *stateLabel;

@end

@implementation FSTaskListCell07

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        
        self.titleLabel = titleLabel;
        
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:titleLabel];
        
        
        UIButton *dlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        dlButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [dlButton setTitle:@"下载" forState:UIControlStateNormal];
        
        [dlButton setTitleColor:kMainBlueColor forState:UIControlStateNormal];
        
        dlButton.layer.borderColor = kMainBlueColor.CGColor;
        
        dlButton.layer.borderWidth = 0.5;
        
        self.dlButton = dlButton;
        
        [dlButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:dlButton];
        
        UILabel *stateLabel = [[UILabel alloc] init];
        
        stateLabel.textColor = [UIColor lightGrayColor];
        
        stateLabel.font = [UIFont systemFontOfSize:12];
        
        stateLabel.hidden = YES;
        
        self.stateLabel = stateLabel;
        
        [self.contentView addSubview:stateLabel];
        
    }
    return self;
}



- (void)updateCell:(FSFileItem *)item
{
    self.titleLabel.text = item.title;
    
    
    
}

- (void)downloadAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(touchDownloadWithCell:)])
    {
        [self.delegate touchDownloadWithCell:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat left = 15;
    
    CGFloat right = 10;
    
    CGFloat dlBtnW = 50;
    
    CGFloat titleLabelWidth = self.contentView.width - dlBtnW - 2 * right - left;
    
    self.titleLabel.frame = CGRectMake(left, 0, titleLabelWidth, self.contentView.height);
    
    CGFloat topMargin = 10;
    
    CGFloat dlBtnH = self.contentView.height - 2 * topMargin;
    
    if (!self.dlButton.hidden)
    {
        self.dlButton.frame = CGRectMake(self.titleLabel.maxX + right, topMargin, dlBtnW, dlBtnH);
    }
    
    if (!self.stateLabel.hidden)
    {
        self.stateLabel.frame = CGRectMake(self.titleLabel.maxX + right, topMargin, dlBtnW, dlBtnH);
    }
}

@end
