//
//  CommonFunc.h
//  scan
//
//  Created by 陈鑫荣 on 2017/12/24.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonFunc : NSObject
- (UIImage *)createQRForString:(NSString *)qrString;
+ (UIImage *)createQRForString:(NSString *)qrString;
@end
