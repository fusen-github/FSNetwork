//
//  FSTaskListCell07.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/13.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSFileItem, FSTaskListCell07;

@protocol FSTaskListCell07Delegate <NSObject>

- (void)touchDownloadWithCell:(FSTaskListCell07 *)cell;

@end

@interface FSTaskListCell07 : UITableViewCell

@property (nonatomic, weak) id<FSTaskListCell07Delegate> delegate;

- (void)updateCell:(FSFileItem *)item;

@end
