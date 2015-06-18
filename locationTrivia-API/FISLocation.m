//
//  FISLocation.m
//  locationTrivia-Objects
//
//  Created by Joe Burgess on 5/15/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISLocation.h"
#import "FISAPIClient.h"

@implementation FISLocation
+ (FISLocation *)locationFromDictionary:(NSDictionary *)locationDictionary
{
    NSString *name = locationDictionary[@"name"];
    NSString *latitude = locationDictionary[@"latitude"];
    NSString *longitude = locationDictionary[@"longitude"];
    FISLocation *newLocation = [[FISLocation alloc] initWithName:name Latitude:@([latitude floatValue]) Longitude:@([longitude floatValue])locationID:locationDictionary[@"id"]];
    
    NSArray *triviaArray = locationDictionary[@"trivia"];
    
    for (NSDictionary *triviumDictionary in triviaArray) {
        [newLocation.trivia addObject:[FISTrivia triviumFromDictionary:triviumDictionary]];
    }
    
    return newLocation;
}

- (instancetype)initWithName:(NSString *)name Latitude:(NSNumber *)latitude Longitude:(NSNumber *)longitude locationID:(NSString *)locationID
{
    self = [super init];
    if (self) {
        _locationID=locationID;
        _name=name;
        _latitude=latitude;
        _longitude=longitude;
        _trivia = [[NSMutableArray alloc] init];
    }

    return self;
    
}

-(id)initWithName:(NSString *)name Latitude:(NSNumber *)latitude Longitude:(NSNumber *)longitude
{
    return [self initWithName:name Latitude:latitude Longitude:longitude locationID:@""];
}

- (instancetype)init
{
    return [self initWithName:@"" Latitude:@0 Longitude:@0 locationID:@""];
}

- (NSString *)shortenedNameToLength:(NSInteger)length
{
    if (length <0) {
        return self.name;
    }
    return [self.name substringToIndex:length];
}


-(BOOL)verifyLocation
{
    CGFloat lat = [self.latitude floatValue];
    CGFloat lng = [self.longitude floatValue];

    BOOL validLat = lat>=-90.0 && lat <=90.0;
    BOOL validLng = lng>=-180.0 && lng <=180.0;

    if (![self.name isEqualToString:@""]&& validLat && validLng) {
        return YES;
    }
    return NO;
}

- (FISTrivia *)topTrivia
{
    if ([self.trivia count]==0) {
        return nil;
    }
    FISTrivia *topTrivia = self.trivia[0];
    for (FISTrivia *trivium in self.trivia) {
        if (topTrivia.likes < trivium.likes) {
            topTrivia = trivium;
        }
    }
    return topTrivia;
}

-(NSString *)numberOfTriva
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[self.trivia count]];
}

- (void)addTrivium:(FISTrivia *)trivium withCompletionBlock:(void (^)(BOOL, NSError *))completion
{
    [[FISAPIClient sharedClient] createTriviumWithContent:trivium.content forLocationWithID:trivium.locationID success:^(NSDictionary *triviumDictionary) {
        trivium.triviaID = triviumDictionary[@"id"];
        [self.trivia addObject:trivium];
        completion(YES, nil);
    } failure:^(NSError *error) {
        completion(NO, error);
    }];
}

- (void)deleteTrivium:(FISTrivia *)trivium withCompletionBlock:(void (^)(BOOL, NSError *))completion
{
    [[FISAPIClient sharedClient] deleteTriviumWithID:trivium.triviaID withLocationID:trivium.locationID withSuccess:^(BOOL success) {
        if (success) {
            [self.trivia removeObject:trivium];
            completion(YES, nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        completion(NO, error);
    }];
}

@end
