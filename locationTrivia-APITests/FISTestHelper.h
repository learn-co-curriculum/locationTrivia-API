//
//  FISTestHelper.h
//  locationTrivia-API
//
//  Created by James Campagno on 8/11/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Asterism.h>

@interface FISTestHelper : NSObject

+ (void)extractLatitudeLongitudeAndNameFromRequest:(NSURLRequest *)request
                               withCompletionBlock:(void (^)(NSString *latitude, NSString *longitude, NSString *nameOfLocation))completionBlock;

@end