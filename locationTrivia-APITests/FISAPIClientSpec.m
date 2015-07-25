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
    __block NSString *name = @"coolTown";
    __block NSNumber *latitude = @100;
    __block NSNumber *longitude = @50;
    

    describe(@"requestLocationsWithSuccess:failure:", ^{
        
        beforeEach(^{
            
            [OHHTTPStubs removeAllStubs];
            httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                
                return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
            }
                                           withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                            
                                               fakeSON = @[ @{ @"id": @"939",
                                                               @"name": name,
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

        it(@"should make a GET request with AFHTTPRequestOperationManager object, should get back responseObject containing FISLocations", ^{
            
            waitUntil(^(DoneCallback done) {
                
                [[FISAPIClient sharedClient] requestLocationsWithSuccess:^(NSArray *locations) {
                    
                    NSDictionary *dictionaryInArrayOfLocations = locations[0];
                    FISLocation *locationFromRequest = [FISLocation locationFromDictionary:locations[0]];
                    
                    expect(locations).to.beAKindOf([NSArray class]);
                    
                    expect(dictionaryInArrayOfLocations).to.beAKindOf([NSDictionary class]);
                    expect(dictionaryInArrayOfLocations[@"id"]).to.equal(@"939");
                    expect(dictionaryInArrayOfLocations[@"name"]).to.equal(@"coolTown");
                    expect(dictionaryInArrayOfLocations[@"latitude"]).to.equal(@"100");
                    expect(dictionaryInArrayOfLocations[@"longitude"]).to.equal(@"50");
                    expect(dictionaryInArrayOfLocations[@"trivia"]).to.beAKindOf([NSArray class]);
                    expect(dictionaryInArrayOfLocations[@"url"]).to.beAKindOf([NSString class]);
                    
                    //Testing that the locationFromDictionary: method is properly implemented.
                    expect(locationFromRequest).to.beKindOf([FISLocation class]);
                    expect(locationFromRequest.name).to.equal(@"coolTown");
                    expect(locationFromRequest.latitude).to.equal(@100);
                    expect(locationFromRequest.longitude).to.equal(@50);
                    
                    done();
                    
                } failure:^(NSError *error) {
                    
                    failure(@"This should not happen");
                    done();
                }];
            });
        });
    });
    
    
    
    
//    describe(@"createLocationWithName:Latitude:longitude:withSuccess:failure:", ^{
//        
//        
//        
//        beforeAll(^{
//            
//            [OHHTTPStubs removeAllStubs];
//            
//            httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//                
//                return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
//            }
//                                           withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
//                                               
//                                               fakeSON = @[ @{ @"id": @"939",
//                                                               @"name": name,
//                                                               @"latitude": @"105",
//                                                               @"longitude": @"50",
//                                                               @"trivia": @[ @{ @"id": @"460",
//                                                                                @"location_id": @"939",
//                                                                                @"content": @"Is tall",
//                                                                                @"created_at": @"2015-03-17T15:29:27.743Z",
//                                                                                @"updated_at": @"2015-03-17T15:29:27.743Z" } ],
//                                                               @"url": @"https://locationtrivia.herokuapp.com/locations/999.json?key=xxxx" } ];
//                                               
//                                               return [OHHTTPStubsResponse responseWithJSONObject:fakeSON
//                                                                                       statusCode:200
//                                                                                          headers:@{ @"Content-type": @"application/json"}];
//                                           }];
//        });
//
//        
//        
//        it(@"Create parameters dictionary and make a POST request with that dictionary, confirm that the success block gets back a valid location to be parsed", ^{
//            
//            waitUntil(^(DoneCallback done) {
//                
//                [[FISAPIClient sharedClient]
//                 createLocationWithName:name
//                 Latitude:latitude
//                 longitude:longitude
//                 withSuccess:^(NSDictionary *location) {
//                     
//                     //The next two lines of code are to properly reflect that the success block contains an NSDictionary "location".  Our stub (createved in the before each block) has this returning an array for the prior test (converting to propertly reflect what the actual method should contain).
//                     NSArray *actualLocation = (NSArray *)location;
//                     NSDictionary *locationFromSuccess = actualLocation[0];
//                     
//                     expect(locationFromSuccess).to.beAKindOf([NSDictionary class]);
//                     expect(locationFromSuccess[@"id"]).to.equal(@"939");
//                     expect(locationFromSuccess[@"name"]).to.equal(@"coolTown");
//                     expect(locationFromSuccess[@"latitude"]).to.equal(@"105");
//                     expect(locationFromSuccess[@"longitude"]).to.equal(@"50");
//                     expect(locationFromSuccess[@"trivia"]).to.beAKindOf([NSArray class]);
//                     
//                     //Not testing the locationFromDictionary: method again as it was tested in the above test.
//                             
//                     done ();
//                     
//                 } failure:^(NSError *error) {
//                     
//                     failure(@"This should not happen");
//                     done();
//                     
//                 }];
//            });
//        });
//    });
    
    
    
    
    
    
    
});

afterEach(^{
    
});

afterAll(^{
    
});

SpecEnd

