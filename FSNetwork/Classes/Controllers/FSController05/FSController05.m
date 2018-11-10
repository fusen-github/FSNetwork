//
//  FSController05.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController05.h"
#import "FSTaskListController.h"
#import "FSDownloadListController.h"

@interface FSController05 ()

@property (nonatomic, weak) FSTaskListController *task;

@property (nonatomic, weak) FSDownloadListController *download;

@end

@implementation FSController05

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FSTaskListController *task = [[FSTaskListController alloc] init];
    
    self.task = task;
    
    [self addChildViewController:task];
    
    FSDownloadListController *download = [[FSDownloadListController alloc] init];
    
    self.download = download;
    
    [self addChildViewController:download];
    
    NSArray *itmes = @[@"任务列表",@"下载列表"];
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:itmes];
    
    [control addTarget:self action:@selector(toggleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    control.selectedSegmentIndex = 0;
    
    [self toggleSegmentedControl:control];
    
    self.navigationItem.titleView = control;
}

- (void)toggleSegmentedControl:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex == 0)
    {
        [self.download.view removeFromSuperview];
        
        [self.view addSubview:self.task.view];
    }
    else
    {
        [self.task.view removeFromSuperview];
        
        [self.view addSubview:self.download.view];
    }
}


@end
