//
//  FISLocationsTableViewController.h
//  locationTrivia-tableviews
//
//  Created by Joe Burgess on 6/20/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISLocationsDataStore.h"

@interface FISLocationsTableViewController : UITableViewController
@property (strong, nonatomic) FISLocationsDataStore *store;
@end
