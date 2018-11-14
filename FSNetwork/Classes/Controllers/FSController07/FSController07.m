//
//  FSController07.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/12.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController07.h"
#import "FSTaskListController07.h"
#import "FSDownloadListController07.h"


@interface FSController07 ()

@property (nonatomic, weak) FSTaskListController07 *task;

@property (nonatomic, weak) FSDownloadListController07 *download;

@end

@implementation FSController07

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FSTaskListController07 *task = [[FSTaskListController07 alloc] init];
    
    self.task = task;
    
    [self addChildViewController:task];
    
    FSDownloadListController07 *download = [[FSDownloadListController07 alloc] init];
    
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
