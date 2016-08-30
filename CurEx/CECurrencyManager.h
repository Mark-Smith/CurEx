//
//  CECurrencyManager.h
//  CurEx
//
//  Created by Mark Smith on 26/08/2016.
//  Copyright © 2016 ___CurEx___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CECurrencyManager : NSObject

+ (id)instance;

- (CGFloat)convertValue:(NSInteger)value usingRate:(CGFloat)rate;

@end
