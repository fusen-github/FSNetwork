//
//  FSDownloadOperation.h
//  FSNetwork
//
//  Created by 付森 on 2018/10/24.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FSDownloadTaskItem;
@interface FSDownloadOperation : NSOperation

// 是否停止
@property (nonatomic, assign) BOOL stoped;

- (instancetype)initWithTaskItem:(FSDownloadTaskItem *)item;

@end
