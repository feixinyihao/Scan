//
//  QRcodeViewController.m
//  UniVersion
//
//  Created by 陈鑫荣 on 16/7/11.
//  Copyright © 2016年 unifound. All rights reserved.
//

#import "QRcodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD+MJ.h"
#import "CoverView.h"
#import <SafariServices/SafariServices.h>
#import "DataBase.h"
#import "URL.h"
#import <TZImagePickerController.h>
#import "HistroyDetailViewController.h"
@interface QRcodeViewController()<AVCaptureMetadataOutputObjectsDelegate,TZImagePickerControllerDelegate>
@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
// 是否打开手电筒
@property (nonatomic,assign,getter = isTorchOn) BOOL torchOn;

@property(nonatomic,strong)UIBarButtonItem*torchBarBrn;
//手电筒按钮
@property(nonatomic,weak)UIButton*torchBtn;


@property(nonatomic,strong)UIView* caves;
@end
@implementation QRcodeViewController
#define SCREENW  [UIScreen mainScreen].bounds.size.width
#define SCREENH  [UIScreen mainScreen].bounds.size.height
-(void)viewDidLoad{
    self.title=@"扫一扫";
    //通知中心是个单例
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [notiCenter addObserver:self selector:@selector(Animate) name:@"Animate" object:nil];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.caves=[[UIView alloc]init];
    self.caves.frame=[UIScreen mainScreen].bounds;
    //self.caves.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.caves];
    [MBProgressHUD showHUDAddedTo:self.caves animated:YES];
    [self setupCamera];
    
    [self setupBarButoon];
  

}
-(void)setupBarButoon{
  
    UIImage*torchImage=[[UIImage imageNamed:@"torch"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.torchBarBrn=[[UIBarButtonItem alloc]initWithImage:torchImage style:UIBarButtonItemStylePlain target:self action:@selector(turnOnOrOffTorch)];
    self.navigationItem.rightBarButtonItem = self.torchBarBrn;
    
 
    UIImage*image=[[UIImage imageNamed:@"openImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftbarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(openImagePicker)];
    self.navigationItem.leftBarButtonItem = leftbarButtonItem;
    
}
-(void)Animate{
    NSLog(@"重绘动画");
    [self deleteScanAnimate];
    [self addscananimate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.caves removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.caves animated:YES];
    [self deleteScanAnimate];
    [self addscananimate];
    [_session startRunning];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self deleteScanAnimate];
   // [self addData:@"https://unifound?dfsasddahqwbduiq_dsfskkkdjiejfrdbkjadsakjbdkjsda.cc"];
}
-(void)deleteScanAnimate{
    for (UIView*view in self.view.subviews) {
        if (view.tag==1001||view.tag==1002||view.tag==1003) {
            [view removeFromSuperview];
        }
    }
}
-(void)addscananimate{
    
    CoverView* cover=[[CoverView alloc]init];
    cover.frame=self.view.bounds;
    cover.tag=1001;
    
    CGFloat w=[UIScreen mainScreen].bounds.size.width;
    CGFloat h=[UIScreen mainScreen].bounds.size.height;
    UIImageView*scanBox=[[UIImageView alloc]initWithFrame:CGRectMake(w*50/320, (h*180/576)-40, w*220/320, w*220/320)];
    scanBox.image=[UIImage imageNamed:@"qr_border"];
    scanBox.tag=1003;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(w*60/320, (h*190/576)-40, w*200/320, 4)];
    line.image = [UIImage imageNamed:@"land_scanning_wire"];
    line.tag=1002;

    [self.view addSubview:cover];
    [self.view addSubview:scanBox];
    [self.view addSubview:line ];
    
    
    
    /* 添加动画 */
    
    [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        line.frame = CGRectMake(w*60/320, (h*390/576)-40, w*200/320, 4);
    } completion:nil];

}
- (void)setupCamera{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (error) {
        [MBProgressHUD showError:@"没有摄像头"];
        [self.navigationController popViewControllerAnimated:YES];
        return;

    }else{
    
        self.input =input;

    }
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
//    AVMetadataObjectTypeUPCECode
//    AVMetadataObjectTypeCode39Code
//    AVMetbadataObjectTypeCode39Mod43Code
//    AVMetadataObjectTypeEAN13Code
//    AVMetadataObjectTypeEAN8Code
//    AVMetadataObjectTypeCode93Code
//    AVMetadataObjectTypeCode128Code
//    AVMetadataObjectTypePDF417Code
//    AVMetadataObjectTypeQRCode
//    AVMetadataObjectTypeAztecCode
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode
                                       ,AVMetadataObjectTypeUPCECode
                                       ,AVMetadataObjectTypeCode39Code
                                       ,AVMetadataObjectTypeEAN13Code
                                       ,AVMetadataObjectTypeEAN8Code
                                       ,AVMetadataObjectTypeCode93Code
                                       ,AVMetadataObjectTypeCode128Code
                                       ,AVMetadataObjectTypePDF417Code
                                       ,AVMetadataObjectTypeQRCode
                                       ,AVMetadataObjectTypeAztecCode];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
//    self.preview.frame=CGRectMake(self.view.frame.size.width/16,self.view.frame.size.height/4,self.view.frame.size.height/2,self.view.frame.size.height/2);
    self.preview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:self.preview];
    
   

    // Start
    [self.session startRunning];
   // [self addscananimate];
    CGFloat w=[UIScreen mainScreen].bounds.size.width;
    CGFloat h=[UIScreen mainScreen].bounds.size.height;
    CGRect intertRect = [self.preview metadataOutputRectOfInterestForRect:CGRectMake(w*50/320, (h*180/576)-40, w*220/320, w*220/320)];
    
    CGRect layerRect = [self.preview rectForMetadataOutputRectOfInterest:intertRect];
    
    NSLog(@"%@,  %@",NSStringFromCGRect(intertRect),NSStringFromCGRect(layerRect));
    
    self.output.rectOfInterest = intertRect;
    


    
}
-(Boolean)isincluded:(NSString*)str in:(NSString*)supStr{
    
    if([supStr rangeOfString:str].location !=NSNotFound){
        return YES;
    }else
        return NO;
}
//扫码成功调用代理方法
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_session stopRunning];
    NSString*stringValue=@"";
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    /*
    if ([self isincluded:@"http" in:stringValue]) {
        SFSafariViewController*safar=[[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:stringValue]];
        [safar setHidesBottomBarWhenPushed:YES];
        [self presentViewController:safar animated:YES completion:^{
            [_session startRunning];
        }];
    }*/
   
    [self addData:stringValue];
  //  self.tabBarController.selectedIndex=1;
   // [self alert:stringValue];
    HistroyDetailViewController*detail=[[HistroyDetailViewController alloc]init];
    [detail setHidesBottomBarWhenPushed:YES];
    detail.url=stringValue;
    [self.navigationController pushViewController:detail animated:YES];
    
}

