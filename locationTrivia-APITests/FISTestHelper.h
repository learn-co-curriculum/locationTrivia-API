//
//  FISTestHelper.h
//  locationTrivia-API
//
//  Created by James Campagno on 8/11/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Asterism.h>
#import <OHHTTPStubs.h>


@interface FISTestHelper : NSObject

typedef NS_ENUM(NSInteger, StubResponseType) {
    Dictionary,
    Array,
    TriviaDictionary,
};

+ (void)extractLatitudeLongitudeAndNameFromRequest:(NSURLRequest *)request
                               withCompletionBlock:(void (^)(NSString *latitude, NSString *longitude, NSString *nameOfLocation))completionBlock;

+ (NSString *)extractTriviumFromRequest:(NSURLRequest *)request;

+ (OHHTTPStubsResponse *)stubResponseWithType:(StubResponseType)type;

@end