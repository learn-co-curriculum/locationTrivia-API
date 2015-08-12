//
//  FISTestHelper.m
//  locationTrivia-API
//
//  Created by James Campagno on 8/11/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISTestHelper.h"

@interface FISTestHelper ()

+ (NSDictionary *)createDictionaryOfQueryItemsWithRequest:(NSURLRequest *)request;

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


@end