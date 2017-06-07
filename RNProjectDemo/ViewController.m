//
//  ViewController.m
//  RNProjectDemo
//
//  Created by xsy on 2017/6/6.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ViewController.h"
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>

@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IOS原生第一控制器";
    

}

- (IBAction)Action:(UIButton *)sender {
    
    //192.168.1.5
    //192.168.62.59
    //localhost
    NSURL *jsCodeLocation = [NSURL
                             URLWithString:@"http://192.168.62.59:8081/index.ios.bundle?platform=ios"];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation moduleName:@"RNProjectDemo" initialProperties:nil launchOptions:nil];
    
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = rootView;
//    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
