//
//  CECurrencyManager.m
//  CurEx
//
//  Created by Mark Smith on 26/08/2016.
//  Copyright © 2016 ___CurEx___. All rights reserved.
//

#import "CECurrencyManager.h"

@implementation CECurrencyManager

+ (id)instance {
    return [[CECurrencyManager alloc] init];
}

- (CGFloat)convertValue:(NSInteger)value usingRate:(CGFloat)rate {
    
    CGFloat result = value*rate;
    
    return result;
}

@end
