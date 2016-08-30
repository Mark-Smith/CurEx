//
//  CEDataManager.h
//  CurEx
//
//  Created by Mark Smith on 26/08/2016.
//  Copyright © 2016 ___CurEx___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEDataManager : NSObject

+ (id)instance;

- (void)getLatestRatesForCurrency:(NSString*)getLatestRatesForCurrency
                    success:(void(^)(NSDictionary *ratesDict))success
                    failure:(void(^)(NSError *error))failure;
- (NSArray*)getCurrencyCodes;
    
@end
