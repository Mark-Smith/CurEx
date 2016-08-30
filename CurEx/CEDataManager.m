//
//  CEDataManager.m
//  CurEx
//
//  Created by Mark Smith on 26/08/2016.
//  Copyright © 2016 ___CurEx___. All rights reserved.
//

#import "CEDataManager.h"
#import <AFNetworking/AFNetworking.h>
#import "definitions.h"

@implementation CEDataManager

+ (id)instance {
    return [[CEDataManager alloc] init];
}

- (void)getLatestRatesForCurrency:(NSString*)currency
                      success:(void(^)(NSDictionary *currencyDict))success
                      failure:(void(^)(NSError *error))failure {
    
    // 1
    NSString *urlStr = [NSString stringWithFormat:@"%@latest", kFixerDotIOBaseURL];
    //http://api.fixer.io/latest?base=USD

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:@{@"base": currency} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *ratesDict = responseObject[@"rates"];
        success(ratesDict);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}

- (NSArray*)getCurrencyCodes {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencies" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    NSDictionary *ratesDict = dict[@"rates"];
    
    NSArray *currencyCodes = [ratesDict allKeys];
    
    return currencyCodes;
}



@end
