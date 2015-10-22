//
//  cbrHospitalAddViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrHospitalAddViewController.h"


@implementation cbrHospitalAddViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize locationManager = _locationManager;
@synthesize nameField = _nameField;
@synthesize addrField = _addrField;
@synthesize addr2Field = _addr2Field;
@synthesize cityField = _cityField;
@synthesize stateField = _stateField;
@synthesize zipField = _zipField;
@synthesize phoneField = _phoneField;
@synthesize faxField = _faxField;

- (void)setDetailItem:(id)newObjectContext
{
    if (_managedObjectContext != newObjectContext) {
        _managedObjectContext = newObjectContext;
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setAddrField:nil];
    [self setAddr2Field:nil];
    [self setCityField:nil];
    [self setStateField:nil];
    [self setZipField:nil];
    [self setPhoneField:nil];
    [self setFaxField:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.faxField || theTextField == self.nameField || theTextField == self.addrField || theTextField == self.addr2Field || theTextField == self.cityField || theTextField == self.stateField || theTextField == self.zipField || theTextField == self.phoneField){
        [theTextField resignFirstResponder];
    }
    return NO;
}

- (IBAction)saveRecord:(id)sender { 
    NSString *errorMsg = @"";
    
    if([self.nameField.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Name is required"];
    }
    if([self.addrField.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Address is required"];
    }
    if([self.cityField.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"City is required"];
    }
    if([self.stateField.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"State is required"];
    }
    if([self.zipField.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Zipcode is required"];
    }
    
    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSManagedObjectContext *context = self.managedObjectContext;
        NSManagedObject *newOffice = [NSEntityDescription insertNewObjectForEntityForName:@"Offices" inManagedObjectContext:context];
        [newOffice setValue:self.addrField.text forKey:@"addr"];
        [newOffice setValue:self.addr2Field.text forKey:@"addr2"];
        [newOffice setValue:self.cityField.text forKey:@"city"];
        [newOffice setValue:self.stateField.text forKey:@"state"];
        [newOffice setValue:self.zipField.text forKey:@"zipcode"];
        [newOffice setValue:self.phoneField.text forKey:@"mainPhone"];
        [newOffice setValue:self.faxField.text forKey:@"mainFax"];
        [newOffice setValue:self.nameField.text forKey:@"name"];
        [newOffice setValue:@"N" forKey:@"momentumRating"];
        [newOffice setValue:@"Hospital" forKey:@"officeType"];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self recordTransaction:newOffice];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)recordTransaction:(NSManagedObject *) obj
{
    NSManagedObjectContext *context = self.managedObjectContext;
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
    
    [newTransaction setValue:[[obj valueForKey:@"rowId"] description] forKey:@"entityId"];
    [newTransaction setValue:@"Facility" forKey:@"entityType"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.latitude] forKey:@"latitude"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.longitude] forKey:@"longitude"];
    [newTransaction setValue:today forKey:@"transactionDate"];
    [newTransaction setValue:@"Create" forKey:@"transactionType"];
    
    [clm stopUpdatingLocation];
    
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    
    [context save:nil];
}
@end
