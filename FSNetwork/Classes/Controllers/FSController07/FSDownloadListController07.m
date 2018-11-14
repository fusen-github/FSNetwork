//
//  FSDownloadListController07.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/13.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSDownloadListController07.h"
#import "FSDownloadListCell07.h"
#import "FSFileItem.h"
#import "FSDLManager07.h"



static NSString * const kTitleKey = @"title";

static NSString * const kDatasKey = @"datas";

@interface FSDownloadListController07 ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation FSDownloadListController07

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
    
//    [FSFileDownloadTool shareInstance].delegate = (id<FSFileDownloadToolDelegate>)self;
    
    [FSDLManager07 shareManager].delegate = (id<FSDLManager07Delegate>)self;
    
    [self updateDataArray];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [FSFileDownloadTool shareInstance].delegate = nil;
    
    [FSDLManager07 shareManager].delegate = nil;
}

- (void)updateDataArray
{
    /// 未完成的
    NSMutableArray *undoArray = [NSMutableArray array];
    
    NSMutableArray *doneArray = [NSMutableArray array];
    
    for (FSFileItem *item in [FSDLManager07 shareManager].downloadList)
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
    
    FSDownloadListCell07 *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (cell == nil)
    {
        cell = [[FSDownloadListCell07 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
    
    NSArray *datas = [dict objectForKey:kDatasKey];
    
    FSFileItem *item = [datas objectAtIndex:indexPath.row];
    
    cell.item = item;
    
    return cell;
}

- (void)itemDidFinished:(id<FSDataTaskItem>)item
{
    
}

- (void)item:(id<FSDataTaskItem>)item didError:(NSError *)error
{
    
}

- (void)item:(id<FSDataTaskItem>)item downloadProgress:(float)progress
{
    NSDictionary *dict = [self.dataArray objectAtIndex:0];
    
    NSArray *datas = [dict objectForKey:kDatasKey];
    
    NSInteger index = [datas indexOfObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        FSDownloadListCell07 *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [cell updateProgrss:progress];
        
    });
}

@end
