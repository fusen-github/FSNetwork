//
//  FSFileItem.h
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDataTaskItem.h"


@interface FSFileItem : NSObject<FSDataTaskItem>

@property (nonatomic, assign) float progress;

@property (nonatomic, copy) NSString *title;

@end
