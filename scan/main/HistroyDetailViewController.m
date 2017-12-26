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

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat screenW=[UIScreen mainScreen].bounds.size.width;
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake((screenW-300)/2, 100, 300, 300)];
    UIImage*qrImagge=[CommonFunc createQRForString:self.url];
    [imageview setImage:qrImagge];
    [self.view addSubview:imageview];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
