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
                                               
                                               NSString *requestType = request.HTTPMethod;
                                               
                                               expect(requestType).to.equal(@"GET");
                                               
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
    
    describe(@"createLocationWithName:Latitude:longitude:withSuccess:failure:", ^{
        
        beforeEach(^{
            
            [OHHTTPStubs removeAllStubs];
            
            httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                
                return [request.URL.host isEqualToString:@"locationtrivia.herokuapp.com"];
            }
                                           withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                                               
                                               NSString *requestType = request.HTTPMethod;
                                               
                                               NSString *stuff = [NSString stringWithUTF8String:(char*)[[request HTTPBody] bytes]];
                                               NSURLComponents *comps = [NSURLComponents componentsWithString:@"?a=b&c=d"];
                                               
                                               NSDictionary *queryItems = ASTIndexBy(comps.queryItems, @"name");
                                               NSLog(@"%@", ((NSURLQueryItem *)queryItems[@"a"]).value);
                                               
                                               
                                               
                                               NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
                                               
                                               
                                               NSLog(@"COmponenets; %@", urlComponents);
                                               NSArray *queryItems = urlComponents.queryItems;
//                                               NSString *param1 = [self valueForKey:@"longitude" fromQueryItems:queryItems];
                                               
                                               NSLog(@"Michael Jordan: %@", queryItems);
                                               
                    
                                               
//                                               - (NSString *)valueForKey:(NSString *)key
//                                           fromQueryItems:(NSArray *)queryItems
//                                               {
                                                   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", @"longitude"];
                                                   NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate]
                                                                                firstObject];
                                               
                                               NSLog(@"IS THERE A VALUE HERE: %@", queryItem);
                                                   NSString *queryThing =  queryItem.value;
                                               
                                               
                                               NSLog(@"WHAT IS IN THIS GOD DAMN THING!!: %@", queryThing);
//                                               }
                                               
                                               NSString *theThing = [NSURLProtocol propertyForKey:@"name" inRequest:request];
                                               
                                               
                                               NSLog(@"THIS SHOULD BE ITTT*@*@*@*@*@ %@", theThing);
                                               
                                               NSLog(@"---------------------------------------------");
                                               
                                               NSLog(@"%@", stuff);
                                               
                                               
                                               NSLog(@"---------------------------------------------");

                                               
                                              
                                               
                                               expect(requestType).to.equal(@"POST");
                                               
                                               
                                               
//                                               @property (readonly, copy) NSDictionary *allHTTPHeaderFields;
//                                               
//                                               
//                                               @property (readonly, copy) NSData *HTTPBody;
//                                               
//                                               @property (readonly, retain) NSInputStream *HTTPBodyStream;
                                               
                                               

                                               fakeSONdictionary = @{ @"id": @"939",
                                                                      @"name": name,
                                                                      @"latitude": @"105",
                                                                      @"longitude": @"50",
                                                                      @"trivia": @[ @{ @"id": @"460",
                                                                                       @"location_id": @"939",
                                                                                       @"content": @"Is tall",
                                                                                       @"created_at": @"2015-03-17T15:29:27.743Z",
                                                                                       @"updated_at": @"2015-03-17T15:29:27.743Z" } ],
                                                                      @"url": @"https://locationtrivia.herokuapp.com/locations/999.json?key=xxxx" };
                                               
                                               return [OHHTTPStubsResponse responseWithJSONObject:fakeSONdictionary
                                                                                       statusCode:200
                                                                                          headers:@{ @"Content-type": @"application/json"}];
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
                     
                     failure(@"This should not happen");
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
                                               
                                               NSString *requestType = request.HTTPMethod;
                                               
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
                     
                     //This test will still pass if the user makes any form of request (GET, POST, etc.).  This goes under the assumption that a DELETE request is made using the id of the location in the method.
                     expect(success).to.equal(YES);
                     
                     done();
                 } failure:^(NSError *error) {
                     
                     failure(@"This should not happen");
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
                                               
                                               NSString *requestType = request.HTTPMethod;
                                               
                                               trivaCreated = @{ @"content": triviaContent,
                                                                 @"created_at": @"2015-07-262",
                                                                 @"id": @"999",
                                                                 @"location": @{ @"created_at" : @"2015-03",
                                                                                 @"id": idOfLocation,
                                                                                 @"latitude": @"55",
                                                                                 @"longitude": @"100",
                                                                                 @"name": @"coolPlace",
                                                                                 @"updated_at": @"2015-05" },
                                                                 @"updated_at": @"2015-07-2622" };
                                               return [OHHTTPStubsResponse responseWithJSONObject:trivaCreated
                                                                                       statusCode:200
                                                                                          headers:@{ @"Content-type": @"application/json"}];
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
                     expect(trivia.locationID).to.equal(@"939");
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
                                               
                                               NSString *requestType = request.HTTPMethod;
                                               
                                               NSLog(@"=*=*=*=*=*=*=* Request Type: %@", requestType);
                                               
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
                     
                     //This test will still pass if the user makes any form of request (GET, POST, etc.).  This goes under the assumption that a DELETE request is made using the triviumID and location ID
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