//
//  cbrActionOrderViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrActionOrderViewController.h"

@interface cbrActionOrderViewController ()

@end

@implementation cbrActionOrderViewController
@synthesize btnSubmit = _btnSubmit;
@synthesize pickerArray = _pickerArray;
@synthesize kitQuantity = _kitQuantity;
@synthesize detailItem = _detailItem;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];    
    NSString *rmStorageId = [userDef stringForKey:@"rmStorageId"];
    NSString *rmStorage = [userDef stringForKey:@"rmStorage"];

    if (rmStorage != NULL && rmStorageId != NULL)
        self.btnSubmit.enabled = TRUE;
    else 
        self.btnSubmit.enabled = FALSE;
    
    self.pickerArray = [[NSMutableArray alloc] init];
    int i = 10;
    while (i <= 100)
    {
        [self.pickerArray addObject:[NSString stringWithFormat:@"%d",i]];
        i = i + 10;
        
    }
    UIPickerView *myPickerView = [[UIPickerView alloc] init];
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.delegate = self;
    self.kitQuantity.inputView = myPickerView;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    //keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    //keyboardDoneButtonView.translucent = YES;
    //keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(pickerDoneClicked)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer,doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    self.kitQuantity.inputAccessoryView = keyboardDoneButtonView;  
}
- (void)pickerDoneClicked
{
    [self.kitQuantity resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setKitQuantity:nil];
    [self setBtnSubmit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { 
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { 
    return [self.pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 
    return [self.pickerArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
    [self.kitQuantity setText:[self.pickerArray objectAtIndex:row]];
}

- (void)recordTransaction:(NSManagedObject *) obj
{
    NSManagedObjectContext *context = [self.detailItem managedObjectContext];;
    NSManagedObject *newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:context];
    
    NSDate *today = [NSDate date];
    
    //current location
    CLLocationManager *clm = [[CLLocationManager alloc] init];
    
    //self.locationManager.delegate = self;
    clm.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    // Set a movement threshold for new events.
    clm.distanceFilter = 500;
    
    [clm startUpdatingLocation];
    
    CLLocation *myLocation = [clm location];
    
    [newTransaction setValue:@"Order" forKey:@"entityType"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.latitude] forKey:@"latitude"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.longitude] forKey:@"longitude"];
    [newTransaction setValue:today forKey:@"transactionDate"];
    [newTransaction setValue:@"Create" forKey:@"transactionType"];
    
    [clm stopUpdatingLocation];
    
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    
    [context save:nil];
}



#pragma mark - Table view data source
- (IBAction)submitOrder:(id)sender {
    NSString *errorMsg = @"";

    if([self.kitQuantity.text isEqualToString:@"0"] || [self.kitQuantity.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Request must be greater than 0"];
    }
    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSManagedObjectContext *moc = [self.detailItem managedObjectContext];
        NSManagedObject *newOrder = [NSEntityDescription insertNewObjectForEntityForName:@"Orders" inManagedObjectContext:moc];

        [newOrder setValue:@"Open" forKey:@"status"];

        [newOrder setValue:[NSNumber numberWithInteger:[self.kitQuantity.text integerValue]] forKey:@"quantityRequested"];
        [newOrder setValue:@"" forKey:@"contactId"];
        [newOrder setValue:[self.detailItem valueForKey:@"rowId"] forKey:@"officeId"];
        
        if (self.detailItem != nil)
            [newOrder setValue:self.detailItem forKey:@"office"];
        
        [moc save:nil];
        
        [self recordTransaction:newOrder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}
- (IBAction)cancelOrder:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}
@end
