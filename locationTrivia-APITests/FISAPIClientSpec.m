//
//  APIClientSpec.m
//  locationTrivia-API
//
//  Created by James Campagno on 6/3/15.
//  Copyright 2015 Joe Burgess. All rights reserved.
//

#import "Specta.h"
#import "FISAPIClient.h"
#import "FISAppDelegate.h"
#import "OHHTTPStubs.h"
#import <Forecastr.h>
#import "FISLocation.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import <AFNetworking.h>

SpecBegin(FISAPIClient)

describe(@"FISAPIClient", ^{
    
    __block NSArray *fakeSON;
    __block id<OHHTTPStubsDescriptor> httpStub;
    
    beforeEach(^{
        
        [OHHTTPStubs removeAllStubs];
        
        httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            
            return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
        }
                                       withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                           
                                           fakeSON = @[ @{ @"id": @"939",
                                                           @"name": @"coolTown",
                                                           @"latitude": @"100",
                                                           @"longitude": @"50",
                                                           @"trivia": @[ @{ @"id": @"460",
                                                                            @"location_id": @"939",
                                                                            @"content": @"Is tall",
                                                                            @"created_at": @"2015-03-17T15:29:27.743Z",
                                                                            @"updated_at": @"2015-03-17T15:29:27.743Z" } ],
                                                           @"url": @"https://locationtrivia.herokuapp.com/locations/999.json?key=xxxx" } ];
                                           
                                           return [OHHTTPStubsResponse responseWithJSONObject:fakeSON
                                                                                   statusCode:200
                                                                                      headers:@{ @"Content-type": @"application/json"}];
                                       }];
    });
    
    
    describe(@"requestLocationsWithSuccess:failure:", ^{
        it(@"should make a GET request with AFHTTPRequestOperationManager object, should get back responseObject containing FISLocations", ^{
            
            waitUntil(^(DoneCallback done) {
                
                [[FISAPIClient sharedClient] requestLocationsWithSuccess:^(NSArray *locations) {
                    
                    
                    //check on locations.
                    
                    NSDictionary *dictionaryInArrayOfLocations = locations[0];
                    
                    expect(locations).to.beAKindOf([NSArray class]);
                    
                    expect(dictionaryInArrayOfLocations).to.beAKindOf([NSDictionary class]);
                    expect(dictionaryInArrayOfLocations[@"id"]).to.equal(@"939");
                    expect(dictionaryInArrayOfLocations[@"name"]).to.equal(@"coolTown");
                    expect(dictionaryInArrayOfLocations[@"latitude"]).to.equal(@"100");
                    expect(dictionaryInArrayOfLocations[@"longitude"]).to.equal(@"50");
                    
                    expect(dictionaryInArrayOfLocations[@"trivia"]).to.beAKindOf([NSArray class]);
                    expect(dictionaryInArrayOfLocations[@"url"]).to.beAKindOf([NSString class]);

                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    FISLocation *location = [FISLocation locationFromDictionary:locations[0]];
                    
                    //Run the tests needed
                    expect(location).to.beKindOf([FISLocation class]);
                    expect(location.name).to.equal(@"coolTown");
                    expect(location.latitude).to.equal(@100);
                    expect(location.longitude).to.equal(@50);
                    
                    done();
                    
                } failure:^(NSError *error) {
                    
                    failure(@"This should not happen");
                    
                    done();
                }];
                
            });
            
        });
    });
    
});

afterEach(^{
    
});

afterAll(^{
    
});

SpecEnd

