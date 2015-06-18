//
//  FISAddLocationViewController.m
//  locationTrivia-dataStore
//
//  Created by swift on 6/23/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISAddLocationViewController.h"
#import "FISLocationsDataStore.h"
#import "FISLocation.h"
#import "FISAPIClient.h"

@interface FISAddLocationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *latitudeInput;
@property (weak, nonatomic) IBOutlet UITextField *longitudeInput;

@end

@implementation FISAddLocationViewController



- (IBAction)saveLocation:(id)sender {
    FISLocationsDataStore *store;
    store = [FISLocationsDataStore sharedLocationsDataStore];
    FISLocation *newLocation = [[FISLocation alloc]init];
    newLocation.name = self.nameInput.text;
    newLocation.latitude = @([self.latitudeInput.text floatValue]);
    newLocation.longitude = @([self.longitudeInput.text floatValue]);
    [store addLocation:newLocation withCompletionBlock:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"Location not created! \n%@", error);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
