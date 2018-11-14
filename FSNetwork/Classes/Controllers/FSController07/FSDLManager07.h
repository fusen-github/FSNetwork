//
//  FSDLManager07.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/13.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDataTaskItem.h"


@protocol FSDLManager07Delegate <NSObject>

@optional
- (void)itemDidFinished:(id<FSDataTaskItem>)item;

- (void)item:(id<FSDataTaskItem>)item didError:(NSError *)error;

- (void)item:(id<FSDataTaskItem>)item downloadProgress:(float)progress;

@end

@interface FSDLManager07 : NSObject

+ (instancetype)shareManager;

@property (nonatomic, weak) id<FSDLManager07Delegate> delegate;

@property (nonatomic, strong, readonly) NSArray *downloadList;

- (void)startDownloadWithItem:(id<FSDataTaskItem>)item;

@end
