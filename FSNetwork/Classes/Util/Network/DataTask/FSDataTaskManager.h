//
//  FSDataTaskManager.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDataTaskItem.h"

@protocol FSDataTaskManagerOberser <NSObject>

@optional
- (void)itemDidFinished:(id<FSDataTaskItem>)item;

- (void)item:(id<FSDataTaskItem>)item didError:(NSError *)error;

- (void)item:(id<FSDataTaskItem>)item downloadProgress:(float)progress;

@end

@interface FSDataTaskManager : NSObject

+ (instancetype)shareManager;

- (void)addObserver:(id<FSDataTaskManagerOberser>)observer;

- (void)removeObserver:(id<FSDataTaskManagerOberser>)observer;

- (void)resumeDownloadItem:(id<FSDataTaskItem>)downloadItem;

@end
