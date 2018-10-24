//
//  AppDelegate.h
//  FSNetwork
//
//  Created by 付森 on 2018/10/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSDownloadTaskDownloader.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FSDownloadTaskDownloader *loader;

@end

