//
//  CERestManager.h
//  CurEx
//
//  Created by Mark Smith on 26/08/2016.
//  Copyright © 2016 ___CurEx___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CERestManager : NSObject

+ (id)instance;

- (void)getLatestWithCurrency:(NSString*)currency
                    success:(void(^)(NSDictionary *currencyDict))success
                    failure:(void(^)(NSError *error))failure;
    
@end
