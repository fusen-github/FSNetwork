//
//  FSController06.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController06.h"
#import "FSDLManager.h"


@interface FSController06 ()

@end

@implementation FSController06

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    FSDLManager *manager = [FSDLManager shareManager];
    
    NSArray *array = @[@"1111.zip",@"2222.zip",@"3333.zip",@"4444.zip"];
    
//    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSString *urlString = [kBaseUrl stringByAppendingPathComponent:@"download"];
    
    for (NSString *name in array)
    {
        NSURL *url = [NSURL URLWithString:[urlString stringByAppendingPathComponent:name]];
        
        [manager downloadUrl:url];
    }
}



@end
