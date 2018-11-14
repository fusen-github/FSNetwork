//
//  FSDLManager07.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/13.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDLManager07.h"
#import "FSDataTaskItem.h"


@interface FSDLObject : NSObject

@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

@property (nonatomic, weak) id<FSDataTaskItem> item;

@property (nonatomic, assign) unsigned long long totalContentLength;

@property (nonatomic, assign) unsigned long long receivedContentLength;

@property (nonatomic, strong) NSOutputStream *stream;

@end

@implementation FSDLObject


@end

@interface FSDLManager07 ()<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableDictionary *taskItemInfo;

@property (nonatomic, strong) NSArray *downloadList;

@end

@implementation FSDLManager07

- (NSMutableDictionary *)taskItemInfo
{
    if (_taskItemInfo == nil)
    {
        _taskItemInfo = [NSMutableDictionary dictionary];
    }
    return _taskItemInfo;
}

+ (instancetype)shareManager
{
    static FSDLManager07 *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FSDLManager07 alloc] init];
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

- (void)startDownloadWithItem:(id<FSDataTaskItem>)item
{
    NSURL *url = [item downloadUrl];
    
    if (!url.absoluteString.length) return;
    
    id tmpObj = [self.taskItemInfo objectForKey:url.absoluteString];
    
    if (tmpObj) return;
    
    NSString *targetPath = [item targetPath];
    
    if (!targetPath.length) return;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    unsigned long long length = [self fileSizeAtPath:targetPath];
    
    NSString *range = [NSString stringWithFormat:@"bytes=%llu-",length];
    
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    
    FSDLObject *obj = [[FSDLObject alloc] init];
    
    obj.dataTask = dataTask;
    
    obj.item = item;
    
    obj.receivedContentLength = length;
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.downloadList];
    
    [tmpArray addObject:item];
    
    self.downloadList = [tmpArray copy];
    
    [self.taskItemInfo setObject:obj forKey:url.absoluteString];
    
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
    FSDLObject *obj = [self.taskItemInfo objectForKey:dataTask.originalRequest.URL.absoluteString];
    
    NSHTTPURLResponse *tmpResponse = (NSHTTPURLResponse *)response;
    
    NSUInteger statusCode = tmpResponse.statusCode;
    
    NSURL *pathUrl = [NSURL fileURLWithPath:[obj.item targetPath]];
    
    obj.stream = [NSOutputStream outputStreamWithURL:pathUrl append:YES];
    
    [obj.stream open];
    
    if (statusCode == 200)
    {
        /* 成功处理请求 */
        obj.totalContentLength = dataTask.countOfBytesExpectedToReceive;
        
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
            obj.totalContentLength = obj.receivedContentLength + tmpResponse.expectedContentLength;
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
        
//        if ([contentRange hasPrefix:@"bytes"])
//        {
//            NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@" -/"];
//
//            NSArray *bytes = [contentRange componentsSeparatedByCharactersInSet:charset];
//
//            if ([bytes count] == 3)
//            {
//                self.totalContentLength = [[bytes objectAtIndex:2] longLongValue];
//
//                if (self.receivedContentLength == self.totalContentLength)
//                {
//                    flag = YES;
//
//                    [self downloadProgressOnMainThread:1.0];
//
//                    [self downloadFinishOnMainThread];
//                }
//            }
//        }
//
//        if (!flag)
//        {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:tmpResponse.allHeaderFields];
//
//            [dict setObject:self.targetPath forKey:FSDataTaskDownloadTargetPathKey];
//
//            [dict setObject:self.url forKey:FSDataTaskDownloadURLKey];
//
//            NSError *error = [NSError errorWithDomain:kFSDataTaskDomain
//                                                 code:statusCode
//                                             userInfo:dict];
//
//            [self downloadErrorOnMainThread:error];
//        }
//
//        if (completionHandler)
//        {
//            completionHandler(NSURLSessionResponseCancel);
//        }
    }
    else
    {
//        NSError *error = [NSError errorWithDomain:[self.url absoluteString]
//                                             code:statusCode
//                                         userInfo:tmpResponse.allHeaderFields];
//
//        [self downloadErrorOnMainThread:error];
        
        if (completionHandler)
        {
            completionHandler(NSURLSessionResponseCancel);
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    FSDLObject *obj = [self.taskItemInfo objectForKey:dataTask.originalRequest.URL.absoluteString];
    
    [obj.stream write:data.bytes maxLength:data.length];
    
    if ([self.delegate respondsToSelector:@selector(item:downloadProgress:)])
    {
        obj.receivedContentLength += data.length;
        
        float progress = (obj.receivedContentLength * 1.0) / (obj.totalContentLength * 1.0);
        
        [self.delegate item:obj.item downloadProgress:progress];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSURL *url = task.originalRequest.URL;
    
    NSLog(@"%@, %@",url.lastPathComponent, error);
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
