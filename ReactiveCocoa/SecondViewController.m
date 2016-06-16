//
//  SecondViewController.m
//  ReactiveCocoa
//
//  Created by 张国林 on 16/6/14.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//



#import "SecondViewController.h"
#import "AFNetworking.h"
#import "NetWorkingModel.h"
#import "RenderManager.h"
@interface SecondViewController ()

@property(strong,nonatomic)RACCommand *command;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicantLabel;
@property(strong,nonatomic)AFURLSessionManager *sessionManager;
@property(strong,nonatomic)RenderManager *model;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.model = [[RenderManager alloc] init];
    
  /*  NSArray *number = @[@1,@2,@3,@4];
    [number.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    NSArray *flags = [[number.rac_sequence.signal map:^id(id value) {
        return [NSString stringWithFormat:@"-->%@",value];
    }] toArray];
    NSLog(@"%@",flags);
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
       //元组解包
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@,%@",key,value);
        
    }];
    
   
    
   
//    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        NSLog(@"执行命令");
//        RACSignal *signal = [NetWorkingModel networkingWithParams:parame url:@"http://mserver.wanlian18.com/pos/pos/login"];
//        return signal;
//    }];
//    _command = command;
//    [command.executionSignals subscribeNext:^(RACSignal *name) {
//       [name subscribeNext:^(id x) {
//           NSLog(@"---->%@",x);
//       }];
//    }];
    */
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"dsn"] = @"P2001100000F3000209";
    parame[@"encryptCode"] = @"pYlmF0qWVV4+J6caSONnUarlI3lp2lyEEEOweLf0ooOONyerBfSYmweZZWxe9bmg7y5Hxk36NpVX/u4LND8HxSwRLtuv2jyuLfJfIurExL5I1w57xPGcjfrnLWrXJA1QBK7fwdRQLVONrxO4gLw5ow==";
    
//    //封装网络请求  RACCommand
//    self.command = [NetWorkingModel networkingWithParams:parame url:@"http://mserver.wanlian18.com/pos/pos/login"];
//    [self.command.executionSignals subscribeNext:^(RACSignal *name) {
//       [name subscribeNext:^(id x) {
//           NSLog(@"---->%@",x);
//       }];
//    }];
//    
//    [self.command execute:@1];
   
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@1];
//        [subscriber sendNext:@2];
//        [subscriber sendNext:@3];
//        return [RACDisposable disposableWithBlock:^{
//        }];
//    }];
//    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
//        [signal subscribeNext:^(id x) {
//            NSLog(@"Subscriber 1 recevive:%@",x);
//        }];
//    }];
//    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
//        [signal subscribeNext:^(id x) {
//            NSLog(@"Subscriber 2 recevive:%@",x);
//        }];
//    }];
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    @weakify(self)
    RACSignal *fetchData = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       @strongify(self)
        
         NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://mserver.wanlian18.com/pos/pos/login" parameters:parame error:nil];
        
          NSURLSessionTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            }else{
                NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            if (task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
            }
        }];
    }];
    
    [[fetchData map:^id(id responseObject) {

        return [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

    }] subscribeNext:^(NSDictionary *dict) {
        
        [self.model setValuesForKeysWithDictionary:dict];
        
    }];
    
    RAC(self.nameLabel,text) = RACObserve(self.model, name);
    RAC(self.applicantLabel,text) = RACObserve(self.model, applicant);
    
    
    
//    merge  把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
//    [[RACSignal merge:@[fetchData]] subscribeError:^(NSError *error) {
//        NSLog(@"访问出错");
//    }];
    
    
//    RACSignal *title = [fetchData flattenMap:^RACStream *(NSDictionary *value) {
//        if ([value[@"title"] isKindOfClass:[NSString class]]) {
//            return [RACSignal return:value[@"title"]];
//        }else{
//        
//            return [RACSignal error:[NSError errorWithDomain:@"some error" code:400 userInfo:@{@"originData": value}]];
//        }
//    }];
//    RACSignal *desc = [fetchData flattenMap:^RACSignal *(NSDictionary *value) {
//        if ([value[@"desc"] isKindOfClass:[NSString class]]) {
//            return [RACSignal return:value[@"desc"]];
//        } else {
//            return [RACSignal error:[NSError errorWithDomain:@"some error" code:400 userInfo:@{@"originData": value}]];
//        }
//    }];
    
//    RACSignal *renderedDesc = [desc flattenMap:^RACStream *(NSString *value) {
//        NSError *error = nil;
//        RenderManager *renderManager = [[RenderManager alloc] init];
//        NSAttributedString *rendered = [renderManager renderText:value error:&error];
//        if (error) {
//            return [RACSignal error:error];
//        } else {
//            return [RACSignal return:rendered];
//        }
//    }];
    
    
    
    
    
//    RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
//            [subscriber sendNext:@1];
//        }];
//        
//        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
//            [subscriber sendNext:@2];
//        }];
//        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
//            [subscriber sendNext:@3];
//        }];
//        [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
//            [subscriber sendCompleted];
//        }];
//        return [RACDisposable disposableWithBlock:^{
//            
//        }];
//        
//        
//    }] publish];
//
//    [connection connect];
//    
//     NSLog(@"Signal was created.");
//    
//    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
//       [connection.signal subscribeNext:^(id x) {
//           NSLog(@"Subscriber 1 recveive: %@",x);
//       }];
//    }];
//    [[RACScheduler mainThreadScheduler] afterDelay:2.1 schedule:^{
//        [connection.signal subscribeNext:^(id x) {
//            NSLog(@"Subscriber 2 recveive: %@",x);
//        }];
//    }];
    
}
- (IBAction)btnClick:(id)sender {
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:nil];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
