//
//  FSDownloadTaskManager.h
//  FSNetwork
//
//  Created by 付森 on 2018/10/24.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDownloadTaskItem.h"

@protocol FSDownloadTaskManagerDelegate <NSObject>

@optional


@end

@interface FSDownloadTaskManager : NSObject

+ (instancetype)shareInstance;


- (void)resumeItem:(FSDownloadTaskItem *)item;

- (void)addListener:(id<FSDownloadTaskManagerDelegate>)listener;

- (void)removeListener:(id<FSDownloadTaskManagerDelegate>)listener;

@end
