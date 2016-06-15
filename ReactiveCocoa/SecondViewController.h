//
//  SecondViewController.h
//  ReactiveCocoa
//
//  Created by 张国林 on 16/6/14.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"
@interface SecondViewController : UIViewController
@property(nonatomic,strong)RACSubject *delegateSignal;
@end