/**
 *  添加数据到数据库
 */
- (void)addData:(NSString*)url_str{
    //获取当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
   
    NSString *url =url_str;
    NSString*usedTime=DateTime;
    
    URL *obj_url = [[URL alloc] init];
    obj_url.usedTime=usedTime;
    obj_url.url=url;
    [[DataBase sharedDataBase] addUrl:obj_url];
        
}
#pragma mark - 打开／关闭手电筒
-(void)turnOnOrOffTorch {
    
    if ([self.device hasTorch]){ // 判断是否有闪光灯
        self.torchOn = !self.isTorchOn;
        if (self.torchOn) {
            UIImage*torchImage=[[UIImage imageNamed:@"torch_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.torchBarBrn setImage:torchImage];
        }else{
            UIImage*torchImage=[[UIImage imageNamed:@"torch"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.torchBarBrn setImage:torchImage];
            
        }
        [self.device lockForConfiguration:nil];// 请求独占访问硬件设备
        
        if (self.isTorchOn) {
            NSLog(@"onon");
            [self.torchBtn setSelected:YES];
            [self.device setTorchMode:AVCaptureTorchModeOn];
        } else {
            NSLog(@"off");
            [self.torchBtn setSelected:NO];
            [self.device setTorchMode:AVCaptureTorchModeOff];
        }
        [self.device unlockForConfiguration];// 请求解除独占访问硬件设备
    }else {
        [MBProgressHUD showError:@"没有闪光灯"];
    }
}
-(void)alert:(NSString*)scannedResult{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"二维码"
                                                                             message:scannedResult
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [_session startRunning];
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}
/**
 识别图片二维码
 */
-(void)imageQrcode:(UIImage*)image{
    if(image){
        //1. 初始化扫描仪，设置设别类型和识别质量
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        //2. 扫描获取的特征组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        //3. 获取扫描结果
       
        if (features.count>0) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            [self addData:scannedResult];
          
           // [self alert:scannedResult];
            HistroyDetailViewController*detail=[[HistroyDetailViewController alloc]init];
            [detail setHidesBottomBarWhenPushed:YES];
            detail.url=scannedResult;

            [self.navigationController pushViewController:detail animated:YES];
        
           
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还没有生成二维码"
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction *action) {
                    
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:^{}];
            
        }
       
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还没有生成二维码"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                          }]];
        
        [self presentViewController:alertController animated:YES completion:^{}];
    }
}
-(void)openImagePicker{
    TZImagePickerController*imagepick=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagepick.allowPickingGif=NO;
    imagepick.allowPickingVideo=NO;
   // imagepick.navigationController.navigationBar.barTintColor=JpColor(27, 161, 232);
   // imagepick.navigationBar.barTintColor = mainColor;
    imagepick.isStatusBarDefault = NO;
    imagepick.allowPickingOriginalPhoto=NO;
    [self presentViewController:imagepick animated:YES completion:nil
     ];
    
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@",[photos firstObject]);
    [self imageQrcode:[photos firstObject]];
}
@end
