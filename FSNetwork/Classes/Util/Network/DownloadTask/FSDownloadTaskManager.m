//
//  FSDownloadTaskManager.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/24.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDownloadTaskManager.h"

@interface FSDownloadTaskManager ()

/**
 下载器数组
 */
@property (nonatomic, strong) NSArray *loaderArray;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSOperationQueue *taskQueue;

/* 监听者容器 */
@property (nonatomic, strong) NSHashTable *listenerContainer;

@end

@implementation FSDownloadTaskManager

- (NSHashTable *)listenerContainer
{
    @synchronized (self)
    {
        if (_listenerContainer == nil)
        {
            _listenerContainer = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
        }
    }
    
    return _listenerContainer;
}

+ (instancetype)shareInstance
{
    static FSDownloadTaskManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FSDownloadTaskManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)resumeItem:(FSDownloadTaskItem *)item
{
    
}


- (void)addListener:(id<FSDownloadTaskManagerDelegate>)listener
{
    @synchronized (self)
    {
        if (listener == nil) return;
        
        [self.listenerContainer addObject:listener];
    }
}

- (void)removeListener:(id<FSDownloadTaskManagerDelegate>)listener
{
    @synchronized (self)
    {
        if (listener == nil) return;
        
        [self.listenerContainer removeObject:listener];
    }
}

@end
