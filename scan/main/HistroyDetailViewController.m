//
//  HistroyDetailViewController.m
//  scan
//
//  Created by 陈鑫荣 on 2017/12/24.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "HistroyDetailViewController.h"
#import "CommonFunc.h"
@interface HistroyDetailViewController ()
@end

@implementation HistroyDetailViewController
#define JpColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define  screenW [UIScreen mainScreen].bounds.size.width
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setExtraCellLineHidden:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//没有数据不显示下划线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 1;
    }else if(section==1){
        return 4;
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15,0, [UIScreen mainScreen].bounds.size.width-30, 80)];
        label.text=self.url;
        label.numberOfLines = 0;
        label.font=[UIFont systemFontOfSize:17];
        [cell.contentView addSubview:label];
    }else if(indexPath.section==1){
        cell.textLabel.text=@"功能";
    }else{
        self.view.backgroundColor=[UIColor whiteColor];
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(30,20, screenW-60, screenW-60)];
        UIImage*qrImagge=[CommonFunc createQRForString:self.url];
        [imageview setImage:qrImagge];
        [cell.contentView addSubview:imageview];
        
    }
    return cell;
   
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }else if(indexPath.section==1){
        return 50;
    }else{
        return screenW-20;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=JpColor(240, 240, 240);
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
