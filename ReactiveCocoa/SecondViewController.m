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
@interface SecondViewController ()

@property(strong,nonatomic)RACCommand *command;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 80, 40);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    NSArray *number = @[@1,@2,@3,@4];
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
    
   
    
    
    
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"dsn"] = @"P2001100000F3000209";
    parame[@"encryptCode"] = @"pYlmF0qWVV4+J6caSONnUarlI3lp2lyEEEOweLf0ooOONyerBfSYmweZZWxe9bmg7y5Hxk36NpVX/u4LND8HxSwRLtuv2jyuLfJfIurExL5I1w57xPGcjfrnLWrXJA1QBK7fwdRQLVONrxO4gLw5ow==";
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
    
    
    
    //封装网络请求  RACCommand
    self.command = [NetWorkingModel networkingWithParams:parame url:@"http://mserver.wanlian18.com/pos/pos/login"];
    [self.command.executionSignals subscribeNext:^(RACSignal *name) {
       [name subscribeNext:^(id x) {
           NSLog(@"---->%@",x);
       }];
    }];
    
    [self.command execute:@1];
    
    
    [RACScheduler mainThreadScheduler];
    
    
}

-(void)btnClick:(UIButton *)btn{

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
