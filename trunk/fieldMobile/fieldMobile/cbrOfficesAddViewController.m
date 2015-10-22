//
//  cbrOfficesAddViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrAppDelegate.h"
#import "cbrOfficesAddViewController.h"

@implementation cbrOfficesAddViewController
@synthesize fieldName = _fieldName;
@synthesize fieldAddr = _fieldAddr;
@synthesize fieldAddr2 = _fieldAddr2;
@synthesize fieldCity = _fieldCity;
@synthesize fieldState = _fieldState;
@synthesize fieldZip = _fieldZip;
@synthesize fieldPhone = _fieldPhone;
@synthesize fieldFax = _fieldFax;
@synthesize fieldURL = _fieldURL;
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.managedObjectContext == nil) 
	{
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
}

- (void)viewDidUnload
{
    [self setFieldName:nil];
    [self setFieldAddr:nil];
    [self setFieldAddr2:nil];
    [self setFieldCity:nil];
    [self setFieldState:nil];
    [self setFieldZip:nil];
    [self setFieldPhone:nil];
    [self setFieldFax:nil];
    [self setFieldURL:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Table view delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.fieldName || theTextField == self.fieldAddr2 || theTextField == self.fieldAddr || theTextField == self.fieldCity || theTextField == self.fieldState || theTextField == self.fieldZip || theTextField == self.fieldFax || theTextField == self.fieldPhone || theTextField == self.fieldURL){
        [theTextField resignFirstResponder];
    }
    return NO;
}

- (IBAction)saveOffice:(id)sender {
    
    NSString *errorMsg = @"";
    if([self.fieldName.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Office Name is required"];
    }
    if([self.fieldAddr.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Address is required"];
    }
    if([self.fieldCity.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"City is required"];
    }
    if([self.fieldState.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"State is required"];
    }
    if([self.fieldZip.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Zip Code is required"];
    }

    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSManagedObjectContext *context = self.managedObjectContext;
        NSManagedObject *newOffice = [NSEntityDescription insertNewObjectForEntityForName:@"Offices" inManagedObjectContext:context];
    
        [newOffice setValue:@"N" forKey:@"momentumRating"];
        [newOffice setValue:@"Office" forKey:@"officeType"];
    
        [newOffice setValue:self.fieldName.text forKey:@"name"];
        [newOffice setValue:self.fieldAddr.text forKey:@"addr"];
        [newOffice setValue:self.fieldAddr2.text forKey:@"addr2"];
        [newOffice setValue:self.fieldCity.text forKey:@"city"];
        [newOffice setValue:self.fieldState.text forKey:@"state"];
        [newOffice setValue:self.fieldZip.text forKey:@"zipcode"];
        [newOffice setValue:self.fieldFax.text forKey:@"mainFax"];
        [newOffice setValue:self.fieldPhone.text forKey:@"mainPhone"];
        [newOffice setValue:self.fieldURL.text forKey:@"url"];
        
        [self recordTransaction:newOffice];
        
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
    
    //[context save:nil];
}
@end
