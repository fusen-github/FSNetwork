//
//  FSDLManager.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/12.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDLManager.h"
#import "FSOperation.h"
#import "FSDataTaskDelegate.h"


@interface FSDLManager ()<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableDictionary *taskDelegateInfo;

@end

@implementation FSDLManager

- (NSMutableDictionary *)taskDelegateInfo
{
    if (_taskDelegateInfo == nil)
    {
        _taskDelegateInfo = [NSMutableDictionary dictionary];
    }
    return _taskDelegateInfo;
}

+ (instancetype)shareManager
{
    static FSDLManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FSDLManager alloc] init];
    });
    
    return manager;
}

- (NSURLSession *)session
{
    if (_session == nil)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        configuration.HTTPMaximumConnectionsPerHost = 5;
        
        configuration.timeoutIntervalForRequest = 20;
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
        
    }
    return _session;
}

- (void)downloadUrl:(NSURL *)url
{
    NSString *path = [self downlaodPath];
    
    path = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    unsigned long long length = [self fileSizeAtPath:path];

    NSString *range = [NSString stringWithFormat:@"bytes=%llu-",length];
    
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> *dataTasks, NSArray<NSURLSessionUploadTask *> *uploadTasks, NSArray<NSURLSessionDownloadTask *> *downloadTasks) {
        
    }];
    
    [self.session getAllTasksWithCompletionHandler:^(NSArray<NSURLSessionTask *> *tasks) {
        
        NSLog(@"%@",tasks);
        
    }];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    
    FSDataTaskDelegate *delegate = [[FSDataTaskDelegate alloc] initWithDataTask:dataTask targetPath:path receivedLength:length];
    
    [self.taskDelegateInfo setObject:delegate forKey:@(dataTask.taskIdentifier)];
    
    [dataTask resume];
}

- (unsigned long long)fileSizeAtPath:(NSString *)path
{
    unsigned long long fileSize = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *error = nil;
        
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        
        if (dict && error == nil)
        {
            fileSize = [dict fileSize];
        }
    }
    
    return fileSize;
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    FSDataTaskDelegate *delegate = [self delegateForTask:dataTask];
    
    [delegate URLSession:session dataTask:dataTask
      didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    FSDataTaskDelegate *delegate = [self delegateForTask:dataTask];

    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    FSDataTaskDelegate *delegate = [self delegateForTask:task];

    [delegate URLSession:session task:task didCompleteWithError:error];
    
    [self removeDelegateForTask:task];
}


- (FSDataTaskDelegate *)delegateForTask:(NSURLSessionTask *)task
{
    NSParameterAssert(task);
    
    @synchronized (self)
    {
        FSDataTaskDelegate *delegate = self.taskDelegateInfo[@(task.taskIdentifier)];
        
        return delegate;
    }
}


- (void)setDelegate:(FSDataTaskDelegate *)delegate forTask:(NSURLSessionTask *)task
{
    NSParameterAssert(delegate);
    
    NSParameterAssert(task);
    
    @synchronized (self)
    {
        [self.taskDelegateInfo setObject:delegate forKey:@(task.taskIdentifier)];
    }
}

- (void)removeDelegateForTask:(NSURLSessionTask *)task
{
    NSParameterAssert(task);
    
    @synchronized (self)
    {
        [self.taskDelegateInfo removeObjectForKey:@(task.taskIdentifier)];
    }
}

- (NSString *)downlaodPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    path = [path stringByAppendingPathComponent:@"fs_test"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

@end
