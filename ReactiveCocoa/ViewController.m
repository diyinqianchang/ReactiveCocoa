//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by 万联 on 16/4/26.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "PromiseKit.h"
#import "RWDummySignInService.h"

#import "SecondViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *siginBtn;
@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    //RACSignal信号类
    //RACDisposable资源回收类
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        //发送信号
        
        [subscriber sendNext:@"发送信号"];
        NSLog(@"hehe");
        //如果不在发送数据，最好发送信号完成
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁");
        }];
        
        
    }];
    // 3.订阅信号,才会激活信号.
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
   
    /**
     *  1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
     *    发送信号  调用 sendNext
     */
    
    RACSubject *subject = [RACSubject subject];
    //订阅信号，
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    //发送信号
    [subject sendNext:@"hha"];
    
    /**
     *  如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
     *  可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
     */
    RACReplaySubject *replaySub = [RACReplaySubject subject];
    [replaySub sendNext:@1];
    [replaySub sendNext:@2];
    
    [replaySub subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [replaySub subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    //先创建信号，     激活信号
   RACSignal *validUserNameSignal = [self.userName.rac_textSignal map:^id(NSString *value) {
        return @([self isValidUsername:value]);
   }];
    RACSignal *validPassWordSignal = [self.passWord.rac_textSignal map:^id(NSString *value) {
        return @([self isValidPassword:value]);
    }];
    
    RAC(self.userName,backgroundColor) = [validUserNameSignal map:^id(NSNumber *userNameValid) {
        return [userNameValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    }];
    RAC(self.passWord,backgroundColor) = [validPassWordSignal map:^id(NSNumber *passWordValid) {
        return [passWordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    }];
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validPassWordSignal,validUserNameSignal] reduce:^id(NSNumber *userNameValid,NSNumber *passwordValid){
        return @([userNameValid boolValue] && [passwordValid boolValue]);
    }];
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.siginBtn.enabled = [signupActive boolValue];
    }];
    
    
//    //用于给某个对象的某个属性绑定   userName一旦有输入相应的testLabel就会显示出来。把testLabel的text属性绑定在userName上
//    RAC(self.testLabel,text) = self.userName.rac_textSignal;
//    //    监听某个对象的某个属性,返回的是信号
//    [RACObserve(self.testLabel, text) subscribeNext:^(id x) {
//        NSLog(@"---->>>>>%@",x);
//    }];
    
}
- (IBAction)clickSignInBtn:(UIButton *)sender {
    
    
    SecondViewController *secondVc = [[SecondViewController alloc] init];
    
    secondVc.delegateSignal = [RACSubject subject];
    
    [secondVc.delegateSignal subscribeNext:^(id x) {
        NSLog(@"点击了通知");
    }];
    [self.navigationController pushViewController:secondVc animated:YES];
    
//    //btn点击拟制
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(sigIn:) object:sender];
//    [self performSelector:@selector(sigIn:) withObject:sender afterDelay:0.5f];
    
   
    
    
}

-(void)sigIn:(id)sender{

    [self.signInService
     signInWithUsername:self.userName.text
     password:self.passWord.text
     complete:^(BOOL success) {
         NSLog(@"%hhd",success);
     }];
    
    [self promiseLoginWithMobile:self.userName.text AndPassword:self.passWord.text];


}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;


}



- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

-(RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService
         signInWithUsername:self.userName.text
         password:self.passWord.text
         complete:^(BOOL success) {
             [subscriber sendNext:@(success)];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}


-(void)promiseLoginWithMobile:(NSString *)userName AndPassword:(NSString *)password{

    





}


//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    NSString * number = @"^[0-9]+$";
//    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
////    NSLog(@"%@",string);
//    if (![numberPre evaluateWithObject:string]) {
//     
//        return  YES;
//        
//    }else{
//    
//        return NO;
//    
//    }
//    
//
//}


//-(BOOL)isValidUsername:(NSString *)text{
//
//    if (text.length == 0) {
//        return YES;
//    }
//
//    NSString * number = @"^[0-9]+$";
//    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
//    return ![numberPre evaluateWithObject:text];
//
//}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
