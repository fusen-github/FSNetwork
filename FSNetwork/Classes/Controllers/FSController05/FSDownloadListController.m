//
//  FSDownloadListController.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDownloadListController.h"
#import "FSFileDownloadTool.h"
#import "FSDownloadListCell.h"
#import "FSFileItem.h"



static NSString * const kTitleKey = @"title";

static NSString * const kDatasKey = @"datas";

@interface FSDownloadListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation FSDownloadListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.rowHeight = 50;
    
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.frame = self.view.bounds;
    
    [self.view addSubview:tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [FSFileDownloadTool shareInstance].delegate = (id<FSFileDownloadToolDelegate>)self;
    
    [self updateDataArray];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [FSFileDownloadTool shareInstance].delegate = nil;
}

- (void)updateDataArray
{
    /// 未完成的
    NSMutableArray *undoArray = [NSMutableArray array];
    
    NSMutableArray *doneArray = [NSMutableArray array];
    
    for (FSFileItem *item in [FSFileDownloadTool shareInstance].downloadList)
    {
        if (item.status == FSDataTaskStatusCompletion)
        {
            [doneArray addObject:item];
        }
        else
        {
            [undoArray addObject:item];
        }
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    if (undoArray.count)
    {
        NSMutableDictionary *dataInfo = [NSMutableDictionary dictionary];
        
        [dataInfo setObject:undoArray forKey:kDatasKey];
        
        [dataInfo setObject:@"下载中" forKey:kTitleKey];
        
        [dataArray addObject:dataInfo];
    }
    
    if (doneArray.count)
    {
        NSMutableDictionary *dataInfo = [NSMutableDictionary dictionary];
        
        [dataInfo setObject:doneArray forKey:kDatasKey];
        
        [dataInfo setObject:@"已完成" forKey:kTitleKey];
        
        [dataArray addObject:dataInfo];
    }
    
    self.dataArray = dataArray;
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [self.dataArray objectAtIndex:section];
    
    NSArray *datas = [dict objectForKey:kDatasKey];
    
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellId = @"download_list_cell_id";
    
    FSDownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (cell == nil)
    {
        cell = [[FSDownloadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
    
    NSArray *datas = [dict objectForKey:kDatasKey];
    
    FSFileItem *item = [datas objectAtIndex:indexPath.row];
    
    cell.item = item;
    
    return cell;
}

- (void)itemDidFinished:(FSFileItem *)item
{
    NSLog(@"%s",__func__);
}

- (void)item:(FSFileItem *)item didError:(NSError *)error
{
    NSLog(@"%s",__func__);
    
    NSLog(@"%@",error);
}

- (void)item:(FSFileItem *)item downloadProgress:(float)progress
{
    item.progress = progress;
    
    NSDictionary *dict = [self.dataArray objectAtIndex:0];
    
    NSArray *datas = [dict objectForKey:kDatasKey];
    
    NSInteger index = [datas indexOfObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    FSDownloadListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell updateProgrss:progress];
}


@end
