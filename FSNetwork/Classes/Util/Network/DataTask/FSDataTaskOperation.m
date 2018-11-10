//
//  FSDataTaskOperation.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDataTaskOperation.h"
#import "FSDataTaskDownloader.h"

@interface FSDataTaskOperation ()<FSDataTaskDownloaderDelegate>

@property (nonatomic, strong) FSDataTaskDownloader *downloader;

@property (nonatomic, weak) id<FSDataTaskOperationDelegate> delegate;

@property (nonatomic, assign) BOOL runFlag;

@end

@implementation FSDataTaskOperation

- (instancetype)initWithItem:(id<FSDataTaskItem>)item delegate:(id<FSDataTaskOperationDelegate>)delegate
{
    if ([item downloadUrl] == nil || ![[item targetPath] length])
    {
        return nil;
    }
    
    if (self = [super init])
    {
        self->_item = item;
        
        self.delegate = delegate;
    }
    return self;
}

- (void)main
{
    if (self.isCancelled)
    {
        return;
    }
    
    NSURL *url = [self.item downloadUrl];
    
    NSString *targetPath = [self.item targetPath];
    
    FSDataTaskDownloader *downloader = [FSDataTaskDownloader downloaderWithURL:url targetPath:targetPath delegate:self];
    
    self.downloader = downloader;
    
    [downloader resume];
    
    self.runFlag = YES;
    
//    NSLog(@"%@",currentRunLoop);
    
//    [NSOperationQueue currentQueue]
    
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    while (self.runFlag)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}


- (void)cancel
{
    [self.downloader invalidateAndCancel];
    
    self.downloader = nil;
    
    self.runFlag = NO;
}

#pragma mark FSDataTaskDownloaderDelegate

- (void)downloaderDidFinished:(FSDataTaskDownloader *)downloader
{
    if ([self.delegate respondsToSelector:@selector(operationDidFinished:)])
    {
        [self.delegate operationDidFinished:self];
    }
    
    self.runFlag = NO;
}

- (void)downloader:(FSDataTaskDownloader *)downloader didError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(operation:didError:)])
    {
        [self.delegate operation:self didError:error];
    }
    
    self.runFlag = NO;
}


- (void)downloader:(FSDataTaskDownloader *)downloader downloadProgress:(float)progress
{
    if ([self.delegate respondsToSelector:@selector(operation:downloadProgress:)])
    {
        [self.delegate operation:self downloadProgress:progress];
    }
}

- (void)dealloc
{
    NSLog(@"FSDataTaskOperation dealloc. lastPathComponent:%@",self.item.downloadUrl.lastPathComponent);
}

@end
