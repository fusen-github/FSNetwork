//
//  FSController04.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController04.h"

@interface FSController04 ()

@end

@implementation FSController04

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSURLSession *session1 = [[NSURLSession alloc] init];
    
    NSLog(@"%@",session1);
    
    NSURLSession *session2 = [NSURLSession sharedSession];
    
    NSLog(@"%@",session2);
    
    NSURLSession *session3 = [NSURLSession sharedSession];
    
    NSLog(@"%@",session3);
}

@end
