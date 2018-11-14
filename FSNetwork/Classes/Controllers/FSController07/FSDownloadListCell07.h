//
//  FSDownloadListCell07.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/13.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSFileItem;
@interface FSDownloadListCell07 : UITableViewCell

@property (nonatomic, strong) FSFileItem *item;

- (void)updateProgrss:(float)progress;

@end
