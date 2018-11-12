//
//  FSDataTaskDelegate.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/12.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDataTaskDelegate : NSObject<NSURLSessionDataDelegate>

@property (nonatomic, strong, readonly) NSURLSessionDataTask *dataTask;

- (instancetype)initWithDataTask:(NSURLSessionDataTask *)dataTask
                      targetPath:(NSString *)path
                  receivedLength:(unsigned long long)receivedLength;

@end
