//
//  FSFileDownloadTool.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSFileItem;
@protocol FSFileDownloadToolDelegate <NSObject>

@optional
- (void)itemDidFinished:(FSFileItem *)item;

- (void)item:(FSFileItem *)item didError:(NSError *)error;

- (void)item:(FSFileItem *)item downloadProgress:(float)progress;

@end

@interface FSFileDownloadTool : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, weak) id<FSFileDownloadToolDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray<FSFileItem *> *downloadList;

- (void)startDownloadItem:(FSFileItem *)item;

@end
