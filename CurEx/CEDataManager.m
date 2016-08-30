//
//  CERestManager.m
//  CurEx
//
//  Created by Mark Smith on 26/08/2016.
//  Copyright © 2016 ___CurEx___. All rights reserved.
//

#import "CERestManager.h"
#import <AFNetworking/AFNetworking.h>
#import "definitions.h"

@implementation CERestManager

+ (id)instance {
    return [[CERestManager alloc] init];
}

/*- (void)getLatestWithCurrency:(NSString*)currency
                      success:(void(^)(NSDictionary *currencyDict))success
                      failure:(void(^)(NSError *error))failure {
    
    //self.getGroupWithGroupIdSuccess = success;
    //self.getGroupWithGroupIdFailure = failure;
    
    NSString  *path=[NSString stringWithFormat:@"groups/%d",groupId];

    
    
    AFHTTPClient  *httpClient=[MyRKObjectManager sharedManager].HTTPClient;
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.getGroupWithGroupIdSuccess(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.getGroupWithGroupIdFailure(error);
        
    }];
    
}*/

- (void)getLatestWithCurrency:(NSString*)currency
                      success:(void(^)(NSDictionary *currencyDict))success
                      failure:(void(^)(NSError *error))failure {
    
    // 1
    NSString *urlStr = [NSString stringWithFormat:@"%@latest?base=%@", kFixerDotIOBaseURL, currency];
    //NSURL *url = [NSURL URLWithString:string];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    // 2
    /*AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        self.weather = (NSDictionary *)responseObject;
        self.title = @"JSON Retrieved";
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];*/
}

@end
