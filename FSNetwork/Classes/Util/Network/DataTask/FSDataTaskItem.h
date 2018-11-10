//
//  FSDataTaskItem.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#ifndef FSDataTaskItem_h
#define FSDataTaskItem_h

typedef NS_ENUM(NSInteger, FSDataTaskStatus){
    
    FSDataTaskStatusError           = -1,
    FSDataTaskStatusDefault         = 0,
    FSDataTaskStatusWaiting         = 1,
    FSDataTaskStatusDownloading     = 2,
    FSDataTaskStatusSuspended       = 3,
    FSDataTaskStatusCompletion      = 4,
};

@protocol FSDataTaskItem <NSObject>

@property (nonatomic, strong) NSURL *downloadUrl;

/**
 保存下载文件的绝对路径(包括文件名)
 */
@property (nonatomic, strong) NSString *targetPath;

/**
 下载状态
 */
@property (nonatomic, assign) FSDataTaskStatus status;

@end


#endif /* FSDataTaskItem_h */
