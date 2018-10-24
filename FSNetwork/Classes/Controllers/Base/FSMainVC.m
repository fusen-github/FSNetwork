//
//  FSMainVC.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSMainVC.h"

static NSString * const kTitleKey = @"title";

static NSString * const kControllerKey = @"controller";

@interface FSMainVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FSMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.dataArray = @[@{kTitleKey:@"初识网络",kControllerKey:@"FSController01"},
                       @{kTitleKey:@"NSURLSessionDataTask",kControllerKey:@"FSController02"},
                       @{kTitleKey:@"NSURLSessionDownloadTask",kControllerKey:@"FSController03"},];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellId = @"main_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        
        cell.textLabel.textColor = [UIColor darkTextColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *title = [dict objectForKey:kTitleKey];
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];

    NSString *controllerName = [dict objectForKey:kControllerKey];
    
    if (!controllerName.length)
    {
        return;
    }
    
    Class cls = NSClassFromString(controllerName);
    
    if ([cls isSubclassOfClass:[FSBaseViewController class]])
    {
        FSBaseViewController *controller = [[cls alloc] init];
        
        NSString *title = [dict objectForKey:kTitleKey];
        
        controller.title = title;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
