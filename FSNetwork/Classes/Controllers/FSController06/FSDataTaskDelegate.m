//
//  FSDataTaskDelegate.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/12.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDataTaskDelegate.h"

@interface FSDataTaskDelegate ()

@property (nonatomic, copy) NSString *targetPath;

@property (nonatomic, strong) NSOutputStream *stream;

@property (nonatomic, assign) unsigned long long receivedContentLength;

@property (nonatomic, assign) unsigned long long totalContentLength;

@end

@implementation FSDataTaskDelegate

- (instancetype)initWithDataTask:(NSURLSessionDataTask *)dataTask
                      targetPath:(NSString *)path
                  receivedLength:(unsigned long long)receivedLength
{
    if (self = [super init])
    {
        self->_dataTask = dataTask;
        
        self.targetPath = path;
        
        self.receivedContentLength = receivedLength;
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSHTTPURLResponse *tmpResponse = (id)response;
    
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
                    
//                    [self downloadProgressOnMainThread:1.0];
//
//                    [self downloadFinishOnMainThread];
                }
            }
        }
        
        if (!flag)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:tmpResponse.allHeaderFields];
            
//            [dict setObject:self.targetPath forKey:FSDataTaskDownloadTargetPathKey];
//
//            [dict setObject:self.url forKey:FSDataTaskDownloadURLKey];
//
//            NSError *error = [NSError errorWithDomain:kFSDataTaskDomain
//                                                 code:statusCode
//                                             userInfo:dict];
//
//            [self downloadErrorOnMainThread:error];
        }
        
        if (completionHandler)
        {
            completionHandler(NSURLSessionResponseCancel);
        }
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
    
    NSURL *url = [NSURL fileURLWithPath:self.targetPath];
    
    NSOutputStream *stream = [[NSOutputStream alloc] initWithURL:url append:YES];
    
    self.stream = stream;
    
    [stream open];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.stream write:data.bytes maxLength:data.length];
    
    self.receivedContentLength += data.length;
    
    float progress = (self.receivedContentLength * 1.0) / (self.totalContentLength * 1.0);

    NSLog(@"taskId = %lu, progress = %.2f%%, %@", dataTask.taskIdentifier, progress * 100, [NSThread currentThread]);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self.stream close];
}

@end
