//
//  FSController03.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/24.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController03.h"
#import "FSDownloadTaskDownloader.h"
#import "FSTaskCell.h"
#import "AppDelegate.h"


@interface FSController03 ()<UITableViewDelegate,UITableViewDataSource,FSDownloadTaskDownloaderDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) FSDownloadTaskDownloader *downloader;

@end

@implementation FSController03

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
    [self.downloader invalidateAndCancel];
}

- (void)rightAction_01
{
    AppDelegate *app = (id)[UIApplication sharedApplication].delegate;

    app.loader = self.downloader;
    
    NSMutableArray *array = [NSMutableArray array];
    
    id obj = nil;
    
    [array addObject:obj];
    
    NSLog(@"还能来吗");
    
//    [self.downloader invalidateAndCancel];
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

- (FSTaskCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellId = @"download_cell_id";
    
    FSTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (cell == nil)
    {
        cell = [[FSTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        
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
    
    targetPath = [targetPath stringByAppendingPathComponent:@"dmgs/downloadTast"];
    
    BOOL isDir = NO;
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:targetPath isDirectory:&isDir];
    
    if (!exist || !isDir)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    targetPath = [targetPath stringByAppendingPathComponent:url.lastPathComponent];
    
    [self useDownloadTaskDownloaderWithTargetPath:targetPath url:url];
}

- (void)useDownloadTaskDownloaderWithTargetPath:(NSString *)targetPath url:(NSURL *)url
{
    FSDownloadTaskDownloader *downloader = [FSDownloadTaskDownloader downloaderWithURL:url targetPath:targetPath delegate:self];
    
    self.downloader = downloader;
    
    [downloader resume];
}

@end
