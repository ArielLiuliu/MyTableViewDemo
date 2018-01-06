//
//  ViewController.m
//  MyTableViewDemo
//
//  Created by lx on 2018/1/6.
//  Copyright © 2018年 lx. All rights reserved.
//

#import "ViewController.h"

#define TOPHEIGHT 200

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSArray *arrayData;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"更多";
    
    self.arrayData =@[
                      @[@{@"分享":@"icon_st_share"},@{@"意见反馈":@"icon_st_fankui"}],
                      @[@{@"清除缓存":@"icon_st_huancun"}],
                      @[@{@"当前版本":@"icon_st_banben"},@{@"登录":@""}]
                      ];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    //添加可动态放大的视图
    self.tableView.contentInset = UIEdgeInsetsMake(TOPHEIGHT, 0, 0, 0);//设置tableView的内置偏移量
    self.headerView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -TOPHEIGHT, self.tableView.bounds.size.width, TOPHEIGHT)];
    self.headerView.image = [UIImage imageNamed:@"defaultHeadView"];
    self.headerView.userInteractionEnabled = YES;
    self.headerView.clipsToBounds = YES;
    self.headerView.contentMode = UIViewContentModeScaleAspectFill;//图片按原始比例填充
    [self.tableView addSubview:self.headerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
}


//cell上添加子视图
- (void)add:(NSDictionary*)dic view:(UIView*)contentView other:(NSString*)info {
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 20, 20)];
    iv.image = [UIImage imageNamed:dic.allValues.firstObject];
    [contentView addSubview:iv];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x+iv.frame.size.width+10, iv.frame.origin.y, 100, 20)];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor blackColor];
    lab.text = dic.allKeys.firstObject;
    [contentView addSubview:lab];
    
    if (info && info.length > 0) {
        UILabel *aLab = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width-100, 11, 80, 20)];
        aLab.textAlignment = NSTextAlignmentRight;
        aLab.font = [UIFont systemFontOfSize:14];
        aLab.textColor = [UIColor blackColor];
        aLab.text = info;
        [contentView addSubview:aLab];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayData.count;//返回组数
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [self.arrayData count]) {
        NSArray *ary = self.arrayData[section];
        return ary.count;//返回每组的行数
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];//分组样式的背景颜色
    }
    
    //清空cell上所有的子视图
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    //重新贴子视图
    NSArray *ary = self.arrayData[indexPath.section];
    NSDictionary *dic = ary[indexPath.row];
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self add:dic view:cell.contentView other:nil];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self add:dic view:cell.contentView other:@"4.55M"];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self add:dic view:cell.contentView other:@"1.0"];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.textLabel.text = @"登录";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
//组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;//第一组的高度
    }
    return 30;//其它组的高度均为30
}

//组尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

//每行选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"分享");
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        NSLog(@"意见反馈");
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"清除缓存");
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        NSLog(@"登录");
    }
}

//因为tableview的父类是UIScrollView，所以，当tableView滑动时，scrollview的代理方法也会走的。
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -TOPHEIGHT) {
        CGRect f = self.headerView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.headerView.frame = f;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
