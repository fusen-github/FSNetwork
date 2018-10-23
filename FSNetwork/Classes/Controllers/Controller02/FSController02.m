//
//  FSController02.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/23.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController02.h"
#import "FSDownloadTaskDownloader.h"
#import "FSDataTaskDownloader.h"
#import "FSController02Cell.h"


@interface FSController02 ()<UITableViewDelegate,UITableViewDataSource,
FSDownloadTaskDownloaderDelegate,FSDataTaskDownloaderDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) FSDownloadTaskDownloader *downloader;

@end

@implementation FSController02

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    [self.view addSubview:tableView];
    
    /// 42110484 字节
    self.dataArray = @[@"http://dl_dir.qq.com/invc/tt/QQBrowser_1.5.0.2311.dmg"];
    
}

- (void)rightAction
{
    NSMutableArray *array = [NSMutableArray array];
    
    id obj = nil;
    
    [array addObject:obj];
    
    NSLog(@"还能来吗");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (FSController02Cell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellId = @"download_cell_id";
    
    FSController02Cell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (cell == nil)
    {
        cell = [[FSController02Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        
        cell.textLabel.textColor = [UIColor darkTextColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *urlString = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [urlString.lastPathComponent stringByDeletingPathExtension];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = [self.dataArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *targetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    targetPath = [targetPath stringByAppendingPathComponent:@"dmgs"];
    
    BOOL isDir = NO;
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:targetPath isDirectory:&isDir];
    
    if (!exist || !isDir)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    targetPath = [targetPath stringByAppendingPathComponent:url.lastPathComponent];
    
//    [self useDownloadTaskDownloaderWithTargetPath:targetPath url:url];
    
    [self useDataTaskDownloaderWithTargetPath:targetPath url:url];
}

- (void)useDownloadTaskDownloaderWithTargetPath:(NSString *)targetPath url:(NSURL *)url
{
    FSDownloadTaskDownloader *downloader = [FSDownloadTaskDownloader downloaderWithURL:url targetPath:targetPath delegate:self];
    
    [downloader resume];
}

- (void)useDataTaskDownloaderWithTargetPath:(NSString *)targetPath url:(NSURL *)url
{
    FSDataTaskDownloader *downloader = [FSDataTaskDownloader downloaderWithURL:url targetPath:targetPath delegate:self];
    
    [downloader resume];
}


- (void)downloaderDidFinished:(FSDataTaskDownloader *)downloader
{
    NSLog(@"%s",__func__);
    
    [downloader invalidateAndCancel];
}

// 0.685628
- (void)downloader:(FSDataTaskDownloader *)downloader didError:(NSError *)error
{
    NSLog(@"didError:%@",error.localizedDescription);
    
    [downloader invalidateAndCancel];
}

- (void)downloader:(FSDataTaskDownloader *)downloader downloadProgress:(float)progress
{
    NSLog(@"progress: %f",progress);
    
    NSInteger row = [self.dataArray indexOfObject:downloader.url.absoluteString];
    
    if (row < 0 || row >= self.dataArray.count)
    {
        NSLog(@"index error");
        
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    FSController02Cell *cell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell updateProgress:progress];
}

@end
