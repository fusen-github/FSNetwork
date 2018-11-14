//
//  FSTaskListController07.m
//  FSNetwork
//
//  Created by 付森 on 2018/11/13.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSTaskListController07.h"
#import "FSFileItem.h"
#import "FSTaskListCell07.h"
#import "FSDLManager07.h"



@interface FSTaskListController07 ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation FSTaskListController07

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    //    [self prepareDataArray_1];
    
    [self prepareDataArray_2];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.frame = self.view.bounds;
    
    [self.view addSubview:tableView];
    
}

- (void)prepareDataArray_2
{
    NSArray *array = @[@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.2.dmg",
                       @"https://qd.myapp.com/myapp/qqteam/pcqq/QQ9.0.7_1.exe",
                       @"https://qd.myapp.com/myapp/qqteam/AndroidQQi/qq_6.0.1.6600_android_r25029_GuanWang_537057608_release.apk",
                       @"https://qd.myapp.com/myapp/qqteam/Androidlite/qqlite_3.7.1.704_android_r110206_GuanWang_537057973_release_10000484.apk",];
    
    NSString *targetPath = [self targetPath];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (NSString *urlString in array)
    {
        FSFileItem *item = [[FSFileItem alloc] init];
        
        item.title = [urlString lastPathComponent];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        item.downloadUrl = url;
        
        item.targetPath = [targetPath stringByAppendingPathComponent:[urlString lastPathComponent]];
        
        [dataArray addObject:item];
    }
    
    self.dataArray = dataArray;
    
    
}

// http://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.2.dmg
// https://qd.myapp.com/myapp/qqteam/pcqq/QQ9.0.7_1.exe
// https://qd.myapp.com/myapp/qqteam/AndroidQQi/qq_6.0.1.6600_android_r25029_GuanWang_537057608_release.apk

- (void)prepareDataArray_1
{
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
    
    FSTaskListCell07 *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[FSTaskListCell07 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = (id<FSTaskListCell07Delegate>)self;
    }
    
    FSFileItem *item = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell updateCell:item];
    
    return cell;
}


#pragma mark FSTaskListCell07Delegate
- (void)touchDownloadWithCell:(FSTaskListCell07 *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSLog(@"row = %ld",indexPath.row);
    
    FSFileItem *item = [self.dataArray objectAtIndex:indexPath.row];
    
    NSLog(@"%@",item.downloadUrl);
    
    [[FSDLManager07 shareManager] startDownloadWithItem:item];
}

@end
