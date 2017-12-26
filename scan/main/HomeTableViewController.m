//
//  HomeTableViewController.m
//  IM
//
//  Created by 陈鑫荣 on 2017/12/1.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "HomeTableViewController.h"
#import "WBTabbar.h"
#import "HistroyTableViewController.h"
#import "SetupTableViewController.h"
#import "QRcodeViewController.h"
@interface HomeTableViewController ()<WBTabBarDelegate>
@property (weak,nonatomic)WBTabbar* MyTabBar;
@end

@implementation HomeTableViewController

#define JpColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBar];
    [self setupAllChildView];
    
}

-(void)viewWillAppear:(BOOL)animated{

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
/**
 *  初始化一个子控制器
 */
-(void)SetupChildViewConterller:(UIViewController * )childView title:(NSString*)title  imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName{
    
    childView.title=title;
    childView.tabBarItem.image=[UIImage imageNamed:imageName];
    childView.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController * childViewNav=[[UINavigationController alloc]initWithRootViewController:childView];
    [self addChildViewController:childViewNav];
    
}
/**
 *  初始化所有子控制器
 */
-(void)setupAllChildView{

    
    QRcodeViewController*qr=[[QRcodeViewController alloc]init];
    [self SetupChildViewConterller:qr title:@"扫描" imageName:@"scan" selectedImageName:@"scan_select"];
    
    HistroyTableViewController*histroy=[[HistroyTableViewController alloc]init];
    [self SetupChildViewConterller:histroy title:@"历史" imageName:@"histroy" selectedImageName:@"histroy_select"];
    
    SetupTableViewController*setup=[[SetupTableViewController alloc]init];
    [self SetupChildViewConterller:setup title:@"设置" imageName:@"setup" selectedImageName:@"setup_select"];
   
    
}
-(void)setTabBar{
    WBTabbar* MyTabbar=[[WBTabbar alloc]init];
    MyTabbar.frame=self.tabBar.bounds;
    MyTabbar.backgroundColor=[UIColor whiteColor];
    [self.tabBar setTintColor:JpColor(18, 150, 219)];
    [self.tabBar addSubview:MyTabbar];
    self.MyTabBar=MyTabbar;
    MyTabbar.delegate=self;
    
}

-(void)tabBardidClick:(WBTabbar*)tabBar from:(NSInteger)from to:(NSInteger)to{
    
    //  NSLog(@"%d,%d",from,to);
    self.selectedIndex=to;
    
}


@end
