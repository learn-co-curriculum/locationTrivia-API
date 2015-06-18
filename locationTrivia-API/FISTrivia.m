//
//  FISTrivia.m
//  locationTrivia-Objects
//
//  Created by Joe Burgess on 5/15/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISTrivia.h"

@implementation FISTrivia
+ (FISTrivia *)triviumFromDictionary:(NSDictionary *)triviumDictionary
{
    return [[FISTrivia alloc] initWithContent:triviumDictionary[@"content"] Likes:0 triviaID:triviumDictionary[@"id"] locationID:triviumDictionary[@"location_id"]];
}

- (instancetype)initWithContent:(NSString *)content Likes:(NSInteger)likes triviaID:(NSString *)triviaID locationID:(NSString *)locationID
{
    self = [super init];

    if (self)
    {
        _content = content;
        _likes=likes;
        _triviaID=triviaID;
        _locationID=locationID;
    }

    return self;
}

- (id)initWithContent:(NSString *)content Likes:(NSInteger)likes
{
    return [self initWithContent:content Likes:likes triviaID:@"" locationID:@""];
}

- (instancetype)init
{
    return [self initWithContent:@"" Likes:0 triviaID:@"" locationID:@""];
}
@end
