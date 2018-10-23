//
//  ViewController.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/22.
//  Copyright © 2018年 付森. All rights reserved.
//

/*
 网络小知识
 */


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(doRightAction03)];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSLog(@"%@",url);
    
    /*
     URL格式:
     协议 (+ 认证) + 主机名 + 端口号 + 绝对路径 + 查询字符串(?)
     */
    
    /*
     HTTP请求包含“请求行”、“请求头”、“请求体”三个部门组成
     
     */
    
}

- (void)doRightAction
{
    /// http://t.weather.sojson.com/api/weather/city/101030100
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSURL *url = [NSURL URLWithString:@"http://t.weather.sojson.com/api/weather/city/101030100"];
        
        NSError *error = nil;
        
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        
        if (error == nil && data)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            NSLog(@"%@",dict);
        }
        else
        {
            NSLog(@"error %@",error.localizedDescription);
        }
    });
}

/*
Any URL is composed of these two basic pieces.  The full URL would be the concatenation of [myURL scheme], ':', [myURL resourceSpecifier]
 
@property (nullable, readonly, copy) NSString *scheme;
@property (nullable, readonly, copy) NSString *resourceSpecifier;

If the URL conforms to rfc 1808 (the most common form of URL), the following accessors will return the various components; otherwise they return nil.  The litmus test for conformance is as recommended in RFC 1808 - whether the first two characters of resourceSpecifier is @"//".  In all cases, they return the component's value after resolving the receiver against its base URL.
 
@property (nullable, readonly, copy) NSString *host;
@property (nullable, readonly, copy) NSNumber *port;
@property (nullable, readonly, copy) NSString *user;
@property (nullable, readonly, copy) NSString *password;
@property (nullable, readonly, copy) NSString *path;
@property (nullable, readonly, copy) NSString *fragment;
@property (nullable, readonly, copy) NSString *parameterString;
@property (nullable, readonly, copy) NSString *query;
@property (nullable, readonly, copy) NSString *relativePath; // The same as path if baseURL is nil
 */

- (void)doRightAction01
{
    /// 1、创建URL
    NSString *string = @"https://www.baidu.com/s?wd=fragment&rsv_spt=1&rsv_iqid=0x8876191b00036045&issp=1&f=8&rsv_bp=0&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_enter=1&rsv_sug2=0&inputT=471&rsv_sug4=539";
    
//    string = @"http://t.weather.sojson.com/api/weather/city/101030100";
    
    NSURL *url = [NSURL URLWithString:string];

    NSLog(@"scheme:%@",url.scheme);
    
    NSLog(@"resourceSpecifier:%@",url.resourceSpecifier);
    
    NSLog(@"host:%@",url.host);
    
    NSLog(@"port:%@",url.port);
    
    NSLog(@"user:%@",url.user);
    
    NSLog(@"password:%@",url.password);
    
    NSLog(@"path:%@",url.path);
    
    NSLog(@"fragment:%@",url.fragment);
    
    NSLog(@"parameterString:%@",url.parameterString);
    
    NSLog(@"query:%@",url.query);
    
    NSLog(@"relativePath:%@",url.relativePath);
    
    /// 2、创建 NSURLRequest
    NSURLResponse *response = nil;
    
    
}

- (void)doRightAction02
{
    NSURL *url = [NSURL URLWithString:@"http://t.weather.sojson.com/api/weather/city/101030100"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.timeoutInterval = 20;
    
    request.HTTPMethod = @"GET";
    
    NSHTTPURLResponse *response = nil;
    
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
    {
        NSLog(@"error: %@",error.localizedDescription);
        
        return;
    }
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSLog(@"URL: %@",response.URL);
        
        NSLog(@"MIMEType: %@",response.MIMEType);
        
        NSLog(@"textEncodingName:%@",response.textEncodingName);
        
        NSLog(@"expectedContentLength: %lld",response.expectedContentLength);
        
        NSLog(@"suggestedFilename:%@",response.suggestedFilename);
        
        /// statusCode = 200 代表成功
        NSLog(@"statusCode: %lu",response.statusCode);
        
        NSLog(@"allHeaderFields: %@",response.allHeaderFields);
    }
    
    id rst = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"rst = %@",rst);
}

- (void)doRightAction03
{
    NSURL *url = [NSURL URLWithString:@"http://t.weather.sojson.com/api/weather/city/101030100"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData * data, NSError *connectionError) {
        
        if (connectionError)
        {
            return;
        }
        
        id rst = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@",rst);
        
    }];
    
    
    
}



@end
