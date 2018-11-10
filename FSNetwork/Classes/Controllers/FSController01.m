//
//  FSController01.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController01.h"

@interface FSController01 ()<NSURLSessionDelegate>

@end

@implementation FSController01

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(doRightAction)];
    
}

- (void)doRightAction
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    
    configuration.timeoutIntervalForRequest = 10;
    
    configuration.HTTPMaximumConnectionsPerHost = 5;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    
    /* 拼接服务器地址 */
    NSString *urlString = [kBaseUrl stringByAppendingPathComponent:@"path1/demo"];
    
    /* 模拟一个不存在的资源路径 */
//    urlString = @"http://t.weather.sojson.com/api/weather/city/101030100_fs";

//    urlString = @"http://t.weather.sojson.com/api/weather/city/101030100";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@",request.allHTTPHeaderFields);
        
        if (data && error == nil)
        {
            id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"%@",json);
        }
        
        NSLog(@"回调线程: %@",[NSThread currentThread]);
    }];
    
    NSLog(@"%@",[NSThread currentThread]);
    
    [dataTask resume];
    
    NSLog(@"end,,,");
}



@end
