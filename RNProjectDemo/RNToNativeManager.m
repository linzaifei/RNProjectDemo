//
//  RNToNativeManager.m
//  RNProjectDemo
//
//  Created by xsy on 2017/6/7.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "RNToNativeManager.h"

@implementation RNToNativeManager

RCT_EXPORT_MODULE();

/**
 接收RN传过来的 NSString
 @param NSString 字符串
 */
RCT_EXPORT_METHOD(addEvent:(NSString *)name){

    NSLog(@"接收传过来的NSString+NSString: %@", name);
}

/**
 接收RN传过来的 NSString + dictionary

 @param NSString 字符串
 @param NSDictionary 字典
 @return
 */
RCT_EXPORT_METHOD(addEventTwo:(NSString *)name DetailData:(NSDictionary *)data){

    NSLog(@"接收到RN传递过得string + dictionary ,%@,%@ ",name,data);
}


/**
 接收RN传过来的 NSString + date日期

 @param NSString 字符串
 @param NSDate data数据
 @return <#return value description#>
 */
RCT_EXPORT_METHOD(addEventThree:(NSString *)name Date:(NSDate *)date){
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"接收传过来的NSString+NSDictionary: %@ %@", name, [formatter stringFromDate:date]);
}


/**
 接收RN传过来的 callback

 @param NSString 字符串
 @return <#return value description#>
 */
RCT_EXPORT_METHOD(TextCallBackOne:(NSString *)name CallBack:(RCTResponseSenderBlock)callback){
    NSLog(@"%@",name);
    
    NSArray *arr = @[@"1",@"2",@"3",@"4",];
    // [NSNull null] 返回RN用来判断
    callback(@[[NSNull null],arr]);
}


//Promises

/**
对外提供调用方法,演示Promise使用（resolve block回调出去的值id）

 @param TextCallBackTwo <#TextCallBackTwo description#>
 @param RCTPromiseResolveBlock <#RCTPromiseResolveBlock description#>
 @return <#return value description#>
 */
RCT_REMAP_METHOD(TextCallBackTwo, Resolver:(RCTPromiseResolveBlock)resolve Rejecter:(RCTPromiseRejectBlock)reject){

    NSArray *arr = @[@"5",@"6",@"7",@"8",];
    if (arr) {
        resolve(arr);
    }else{
        NSError *error;
        NSString *message = @"这是错误信息。。。。";
        reject(@"199",message,error);
    
    }
}

-(NSDictionary *)constantsToExport{
    return @{@"first":@"Native"};
}







@end
