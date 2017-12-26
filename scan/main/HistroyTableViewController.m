//
//  HistroyTableViewController.m
//  scan
//
//  Created by 陈鑫荣 on 2017/12/23.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "HistroyTableViewController.h"
#import "DataBase.h"
#import "URL.h"
#import <SafariServices/SafariServices.h>
#import "HistroyDetailViewController.h"
@interface HistroyTableViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation HistroyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar*searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
    searchBar.delegate=self;
    [searchBar setBarStyle:UIBarStyleDefault];
    [searchBar setPlaceholder:@"搜索"];
    
    UIView*searchView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
    searchView.backgroundColor=[UIColor clearColor];
    [searchView addSubview:searchBar];
    
    self.navigationItem.titleView=searchView ;
    
    //    添加点击键盘消失的手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;//加上这句不会影响你 tableview 上的 action (button,cell selected...)
    [self setupBarButtonItem];
    
    [self setExtraCellLineHidden:self.tableView];
   
    
}
-(void)setupBarButtonItem{
    UIButton*deleteBtn=[[UIButton alloc]init];
    [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    UIBarButtonItem*barButton=[[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.leftBarButtonItem=barButton;
    
    UIButton*editBtn=[[UIButton alloc]init];
    [editBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    UIBarButtonItem*editBarButton=[[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem=editBarButton;
    
   
}

//没有数据不显示下划线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArray= [[DataBase sharedDataBase] getAllUrl];
    [self.tableView reloadData];
}
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString*url=@"url_cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:url];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:url];
    }
    URL*obj_url=self.dataArray[indexPath.row];
    cell.textLabel.text=obj_url.url;
    cell.detailTextLabel.text=obj_url.usedTime;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    URL*obj_url=self.dataArray[indexPath.row];
    //SFSafariViewController*safar=[[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:obj_url.url]];
  //  [self presentViewController:safar animated:YES completion:nil];
    HistroyDetailViewController*detail=[[HistroyDetailViewController alloc]init];
    detail.url=obj_url.url;
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    URL*obj_url=self.dataArray[indexPath.row];
    // 删除模型
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    //删除数据
    [[DataBase sharedDataBase]deleteUrl:obj_url];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)delete{
    NSLog(@"ffff");
}
-(void)hideKeyboard{
    NSLog(@"hideKeyboard");
    [self.navigationItem.titleView endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"dfd");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"lalal");
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    self.dataArray=[[DataBase sharedDataBase]getUrlLike:searchText];
    [self.tableView reloadData];
    
}
@end
