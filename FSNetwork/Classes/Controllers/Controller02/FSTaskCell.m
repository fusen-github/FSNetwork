//
//  FSTaskCell.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/23.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSTaskCell.h"

@interface FSTaskCell ()

@property (nonatomic, weak) UIView *pView;

@property (nonatomic, weak) UILabel *pLabel;

@end

@implementation FSTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *pView = [[UIView alloc] init];
        
        self.pView = pView;
        
        pView.backgroundColor = kMainBlueColor;
        
        [self.contentView addSubview:pView];
        
        UILabel *pLabel = [[UILabel alloc] init];
        
        self.pLabel = pLabel;
        
        pLabel.textColor = [UIColor lightGrayColor];
        
        pLabel.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:pLabel];
    }
    return self;
}

- (void)updateProgress:(float)progress
{
    self.pView.width = self.width * progress;
    
    self.pLabel.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15, 0, self.width - 50, self.height - 1);
    
    self.pView.frame = CGRectMake(0, self.height - 1, self.pView.width, 1);
    
    self.pLabel.frame = CGRectMake(self.width - 50, 0, 50, self.height - 5);
}

@end
