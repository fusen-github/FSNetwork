//
//  FSDownloadTaskDownloader.h
//  FSNetwork
//
//  Created by 付森 on 2018/10/23.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 利用 NSURLSessionDownloadTask 类实现下载
 */

@protocol FSDownloadTaskDownloaderDelegate <NSObject>

@optional


@end

@interface FSDownloadTaskDownloader : NSObject

+ (FSDownloadTaskDownloader *)downloaderWithURL:(NSURL *)URL targetPath:(NSString *)targetPath delegate:(id<FSDownloadTaskDownloaderDelegate>)delegate;

@property (nonatomic, strong, readonly) NSURL *url;

@property (nonatomic, strong, readonly) NSString *targetPath;

@property (nonatomic, weak, readonly) id<FSDownloadTaskDownloaderDelegate> delegate;

- (void)resume;

- (void)invalidateAndCancel;

@end
