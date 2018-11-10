//
//  FSTaskListController.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/9.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSTaskListController.h"
#import "FSFileItem.h"
#import "FSFileDownloadTool.h"
#import "FSTaskListCell.h"


@interface FSTaskListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation FSTaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    NSArray *array = @[@"1111.zip",@"2222.zip",@"3333.zip",@"4444.zip",
                       @"aaaa.zip",@"bbbb.zip",@"cccc.zip",@"dddd.zip",
                       @"eeee.zip",@"ffff.zip",@"gggg.zip",@"hhhh.zip"];
    
    NSString *targetPath = [self targetPath];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSString *urlString = [kBaseUrl stringByAppendingPathComponent:@"download"];
    
    for (NSString *name in array)
    {
        FSFileItem *item = [[FSFileItem alloc] init];
        
        item.title = name;
        
        NSURL *url = [NSURL URLWithString:[urlString stringByAppendingPathComponent:name]];
        
        item.downloadUrl = url;
        
        item.targetPath = [targetPath stringByAppendingPathComponent:name];
        
        [dataArray addObject:item];
    }
    
    self.dataArray = dataArray;
    
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.frame = self.view.bounds;
    
    [self.view addSubview:tableView];
    
}

- (NSString *)targetPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    path = [path stringByAppendingPathComponent:@"fs_download"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:path])
    {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellId = @"task_list_id";
    
    FSTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[FSTaskListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = (id<FSTaskListCellDelegate>)self;
    }
    
    FSFileItem *item = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell updateCell:item];
    
    return cell;
}



#pragma mark FSTaskListCellDelegate
- (void)touchDownloadWithCell:(FSTaskListCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSLog(@"row = %ld",indexPath.row);
    
    FSFileItem *item = [self.dataArray objectAtIndex:indexPath.row];
 
    NSLog(@"%@",item.downloadUrl);
    
    [[FSFileDownloadTool shareInstance] startDownloadItem:item];
}

@end
