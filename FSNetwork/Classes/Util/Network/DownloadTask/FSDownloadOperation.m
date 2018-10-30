//
//  FSDownloadOperation.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/24.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDownloadOperation.h"

@interface FSDownloadOperation ()

@property (nonatomic, strong) FSDownloadTaskItem *item;

@end

@implementation FSDownloadOperation

- (instancetype)initWithTaskItem:(FSDownloadTaskItem *)item
{
    if (self = [super init])
    {
        self.item = item;
    }
    return self;
}

- (void)main
{
    if ([self isCancelled]) {
        
        return;
    }
    
    /// do something
    
    while (!self.stoped)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)cancel
{
    /// 取消前的处理
    
    [super cancel];
}



@end
