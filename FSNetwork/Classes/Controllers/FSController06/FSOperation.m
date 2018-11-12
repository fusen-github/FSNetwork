//
//  FSOperation.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/12.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSOperation.h"

@interface FSOperation ()

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation FSOperation

- (instancetype)initWithUrl:(NSURL *)url targetPath:(NSString *)path session:(NSURLSession *)session
{
    if (self = [super init])
    {
        self.url = url;
        
        self.session = session;
        
        self.path = path;
    }
    return self;
}

- (void)main
{
    if (self.isCancelled) return;
    
    
}

@end
