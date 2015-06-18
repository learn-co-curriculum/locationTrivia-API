//
//  FISAddTriviaViewController.m
//  locationTrivia-dataStore
//
//  Created by Zachary Drossman on 6/24/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISAddTriviaViewController.h"
#import "FISTrivia.h"

@interface FISAddTriviaViewController ()

@property (strong, nonatomic) IBOutlet UITextField *addtriviaTextField;

@end

@implementation FISAddTriviaViewController

- (IBAction)saveTrivia:(id)sender {
    FISTrivia *triviaItem = [[FISTrivia alloc] initWithContent:self.addtriviaTextField.text Likes:0];
    triviaItem.locationID = self.location.locationID;
    
    // need to do strongself/weakself dance to avoid retain cycle
    __weak typeof (self) weakSelf = self;
    [self.location addTrivium:triviaItem withCompletionBlock:^(BOOL success, NSError *error) {
        typeof (self) strongSelf = weakSelf;
        if (success) {
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
