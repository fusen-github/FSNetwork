//
//  FSDownloadListCell.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDownloadListCell.h"
#import "FSFileItem.h"


@interface FSDownloadListCell ()

@property (nonatomic, weak) UIButton *dlButton;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *stateLabel;

@property (nonatomic, weak) UILabel *progressLabel;

@property (nonatomic, weak) UIProgressView *progressView;

@end

@implementation FSDownloadListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        /// 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        
        self.titleLabel = titleLabel;
        
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:titleLabel];
        
        /// 状态
        UILabel *stateLabel = [[UILabel alloc] init];
        
        stateLabel.textColor = [UIColor lightGrayColor];
        
        stateLabel.font = [UIFont systemFontOfSize:12];
        
        stateLabel.hidden = YES;
        
        self.stateLabel = stateLabel;
        
        [self.contentView addSubview:stateLabel];
        
        /// 下载、暂停按钮
        UIButton *dlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        dlButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [dlButton setTitle:@"下载" forState:UIControlStateNormal];
        
        [dlButton setTitleColor:kMainBlueColor forState:UIControlStateNormal];
        
        dlButton.layer.borderColor = kMainBlueColor.CGColor;
        
        dlButton.layer.borderWidth = 0.5;
        
        self.dlButton = dlButton;
        
        [dlButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:dlButton];
        
        
        UILabel *progressLabel = [[UILabel alloc] init];
        
        progressLabel.font = [UIFont systemFontOfSize:10];
        
        progressLabel.textColor = [UIColor lightGrayColor];
        
        self.progressLabel = progressLabel;
        
        [self.contentView addSubview:progressLabel];
        
        
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        
        progressView.progressTintColor = kMainBlueColor;
        
        self.progressView = progressView;
        
        [self.contentView addSubview:progressView];
        
    }
    return self;
}



- (void)updateCell:(FSFileItem *)item
{
    self.titleLabel.text = item.title;
    
    
    
}

- (void)downloadAction:(UIButton *)button
{
//    if ([self.delegate respondsToSelector:@selector(touchDownloadWithCell:)])
//    {
//        [self.delegate touchDownloadWithCell:self];
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat left = 15;
    
    CGFloat right = 10;
    
    CGFloat dlBtnW = 50;
    
    CGFloat titleLabelWidth = 0;
    
    if (!self.dlButton.hidden)
    {
        titleLabelWidth = self.contentView.width - (dlBtnW + right) * 2 - left;
    }
    else
    {
        titleLabelWidth = self.contentView.width - (dlBtnW + right) * 1 - left;
    }
    
    self.titleLabel.frame = CGRectMake(left, 0, titleLabelWidth, self.contentView.height);
    
    CGFloat topMargin = 5;
    
    CGFloat itemH = 25;
    
    self.stateLabel.frame = CGRectMake(self.titleLabel.maxX + 5, topMargin, dlBtnW, itemH);
    
    if (!self.dlButton.hidden)
    {
        self.dlButton.frame = CGRectMake(self.stateLabel.maxX + 5, topMargin, dlBtnW, itemH);
    }
    
    self.progressLabel.frame = CGRectMake(self.dlButton.x, self.dlButton.maxY, dlBtnW, self.contentView.height - self.dlButton.maxY);
    
    self.progressView.frame = CGRectMake(15, self.contentView.height - 0.5, self.contentView.width - 15, 0.5);
}

@end
