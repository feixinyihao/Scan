//
//  SetupTableViewController.m
//  scan
//
//  Created by 陈鑫荣 on 2017/12/23.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "SetupTableViewController.h"
#import "URL.h"
#import "DataBase.h"
@interface SetupTableViewController ()

@end

@implementation SetupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"setup"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setup"];
    }
    cell.textLabel.text=@"版本";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    URL*url=[[URL alloc]init];
    NSLog(@"%@",[[DataBase sharedDataBase]allProperties:url]) ;
       
}

@end
