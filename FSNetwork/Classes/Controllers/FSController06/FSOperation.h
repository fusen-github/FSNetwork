//
//  FSOperation.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/12.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSOperation : NSOperation

- (instancetype)initWithUrl:(NSURL *)url targetPath:(NSString *)path session:(NSURLSession *)session;

@end
