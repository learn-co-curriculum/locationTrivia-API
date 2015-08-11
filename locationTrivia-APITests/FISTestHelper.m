//
//  FISTestHelper.m
//  locationTrivia-API
//
//  Created by James Campagno on 8/11/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISTestHelper.h"

@implementation FISTestHelper

+ (void)extractLatitudeLongitudeAndNameFromRequest:(NSURLRequest *)request
                               withCompletionBlock:(void (^)(NSString *latitude, NSString *longitude, NSString *nameOfLocation))completionBlock {
    
    NSString *httpBody = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    
    NSString *modifiedHttpBody = [httpBody stringByReplacingOccurrencesOfString:@"[" withString:@""];
    NSString *httpBodyForURLComponents = [modifiedHttpBody stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    NSURLComponents *comps = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"?%@", httpBodyForURLComponents]];
    
    NSDictionary *queryItems = ASTIndexBy(comps.queryItems, @"name");

    NSString *latitudeValue = ((NSURLQueryItem *)queryItems[@"locationlatitude"]).value;
    NSString *longitudeValue = ((NSURLQueryItem *)queryItems[@"locationlongitude"]).value;
    NSString *locationName = ((NSURLQueryItem *)queryItems[@"locationname"]).value;
    
    completionBlock(latitudeValue, longitudeValue, locationName);
}

@end