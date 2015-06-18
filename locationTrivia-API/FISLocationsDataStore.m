//
//  FISLocationsDataStore.m
//  locationTrivia-dataStore
//
//  Created by Joe Burgess on 6/23/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISLocationsDataStore.h"
#import "FISAPIClient.h"
#import "FISLocation.h"

@implementation FISLocationsDataStore


+ (instancetype)sharedLocationsDataStore {
    static FISLocationsDataStore *_sharedLocationsDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationsDataStore = [[FISLocationsDataStore alloc] init];
    });

    return _sharedLocationsDataStore;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locations = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)fetchLocationsWithCompletionBlock:(void (^)(BOOL, NSError *))completion
{
    [[FISAPIClient sharedClient] requestLocationsWithSuccess:^(NSArray *locationDictionaries) {
        for (NSDictionary *locationDictionary in locationDictionaries) {
            [self.locations addObject:[FISLocation locationFromDictionary:locationDictionary]];
        }
        
        completion(YES, nil);
    } failure:^(NSError *error) {
        completion(NO, error);
    }];
}

- (void)addLocation:(FISLocation *)location withCompletionBlock:(void (^)(BOOL, NSError *))completion
{
    [[FISAPIClient sharedClient] createLocationWithName:location.name Latitude:location.latitude longitude:location.longitude withSuccess:^(NSDictionary *locationDictionary) {
        // need to store the location ID that is returned
        location.locationID = locationDictionary[@"id"];
        [self.locations addObject:location];
        completion(YES, nil);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        completion(NO, error);
    }];
}

- (void)deleteLocation:(FISLocation *)location withCompletionBlock:(void (^)(BOOL, NSError *))completion
{
    [[FISAPIClient sharedClient] deleteLocationWithID:location.locationID withSuccess:^(BOOL success) {
        if (success) {
            [self.locations removeObject:location];
            completion(YES, nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        completion(NO, error);
    }];
}

@end
