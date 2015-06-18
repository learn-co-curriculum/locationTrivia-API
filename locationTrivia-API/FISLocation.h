//
//  FISLocation.h
//  locationTrivia-Objects
//
//  Created by Joe Burgess on 5/15/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISTrivia.h"

@interface FISLocation : NSObject

@property (strong, nonatomic) NSString *locationID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSMutableArray *trivia;

+ (FISLocation *)locationFromDictionary:(NSDictionary *)locationDictionary;

- (id) initWithName:(NSString *)name Latitude:(NSNumber *)latitude Longitude:(NSNumber *)longitude;

- (NSString *)shortenedNameToLength:(NSInteger)length;
- (BOOL)verifyLocation;
- (FISTrivia *)topTrivia;
- (void)addTrivium:(FISTrivia *)trivium withCompletionBlock:(void (^)(BOOL, NSError *))completion;
- (void)deleteTrivium:(FISTrivia *)trivium withCompletionBlock:(void (^)(BOOL, NSError *))completion;

-(NSString *)numberOfTriva;

@end
