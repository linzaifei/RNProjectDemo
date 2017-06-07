//
//  PushManager.m
//  RNProjectDemo
//
//  Created by xsy on 2017/6/7.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "PushManager.h"
#import "AppDelegate.h"
#import "QRCodeViewController.h"

@implementation PushManager
RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(popEvevt:(NSString *)name){

    NSLog(@"%@",name);
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    NSLog(@"%@",delegate.window.rootViewController);
    //跳转界面
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
    UINavigationController *navi = (UINavigationController *)delegate.window.rootViewController;
    
    [navi popViewControllerAnimated:YES];
    });

}


RCT_REMAP_METHOD(pushDataEvent,
                 Resolvor:(RCTPromiseResolveBlock)resolv
                 Rejector:(RCTPromiseRejectBlock)reject
                  ){
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    NSLog(@"%@",delegate.window.rootViewController);
    //跳转界面
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navi = (UINavigationController *)delegate.window.rootViewController;

        QRCodeViewController *pushVC = [[QRCodeViewController alloc] init];
        pushVC.popBlock = ^(NSString *urlStr) {
            
            if (urlStr) {
                resolv(urlStr);
            }else{
            
                reject(@"199",@"没有链接",nil);
                
            }
            
        };
        [navi pushViewController:pushVC animated:YES];
    });

    
}


@end
