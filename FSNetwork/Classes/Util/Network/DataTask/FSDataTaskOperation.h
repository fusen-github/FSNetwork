//
//  FSDataTaskOperation.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDataTaskItem.h"


@class FSDataTaskOperation;
@protocol FSDataTaskOperationDelegate <NSObject>

@optional
- (void)operationDidFinished:(FSDataTaskOperation *)operation;

- (void)operation:(FSDataTaskOperation *)operation didError:(NSError *)error;

- (void)operation:(FSDataTaskOperation *)operation downloadProgress:(float)progress;

@end

@interface FSDataTaskOperation : NSOperation

@property (nonatomic, strong, readonly) id<FSDataTaskItem> item;

- (instancetype)initWithItem:(id<FSDataTaskItem>)item delegate:(id<FSDataTaskOperationDelegate>)delegate;

@end
