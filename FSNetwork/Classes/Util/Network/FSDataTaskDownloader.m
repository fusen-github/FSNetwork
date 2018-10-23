//
//  FSDataTaskDownloader.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/23.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDataTaskDownloader.h"

@interface FSDataTaskDownloader ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;

/**
 已经接收到的文件大小 单位：bytes
 */
@property (nonatomic, assign) unsigned long long receivedContentLength;

/**
 服务器端总文件大小 单位：bytes
 */
@property (nonatomic, assign) unsigned long long totalContentLength;

@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation FSDataTaskDownloader

+ (FSDataTaskDownloader *)downloaderWithURL:(NSURL *)URL targetPath:(NSString *)targetPath delegate:(id)delegate
{
    FSDataTaskDownloader *downloader = [[FSDataTaskDownloader alloc] init];
    
    downloader->_delegate = delegate;
    
    downloader->_url = URL;
    
    downloader->_targetPath = targetPath;
    
    NSString *path = [targetPath stringByDeletingLastPathComponent];
    
    BOOL isDir = NO;
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    if (!exist || !isDir)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return downloader;
}

- (void)resume
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.timeoutIntervalForRequest = 20;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    queue.maxConcurrentOperationCount = 5;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    
    self.session = session;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    
    self.receivedContentLength = [self fileSizeAtPath:self.targetPath];
    
    if (self.receivedContentLength > 0)
    {
        NSString *offset = [NSString stringWithFormat:@"bytes=%llu-",self.receivedContentLength];
        
        [request setValue:offset forHTTPHeaderField:@"Range"];
    }
    else
    {
        /// 文件不存在，或者文件大小为0
        NSFileManager *manager = [NSFileManager defaultManager];

        [manager removeItemAtPath:self.targetPath error:nil];
        
        BOOL suc = [manager createFileAtPath:self.targetPath contents:nil attributes:nil];
        
        if (!suc)
        {
            return;
        }
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    [dataTask resume];
}

- (void)invalidateAndCancel
{
    if (self.session)
    {
        [self.session invalidateAndCancel];
        
        self.session = nil;
    }
}

#pragma mark NSURLSessionDelegate
/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    if (error && error.code != NSURLErrorCancelled)
    {
        [self downloadErrorOnMainThread:error];
    }
}

#pragma mark NSURLSessionTaskDelegate
/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (error == nil)
    {
        [self downloadFinishOnMainThread];
    }
    else
    {
        if (error.code == NSURLErrorCancelled)
        {
            return;
        }
        
        [self downloadErrorOnMainThread:error];
    }
}


#pragma mark NSURLSessionDataDelegate
/* The task has received a response and no further messages will be
 * received until the completion block is called. The disposition
 * allows you to cancel a request or to turn a data task into a
 * download task. This delegate message is optional - if you do not
 * implement it, you can get the response as a property of the task.
 *
 * This method will not be called for background upload tasks (which cannot be converted to download tasks).
 */
- (void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 didReceiveResponse:(NSURLResponse *)response
  completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSHTTPURLResponse *tmpResponse = (NSHTTPURLResponse *)response;

    NSUInteger statusCode = tmpResponse.statusCode;

    if (statusCode == 200)
    {
        /* 成功处理请求 */
        self.totalContentLength = dataTask.countOfBytesExpectedToReceive;
        
        if (completionHandler)
        {
            completionHandler(NSURLSessionResponseAllow);
        }
    }
    else if (statusCode == 206) ///
    {
        /* 成功抓取到资源的部分数据，一般是设置了请求头的Range */
        if (tmpResponse.expectedContentLength > 0)
        {
            self.totalContentLength = self.receivedContentLength + tmpResponse.expectedContentLength;
        }
        
        if (completionHandler)
        {
            completionHandler(NSURLSessionResponseAllow);
        }
    }
    else if (statusCode == 416)
    {
        /* dataTask.currentRequest.allHTTPHeaderFields中的Range字段设置错误. */

        NSString *contentRange = [tmpResponse.allHeaderFields valueForKey:@"Content-Range"];

        BOOL flag = NO;
        
        if ([contentRange hasPrefix:@"bytes"])
        {
            NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@" -/"];
            
            NSArray *bytes = [contentRange componentsSeparatedByCharactersInSet:charset];
            
            if ([bytes count] == 3)
            {
                self.totalContentLength = [[bytes objectAtIndex:2] longLongValue];
                
                if (self.receivedContentLength == self.totalContentLength)
                {
                    flag = YES;
                    
                    [self downloadProgressOnMainThread:1.0];
                    
                    [self downloadFinishOnMainThread];
                }
            }
        }
        
        if (!flag)
        {
            NSError *error = [NSError errorWithDomain:[self.url absoluteString]
                                                 code:statusCode
                                             userInfo:tmpResponse.allHeaderFields];
            
            [self downloadErrorOnMainThread:error];
        }
        
        if (completionHandler)
        {
            completionHandler(NSURLSessionResponseCancel);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:[self.url absoluteString]
                                             code:statusCode
                                         userInfo:tmpResponse.allHeaderFields];
        
        [self downloadErrorOnMainThread:error];
        
        if (completionHandler)
        {
            completionHandler(NSURLSessionResponseCancel);
        }
    }
}


/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.targetPath];
    
    [fileHandle seekToEndOfFile];
    
    [fileHandle writeData:data];
    
    [fileHandle closeFile];
    
    self.receivedContentLength += data.length;
    
    float progress = (self.receivedContentLength * 1.0) / (self.totalContentLength * 1.0);
    
    [self downloadProgressOnMainThread:progress];
}

- (void)downloadFinishOnMainThread
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if ([self.delegate respondsToSelector:@selector(downloaderDidFinished:)])
        {
            [self.delegate downloaderDidFinished:self];
        }
    });
}

- (void)downloadErrorOnMainThread:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if ([self.delegate respondsToSelector:@selector(downloader:didError:)])
        {
            [self.delegate downloader:self didError:error];
        }
        
    });
}

- (void)downloadProgressOnMainThread:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if ([self.delegate respondsToSelector:@selector(downloader:downloadProgress:)])
        {
            [self.delegate downloader:self downloadProgress:progress];
        }
    });
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

- (void)dealloc
{
    NSLog(@"FSDataTaskDownloader dealloc");
}

@end
