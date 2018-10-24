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

@end

@implementation FSDownloadTaskManager

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
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        configuration.timeoutIntervalForRequest = 20;
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        queue.maxConcurrentOperationCount = 5;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
        
        self.session = session;
    }
    return self;
}


@end
