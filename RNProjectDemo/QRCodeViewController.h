
//
//  QRCodeViewController.h
//  RNProjectDemo
//
//  Created by xsy on 2017/6/6.
//  Copyright © 2017年 林再飞. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController

@property(copy,nonatomic)void(^popBlock)(NSString *urlStr);

@end
