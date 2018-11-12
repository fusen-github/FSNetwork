//
//  FSDataTaskManager.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDataTaskManager.h"
#import "FSDataTaskOperation.h"


@interface FSDataTaskManager ()<FSDataTaskOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) NSHashTable *observerHashTable;

@end

@implementation FSDataTaskManager

- (NSHashTable *)observerHashTable
{
    @synchronized (self)
    {
        if (_observerHashTable == nil)
        {
            _observerHashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:1];
        }
    }
    
    return _observerHashTable;
}

- (NSOperationQueue *)queue
{
    if (_queue == nil)
    {
        _queue = [[NSOperationQueue alloc] init];
        
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}

+ (instancetype)shareManager
{
    static FSDataTaskManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FSDataTaskManager alloc] init];
    });
    
    return manager;
}

- (void)resumeDownloadItem:(id<FSDataTaskItem>)downloadItem
{
    if (downloadItem == nil) return;
    
    FSDataTaskOperation *operation = [[FSDataTaskOperation alloc] initWithItem:downloadItem delegate:self];
    
    [self.queue addOperation:operation];
}

- (void)addObserver:(id<FSDataTaskManagerOberser>)observer
{
    if (observer == nil) return;
    
    @synchronized (self)
    {
        [self.observerHashTable addObject:observer];
    }
}

- (void)removeObserver:(id<FSDataTaskManagerOberser>)observer
{
    @synchronized (self)
    {
        [self.observerHashTable removeObject:observer];
    }
}

- (void)operationDidFinished:(FSDataTaskOperation *)operation
{
    for (id delegate in self.observerHashTable.allObjects)
    {
        if ([delegate respondsToSelector:@selector(itemDidFinished:)])
        {
            [delegate itemDidFinished:operation.item];
        }
    }
    
    NSLog(@"operationDidFinished");
}

- (void)operation:(FSDataTaskOperation *)operation didError:(NSError *)error
{
    for (id delegate in self.observerHashTable.allObjects)
    {
        if ([delegate respondsToSelector:@selector(item:didError:)])
        {
            [delegate item:operation.item didError:error];
        }
    }
    
    NSLog(@"download error %@",error);
}

- (void)operation:(FSDataTaskOperation *)operation downloadProgress:(float)progress
{
    for (id delegate in self.observerHashTable.allObjects)
    {
        if ([delegate respondsToSelector:@selector(item:downloadProgress:)])
        {
            [delegate item:operation.item downloadProgress:progress];
        }
    }
    
    NSLog(@"progress: %.2f",progress);
}

@end
