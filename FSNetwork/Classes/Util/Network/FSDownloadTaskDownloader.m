//
//  FSDownloadTaskDownloader.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/23.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDownloadTaskDownloader.h"

@interface FSDownloadTaskDownloader ()<NSURLSessionDelegate>

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

@implementation FSDownloadTaskDownloader

+ (FSDownloadTaskDownloader *)downloaderWithURL:(NSURL *)URL targetPath:(NSString *)targetPath delegate:(id<FSDownloadTaskDownloaderDelegate>)delegate
{
    FSDownloadTaskDownloader *downloader = [[FSDownloadTaskDownloader alloc] init];
    
    downloader->_url = URL;
    
    downloader->_targetPath = targetPath;
    
    downloader->_delegate = delegate;
    
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
        NSString *offset = [NSString stringWithFormat:@"bytes=%llu",self.receivedContentLength];
        
        [request setValue:offset forHTTPHeaderField:@"Range"];
    }
    else
    {
//        NSFileManager *manager = [NSFileManager defaultManager];
//
//        [manager removeItemAtPath:self.targetPath error:nil];
        
        NSLog(@"文件不存在，或者文件大小为0");
    }
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    
    [downloadTask resume];
}

- (void)cancel
{
    if (self.session)
    {
        [self.session invalidateAndCancel];
        
        self.session = nil;
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"%s",__func__);
}

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%s",__func__);
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"%s",__func__);
    
    NSData *data = nil;
    
    NSFileHandle *fileHandle = self.fileHandle;
    
    if (fileHandle == nil)
    {
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.targetPath];
        
        self.fileHandle = fileHandle;
    }
    
    [fileHandle seekToEndOfFile];
    
//    [fileHandle ]
    
//    NSStream
}


/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%s",__func__);
    
//    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//        <#code#>
//    }]
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
    NSLog(@"FSDownloader dealloc");
    
    self.session = nil;
}

@end
