//
//  FISAPIClient.m
//  locationTrivia-API
//
//  Created by Mykel Pereira on 4/14/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISAPIClient.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

#define API_KEY @"4884f098b2eb01ac21ff346a9c480600a00b6df4"
#define BASE_URL @"http://locationtrivia.herokuapp.com/"

@interface FISAPIClient()
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@end

@implementation FISAPIClient

+ (FISAPIClient *)sharedClient
{
    static FISAPIClient *sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    
    return sharedClient;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    
    return self;
}

- (void)requestLocationsWithSuccess:(void (^)(NSArray *))success
                            failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"key"] = API_KEY;
    
    [self.requestOperationManager GET:@"/locations.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)createLocationWithName:(NSString *)name
                      Latitude:(NSNumber *)latitude
                     longitude:(NSNumber *)longitude
                   withSuccess:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"key"] = API_KEY;
    parameters[@"location[name]"] = name;
    parameters[@"location[latitude]"] = [latitude stringValue];
    parameters[@"location[longitude]"] = [longitude stringValue];
    
    [self.requestOperationManager POST:@"/locations.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)deleteLocationWithID:(NSString *)locationID
                 withSuccess:(void (^)(BOOL))success
                     failure:(void (^)(NSError *))failure
{
    NSString *deleteString = [NSString stringWithFormat:@"/locations/%@.json", locationID];
    
    [self.requestOperationManager DELETE:deleteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"From the delete request in the API Client: %@", responseObject);
        
        success(YES);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)createTriviumWithContent:(NSString *)content
               forLocationWithID:(NSString *)locationID
                         success:(void (^)(NSDictionary *))success
                         failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"key"] = API_KEY;
    parameters[@"trivium[content]"] = content;
    
    NSString *triviumString = [NSString stringWithFormat:@"/locations/%@/trivia.json", locationID];
    
    [self.requestOperationManager POST:triviumString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"What is the response object in createTrivium: %@", responseObject);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)deleteTriviumWithID:(NSString *)triviumID
             withLocationID:(NSString *)locationID
                withSuccess:(void (^)(BOOL))success
                    failure:(void (^)(NSError *))failure
{
    NSString *deleteString = [NSString stringWithFormat:@"/locations/%@/trivia/%@.json", locationID, triviumID];
    
    [self.requestOperationManager DELETE:deleteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
