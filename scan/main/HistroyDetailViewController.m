//
//  HistroyDetailViewController.m
//  scan
//
//  Created by 陈鑫荣 on 2017/12/24.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "HistroyDetailViewController.h"
#import "CommonFunc.h"
#import "MBProgressHUD+MJ.h"
#import <SafariServices/SafariServices.h>

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
/**
 * 复制
 */
- (void)copylinkBtnClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.url;
    [MBProgressHUD showSuccess:@"扫描结果已经复制到剪贴板"];

   
    
}
-(Boolean)isincluded:(NSString*)str in:(NSString*)supStr{
    
    if([supStr rangeOfString:str].location !=NSNotFound){
        return YES;
    }else
        return NO;
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
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"复制";
                break;
            case 1:
                cell.textLabel.text=@"比价格";
                break;
            case 2:
                cell.textLabel.text=@"查快递";
                break;
            case 3:
                cell.textLabel.text=@"搜索";
                break;
            default:
                
                break;
        }
     
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
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
                [self copylinkBtnClick];
                break;
            case 1:{
                NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.baidu.com/s?barcode=%@",self.url]];
                SFSafariViewController*safar=[[SFSafariViewController alloc]initWithURL:url];
                [self presentViewController:safar animated:YES completion:nil];
                
            }
                break;
            case 2:{
                
            }break;
            case 3:{
                NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"https://baidu.com/s?wd=%@",self.url]];
                SFSafariViewController*safar=[[SFSafariViewController alloc]initWithURL:url];
                [self presentViewController:safar animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
       
    }else if (indexPath.section==0){
        if ([self isincluded:@"http" in:self.url]) {
            NSURL*url=[[NSURL alloc]initWithString:self.url];
            SFSafariViewController*safar=[[SFSafariViewController alloc]initWithURL:url];
            [self presentViewController:safar animated:YES completion:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
