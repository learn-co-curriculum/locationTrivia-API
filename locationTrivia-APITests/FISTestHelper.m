//
//  FISTestHelper.m
//  locationTrivia-API
//
//  Created by James Campagno on 8/13/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISTestHelper.h"


@interface FISTestHelper ()

+ (NSDictionary *)createDictionaryOfQueryItemsWithRequest:(NSURLRequest *)request;
+ (NSArray *)createFakeArrayJSON;
+ (NSDictionary *)createFakeDictJSON;
+ (NSDictionary *)createFakeTrivia;

@end


@implementation FISTestHelper

+ (void)extractLatitudeLongitudeAndNameFromRequest:(NSURLRequest *)request
                               withCompletionBlock:(void (^)(NSString *latitude, NSString *longitude, NSString *nameOfLocation))completionBlock {
    
    NSDictionary *queryItems = [FISTestHelper createDictionaryOfQueryItemsWithRequest:request];
    
    NSString *latitudeValue = ((NSURLQueryItem *)queryItems[@"locationlatitude"]).value;
    NSString *longitudeValue = ((NSURLQueryItem *)queryItems[@"locationlongitude"]).value;
    NSString *locationName = ((NSURLQueryItem *)queryItems[@"locationname"]).value;
    
    completionBlock(latitudeValue, longitudeValue, locationName);
}

+ (NSString *)extractTriviumFromRequest:(NSURLRequest *)request {
    
    NSDictionary *queryItems = [FISTestHelper createDictionaryOfQueryItemsWithRequest:request];
    
    NSString *trivia = ((NSURLQueryItem *)queryItems[@"triviumcontent"]).value;
    
    return trivia;
}

+ (NSDictionary *)createDictionaryOfQueryItemsWithRequest:(NSURLRequest *)request {
    
    NSString *httpBody = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    
    NSString *modifiedHttpBody = [httpBody stringByReplacingOccurrencesOfString:@"[" withString:@""];
    NSString *httpBodyForURLComponents = [modifiedHttpBody stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    NSURLComponents *comps = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"?%@", httpBodyForURLComponents]];
    
    NSDictionary *queryItems = ASTIndexBy(comps.queryItems, @"name");
    
    return queryItems;
}

+ (OHHTTPStubsResponse *)stubResponseWithType:(StubResponseType)type {
    
    NSString *filePathOfFakeJSON = [[NSBundle mainBundle] pathForResource:@"FakeArrayJSON" ofType:@"json"];
    
    NSString *filePathOfFakeTriviaJSON = [[NSBundle mainBundle] pathForResource:@"FakeTriviaJSON" ofType:@"json"];
    
    NSString *fakeArrayJSON = [[NSBundle mainBundle] pathForResource:@"FakeFinalArrayJSON" ofType:@"json"];
    
    switch (type) {
            
        case Array: {
            
            
            return [OHHTTPStubsResponse responseWithFileAtPath:fakeArrayJSON
                                                    statusCode:200
                                                       headers:@{ @"Content-type": @"application/json"}];
            break;
        }
            
        case Dictionary: {
            
            return [OHHTTPStubsResponse responseWithFileAtPath:filePathOfFakeJSON
                                                    statusCode:200
                                                       headers:@{ @"Content-type": @"application/json"}];
            break;
        }
            
        case TriviaDictionary: {
            
            return [OHHTTPStubsResponse responseWithFileAtPath:filePathOfFakeTriviaJSON
                                                    statusCode:200
                                                       headers:@{ @"Content-type": @"application/json"}];
            break;
        }
            
        default:
            
            return nil;
            break;
    }
}

+ (NSArray *)createFakeArrayJSON {
    
    NSDictionary *fakeSONDict = [FISTestHelper createFakeDictJSON];
    NSArray *fakeSON = @[fakeSONDict];
    
    return fakeSON;
}

+ (NSDictionary *)createFakeDictJSON {
    
    NSDictionary *fakeSONdictionary = @{ @"id": @"939",
                                         @"name": @"coolTown",
                                         @"latitude": @"105",
                                         @"longitude": @"50",
                                         @"trivia": @[ @{ @"id": @"460",
                                                          @"location_id": @"939",
                                                          @"content": @"Is tall",
                                                          @"created_at": @"2015-03-17T15:29:27.743Z",
                                                          @"updated_at": @"2015-03-17T15:29:27.743Z" } ],
                                         @"url": @"https://locationtrivia.herokuapp.com/locations/999.json?key=xxxx" };
    
    return fakeSONdictionary;
}

+ (NSDictionary *)createFakeTrivia {
    
    NSDictionary *fakeTriviaDict = @{ @"content": @"Great restaurants",
                                      @"created_at": @"2015-07-262",
                                      @"id": @"999",
                                      @"location": @{ @"created_at" : @"2015-03",
                                                      @"id": @"939",
                                                      @"latitude": @"55",
                                                      @"longitude": @"100",
                                                      @"name": @"coolPlace",
                                                      @"updated_at": @"2015-05" },
                                      @"updated_at": @"2015-07-2622" };
    
    
    return fakeTriviaDict;
}

@end
