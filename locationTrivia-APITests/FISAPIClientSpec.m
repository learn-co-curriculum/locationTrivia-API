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
        
        httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request)
                    {
                        return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
                    }
                                       withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request)
                    {
                        fakeSON = @[@{@"name": @"coolTown",
                                      @"latitude": @"100",
                                      @"longitude": @"50"}];
                        
                        return [OHHTTPStubsResponse responseWithJSONObject:fakeSON
                                                                statusCode:200
                                                                   headers:@{ @"Content-type": @"application/json"}];
                    }];
    });
    
    describe(@"requestLocationsWithSuccess:failure:", ^{
        it(@"should make a GET request with AFHTTPRequestOperationManager object, should get back responseObject containing FISLocations", ^{
            
            waitUntil(^(DoneCallback done) {
                [[FISAPIClient sharedClient] requestLocationsWithSuccess:^(NSArray *locations) {
                    
                    FISLocation *location = [FISLocation locationFromDictionary:locations[0]];
                    
                    //Run the tests needed
                    expect(location).to.beKindOf([FISLocation class]);
                    expect(location.name).to.equal(@"coolTown");
                    expect(location.latitude).to.equal(@100);
                    expect(location.longitude).to.equal(@50);
                    
                    done();
                } failure:^(NSError *error) {
                    
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

