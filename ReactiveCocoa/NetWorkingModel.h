//
//  NetWorkingModel.h
//  ReactiveCocoa
//
//  Created by 万联 on 16/6/15.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
@interface NetWorkingModel : NSObject


//+(RACSignal *)networkingWithParams:(id)params url:(NSString *)url;

+(RACCommand *)networkingWithParams:(id)params url:(NSString *)url;

@end
