//
//  FSDLManager.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/12.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDLManager : NSObject

+ (instancetype)shareManager;

- (void)downloadUrl:(NSURL *)url;

@end
