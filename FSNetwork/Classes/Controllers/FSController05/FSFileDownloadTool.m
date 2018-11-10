//
//  FSFileDownloadTool.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSFileDownloadTool.h"
#import "FSFileItem.h"
#import "FSDataTaskManager.h"


@interface FSFileDownloadTool ()<FSDataTaskManagerOberser>

@property (nonatomic, strong) NSArray *downloadList;

@end

@implementation FSFileDownloadTool

+ (instancetype)shareInstance
{
    static FSFileDownloadTool *tool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[FSFileDownloadTool alloc] init];
    });
    
    return tool;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [[FSDataTaskManager shareManager] addObserver:self];
    }
    return self;
}

- (void)insertItem:(FSFileItem *)item
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.downloadList];
    
    [tmpArray addObject:item];
    
    self.downloadList = tmpArray;
}

- (void)startDownloadItem:(FSFileItem *)item
{
    [self insertItem:item];
    
    [[FSDataTaskManager shareManager] resumeDownloadItem:item];
}

- (void)itemDidFinished:(id<FSDataTaskItem>)item
{
    if ([self.delegate respondsToSelector:@selector(itemDidFinished:)])
    {
        [self.delegate itemDidFinished:item];
    }
}

- (void)item:(id<FSDataTaskItem>)item didError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(item:didError:)])
    {
        [self.delegate item:item didError:error];
    }
}

- (void)item:(id<FSDataTaskItem>)item downloadProgress:(float)progress
{
    if ([self.delegate respondsToSelector:@selector(item:downloadProgress:)])
    {
        [self.delegate item:item downloadProgress:progress];
    }
}



@end
