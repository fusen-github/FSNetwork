//
//  FSDownloadTaskDownloader.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/23.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDownloadTaskDownloader.h"

static NSString * const kResumeDataPathExtension = @"_resumeData.plist";

@interface FSDownloadTaskDownloader ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, assign) int64_t didRecivedBytes;

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

/*
 resumeData的本质是一个.plist文件转成的NSData对象。记录着下载的相关信息
 转成字典后的样式:
 {
 NSURLSessionDownloadURL = "http://dl_dir.qq.com/invc/tt/QQBrowser_1.5.0.2311.dmg";
 NSURLSessionResumeBytesReceived = 4336344;
 NSURLSessionResumeCurrentRequest = <data_fs1>;
 NSURLSessionResumeInfoTempFileName = "CFNetworkDownload_TWYDm3.tmp";
 NSURLSessionResumeInfoVersion = 4;
 NSURLSessionResumeOriginalRequest = <data_fs2>;
 NSURLSessionResumeServerDownloadDate = "Wed, 11 Jul 2012 07:42:38 GMT";
 }
 */

- (void)resume
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.timeoutIntervalForRequest = 20;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    queue.maxConcurrentOperationCount = 5;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    
    self.session = session;
    
    NSString *path = [self.targetPath stringByAppendingString:kResumeDataPathExtension];
    
    NSData *resumeData = [self resumeDataAtPath:path];
    
    NSURLSessionDownloadTask *downloadTask = nil;
    
    if (resumeData.length)
    {
        NSDictionary *resumeDict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        NSString *fileName = [resumeDict objectForKey:@"NSURLSessionResumeInfoTempFileName"];
        
        unsigned long long receivedSize = [[resumeDict objectForKey:@"NSURLSessionResumeBytesReceived"] unsignedLongLongValue];
        
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL exist = [fileManager fileExistsAtPath:path];
        
        unsigned long long size = [self fileSizeAtPath:path];
        
        if (exist && receivedSize == size)
        {
            downloadTask = [session downloadTaskWithResumeData:resumeData];
        }
        else
        {
            downloadTask = [session downloadTaskWithURL:self.url];
        }
    }
    else
    {
        downloadTask = [session downloadTaskWithURL:self.url];
    }
    
    self.downloadTask = downloadTask;
    
    [downloadTask resume];
}

- (void)invalidateAndCancel
{
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
       
    }];
}


/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
//- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
//{
//    NSLog(@"%s",__func__);
//
//    NSLog(@"error1:%@",error);
//}



/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (error && error.code == NSURLErrorCancelled && error.userInfo.count)
    {
        NSData *data = nil;
        
        if ([error.userInfo.allKeys containsObject:NSURLSessionDownloadTaskResumeData])
        {
            data = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            
            NSString *path = [self.targetPath stringByAppendingString:kResumeDataPathExtension];
            
            [data writeToFile:path atomically:YES];
            
            NSLog(@"写了");
        }
    }
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
    self.didRecivedBytes += bytesWritten;
    
    NSLog(@"下载了: %lld",self.didRecivedBytes);
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
}


- (NSData *)resumeDataAtPath:(NSString *)path
{
    NSData *data = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        data = [NSData dataWithContentsOfFile:path];
    }
    
    return data;
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
