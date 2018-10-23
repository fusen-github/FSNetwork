//
//  FSDataTaskDownloader.h
//  FSNetwork
//
//  Created by 付森 on 2018/10/23.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSDataTaskDownloader;
@protocol FSDataTaskDownloaderDelegate <NSObject>

@optional
- (void)downloaderDidFinished:(FSDataTaskDownloader *)downloader;

- (void)downloader:(FSDataTaskDownloader *)downloader didError:(NSError *)error;

- (void)downloader:(FSDataTaskDownloader *)downloader downloadProgress:(float)progress;

@end

@interface FSDataTaskDownloader : NSObject

+ (FSDataTaskDownloader *)downloaderWithURL:(NSURL *)URL targetPath:(NSString *)targetPath delegate:(id<FSDataTaskDownloaderDelegate>)delegate;

@property (nonatomic, strong, readonly) NSURL *url;

@property (nonatomic, strong, readonly) NSString *targetPath;

@property (nonatomic, weak, readonly) id<FSDataTaskDownloaderDelegate> delegate;

/**
 恢复下载
 */
- (void)resume;

/**
 取消下载，并设置下载器无效。
 在下载完成、或下载出错时调用，否则下载器无法释放
 */
- (void)invalidateAndCancel;

@end
