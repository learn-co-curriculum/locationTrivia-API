//
//  FISLocationsDataStore.h
//  locationTrivia-dataStore
//
//  Created by Joe Burgess on 6/23/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FISLocation;

@interface FISLocationsDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *locations;
+ (instancetype)sharedLocationsDataStore;
- (instancetype)init;
- (void)fetchLocationsWithCompletionBlock:(void (^)(BOOL success, NSError *error))completion;
- (void)addLocation:(FISLocation *)location withCompletionBlock:(void (^)(BOOL success, NSError *error))completion;
- (void)deleteLocation:(FISLocation *)location withCompletionBlock:(void (^)(BOOL success, NSError *error))completion;
@end
