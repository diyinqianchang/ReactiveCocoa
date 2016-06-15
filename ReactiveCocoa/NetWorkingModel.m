//
//  NetWorkingModel.m
//  ReactiveCocoa
//
//  Created by 万联 on 16/6/15.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

#import "NetWorkingModel.h"
#import "AFNetworking.h"

@implementation NetWorkingModel


//+(RACSignal *)networkingWithParams:(id)params url:(NSString *)url{
//
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
////        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
////        parame[@"dsn"] = @"P2001100000F3000209";
////        parame[@"encryptCode"] = @"pYlmF0qWVV4+J6caSONnUarlI3lp2lyEEEOweLf0ooOONyerBfSYmweZZWxe9bmg7y5Hxk36NpVX/u4LND8HxSwRLtuv2jyuLfJfIurExL5I1w57xPGcjfrnLWrXJA1QBK7fwdRQLVONrxO4gLw5ow==";
//        
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//        
//        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
//        NSURLSessionTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            
//            NSString *dataString =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            
//            [subscriber sendNext:dataString];
//            [subscriber sendCompleted];
//        }];
//        [task resume];
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"清号被销毁");
//        }];
//    }];
//    
//    return signal;
//    
//
//}


+(RACCommand *)networkingWithParams:(id)params url:(NSString *)url{

    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            
                    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
                    NSURLSessionTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
                        NSString *dataString =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
                        [subscriber sendNext:dataString];
                        [subscriber sendCompleted];
                    }];
                    [task resume];
                    return [RACDisposable disposableWithBlock:^{
                        NSLog(@"清号被销毁");
                    }];
                }];
                
                return signal;

    }];
    return command;
}



@end
