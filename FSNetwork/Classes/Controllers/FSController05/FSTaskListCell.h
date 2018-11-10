//
//  FSTaskListCell.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSFileItem, FSTaskListCell;

@protocol FSTaskListCellDelegate <NSObject>

- (void)touchDownloadWithCell:(FSTaskListCell *)cell;

@end

@interface FSTaskListCell : UITableViewCell

@property (nonatomic, weak) id<FSTaskListCellDelegate> delegate;

- (void)updateCell:(FSFileItem *)item;

@end
