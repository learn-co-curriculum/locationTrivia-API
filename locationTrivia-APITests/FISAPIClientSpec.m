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
#import <Asterism.h>
#import "FISTestHelper.h"

SpecBegin(FISAPIClient)


describe(@"FISAPIClient", ^{
    
    __block NSArray *fakeSON;
    __block NSDictionary *fakeSONdictionary;
    __block id<OHHTTPStubsDescriptor> httpStub;
    __block NSString *name = @"coolTown";
    __block NSNumber *latitude = @100;
    __block NSNumber *longitude = @50;
    __block NSString *idOfLocation = @"939";
    __block NSDictionary *trivaCreated;
    __block NSString *triviaContent = @"Great restaurants";
    
    
    describe(@"requestLocationsWithSuccess:failure:", ^{
        
        beforeEach(^{
            
            [OHHTTPStubs removeAllStubs];
            httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                
                return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
            }
                        
                                           withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                               
                                               expect(request.HTTPMethod).to.equal(@"GET");
                                               
                                               return [FISTestHelper stubResponseWithType:Array];
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
                    expect(dictionaryInArrayOfLocations[@"latitude"]).to.equal(@"105");
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
                    
                    failure(@"The Request Locations method is not implemented correctly.  Make sure you're making the appropiate GET request.");
                    done();
                }];
            });
        });
    });
    
    describe(@"createLocationWithName:Latitude:longitude:withSuccess:failure:", ^{
        
        beforeEach(^{
            
            [OHHTTPStubs removeAllStubs];
            
            httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                
                return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
            }
                                           withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                               
                                               __block NSString *latitudeValue;
                                               __block NSString *longitudeValue;
                                               __block NSString *locationName;
                                               
                                               [FISTestHelper extractLatitudeLongitudeAndNameFromRequest:request
                                                                                     withCompletionBlock:^(NSString *latitude, NSString *longitude, NSString *nameOfLocation) {
                                                                                         
                                                                                         latitudeValue = latitude;
                                                                                         longitudeValue = longitude;
                                                                                         locationName = nameOfLocation;
                                                                                     }];
                                               
                                               
                                               //Testing the parameters of the POST request
                                               expect(request.HTTPMethod).to.equal(@"POST");
                                               expect(locationName).to.equal(@"coolTown");
                                               expect(latitudeValue).to.equal(@"100");
                                               expect(longitudeValue).to.equal(@"50");
                                               
                                               return [FISTestHelper stubResponseWithType:Dictionary];
                                               
                                           }];
        });
        
        it(@"Create parameters dictionary and make a POST request with that dictionary, confirm that the success block gets back a valid location to be parsed", ^{
            
            waitUntil(^(DoneCallback done) {
                
                [[FISAPIClient sharedClient]
                 createLocationWithName:name
                 Latitude:latitude
                 longitude:longitude
                 withSuccess:^(NSDictionary *location) {
                     
                     expect(location).to.beAKindOf([NSDictionary class]);
                     expect(location[@"id"]).to.equal(@"939");
                     expect(location[@"name"]).to.equal(@"coolTown");
                     expect(location[@"latitude"]).to.equal(@"105");
                     expect(location[@"longitude"]).to.equal(@"50");
                     expect(location[@"trivia"]).to.beAKindOf([NSArray class]);
                     
                     //Not testing the locationFromDictionary: method again as it was tested in the above test.
                     
                     done ();
                 } failure:^(NSError *error) {
                     
                     failure(@"The Create Locations method is not implemented correctly.  Make sure you're making the appropiate POST request passing in the correct parameters.");
                     done();
                     
                 }];
            });
        });
    });
    
    describe(@"deleteLocationWithID:withSuccess:failure:", ^{
        
        beforeEach(^{
            
            [OHHTTPStubs removeAllStubs];
            httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
            }
                                           withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                               
                                               NSString *urlFromRequest = [request.URL absoluteString];
                                               
                                               expect(request.HTTPMethod).to.equal(@"DELETE");
                                               expect(urlFromRequest).to.equal(@"http://locationtrivia.herokuapp.com/locations/939.json");
                                               
                                               //If this is set to NIL, test will not run.  The fakeSON needs to be something (in this case, it's an empty array and not reflective of what the user will see in their app.)
                                               fakeSON = @[];
                                               return [OHHTTPStubsResponse responseWithJSONObject:fakeSON
                                                                                       statusCode:200
                                                                                          headers:@{ @"Content-type": @"application/json"}];
                                           }];
        });
        
        it(@"Make a DELETE request, expecting to reach the success block where the responseObject should be (null) and return YES in the success block", ^{
            
            waitUntil(^(DoneCallback done) {
                
                [[FISAPIClient sharedClient]
                 deleteLocationWithID:idOfLocation
                 withSuccess:^(BOOL success) {
                     
                     
                     expect(success).to.equal(YES);
                     
                     done();
                 } failure:^(NSError *error) {
                     
                     failure(@"The Delete Locations method is not implemented correctly.  Make sure you're making the appropiate DELETE request.");
                     done();
                 }];
            });
        });
    });
    
    describe(@"createTriviumWithContent:forLocationWithID:success:failure:", ^{
        
        beforeEach(^{
            
            [OHHTTPStubs removeAllStubs];
            httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
            }
                                           withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                               
                                               NSString *triviaValue = [FISTestHelper extractTriviumFromRequest:request];
                                               
                                               expect(triviaValue).to.equal(@"Great restaurants");
                                               expect(request.HTTPMethod).to.equal(@"POST");
                                               
                                               
                                               return [FISTestHelper stubResponseWithType:TriviaDictionary];
                                              
                                           }];
        });
        
        it(@"Should make a POST request with the correct parameters in creating trivia content for a location ID", ^{
            
            waitUntil(^(DoneCallback done) {
                
                [[FISAPIClient sharedClient]
                 createTriviumWithContent:triviaContent
                 forLocationWithID:idOfLocation
                 success:^(NSDictionary *trivium) {
                     
                     FISTrivia *trivia = [FISTrivia triviumFromDictionary:trivium];
                     NSDictionary *locationFromID = trivium[@"location"];
                     
                     expect(trivium).to.beAKindOf([NSDictionary class]);
                     expect(trivium[@"id"]).to.equal(@"999");
                     expect(trivium[@"content"]).to.equal(@"Great restaurants");
                     
                     expect(locationFromID[@"id"]).to.equal(@"939");
                     
                     //Testing that the triviumFromDictionary: method is properly implemented.  Number of likes isn't stored in the API, it should be instantiated with 0 likes of type NSInteger.
                     expect(trivia).to.beKindOf([FISTrivia class]);
                     expect(trivia.triviaID).to.equal(@"999");
#warning FIX THIS DUDE!
                     //                     expect(trivia.locationID).to.equal(@"939");
                     expect(trivia.content).to.equal(@"Great restaurants");
                     expect(trivia.likes).to.equal(0);
                     
                     done();
                     
                 } failure:^(NSError *error) {
                     
                     failure(@"This should not happen");
                     done();
                     
                 }];
            });
        });
    });
    
    describe(@"deleteTriviumWithID:withLocationID:withSuccess:failure:", ^{
        
        beforeEach(^{
            
            [OHHTTPStubs removeAllStubs];
            httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
            }
                                           withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                               
                                               NSString *urlFromRequest = [request.URL absoluteString];
                                               
                                               expect(request.HTTPMethod).to.equal(@"DELETE");
                                               expect(urlFromRequest).to.equal(@"http://locationtrivia.herokuapp.com/locations/939/trivia/999.json");
                                               
                                               //If this is set to NIL, test will not run.  The fakeSON needs to be something (in this case, it's an empty dictionary and not reflective of what the user will see in their app.)
                                               trivaCreated = @{ };
                                               return [OHHTTPStubsResponse responseWithJSONObject:trivaCreated
                                                                                       statusCode:200
                                                                                          headers:@{ @"Content-type": @"application/json"}];
                                           }];
        });
        
        it(@"Make a DELETE request, expecting to reach the success block where the responseObject should be (null) and return YES in the success block", ^{
            
            waitUntil(^(DoneCallback done) {
                
                [[FISAPIClient sharedClient]
                 deleteTriviumWithID:@"999"
                 withLocationID:@"939"
                 withSuccess:^(BOOL success) {
                     
                     expect(success).to.equal(YES);
                     done();
                     
                 } failure:^(NSError *error) {
                     
                     failure(@"This should not happen");
                     done();
                     
                 }];
            });
        });
    });
});

SpecEnd