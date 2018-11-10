//
//  FSCell05.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSCell05.h"

@interface FSCell05 ()

@property (nonatomic, weak) UIView *pView;

@property (nonatomic, weak) UILabel *pLabel;

@property (nonatomic, weak) UIButton *statusButton;

@end

@implementation FSCell05

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.statusButton = statusButton;
        
        statusButton.layer.borderColor = kMainBlueColor.CGColor;
        
        statusButton.layer.borderWidth = 0.5;
        
        [self.contentView addSubview:statusButton];
        
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
    
//    self.statusButton.frame = CGRectMake(self.width - 50, 5, <#CGFloat width#>, <#CGFloat height#>)
    
    self.pLabel.frame = CGRectMake(self.width - 50, 0, 50, self.height - 5);
}

@end
