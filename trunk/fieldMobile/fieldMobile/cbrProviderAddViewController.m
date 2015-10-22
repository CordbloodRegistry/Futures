//
//  cbrProviderAddViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrAppDelegate.h"
#import "cbrProviderAddViewController.h"
#import "cbrOfficesChooseViewController.h"

@implementation cbrProviderAddViewController

@synthesize firstNameField = _firstNameField;
@synthesize lastNameField = _lastNameField;
@synthesize credentialField = _credentialField;
@synthesize classificationField = _classificationField;
@synthesize officePhoneField = _officePhoneField;
@synthesize officeFaxField = _officeFaxField;
@synthesize cellField = _cellField;
@synthesize emailField = _emailField;
@synthesize lblOffice = _lblOffice;
@synthesize saveButton = _saveButton;
@synthesize pickerCredentialArray = _pickerCredentialArray;
@synthesize pickerClassificationArray = _pickerClassificationArray;
@synthesize officeItem = _officeItem;

@synthesize managedObjectContext = _managedObjectContext;


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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.firstNameField || theTextField == self.lastNameField || theTextField == self.credentialField || theTextField == self.classificationField || theTextField == self.emailField || theTextField == self.drBirthYear || theTextField == self.continuum || theTextField == self.officeHours){
        [theTextField resignFirstResponder];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == self.officeHours)
        return (textField.text.length < 250);
    else
        return YES;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.managedObjectContext == nil) 
	{
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    if (self.officeItem == nil)
    {
        self.saveButton.enabled = NO;
    }


        self.pickerCredentialArray = [[NSMutableArray alloc] init];
        [self.pickerCredentialArray addObject:@""];
        [self.pickerCredentialArray addObject:@"MD"];
        [self.pickerCredentialArray addObject:@"DO"];
        [self.pickerCredentialArray addObject:@"CNM"];
        [self.pickerCredentialArray addObject:@"LM"];
        [self.pickerCredentialArray addObject:@"CPM"];
        [self.pickerCredentialArray addObject:@"RN"];
        [self.pickerCredentialArray addObject:@"NP"];
        [self.pickerCredentialArray addObject:@"PA-C"];
        [self.pickerCredentialArray addObject:@"M.S."];
        [self.pickerCredentialArray addObject:@"Ph.D."];
        
        UIPickerView *myPickerView = [[UIPickerView alloc] init];
        myPickerView.showsSelectionIndicator = YES;
        myPickerView.delegate = self;
        myPickerView.tag = 100;
        self.credentialField.inputView = myPickerView;
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
        self.credentialField.inputAccessoryView = keyboardDoneButtonView;  

        self.pickerClassificationArray = [[NSMutableArray alloc] init];
        [self.pickerClassificationArray addObject:@""];
        [self.pickerClassificationArray addObject:@"OB"];
        [self.pickerClassificationArray addObject:@"Pediatrician"];
        [self.pickerClassificationArray addObject:@"Hem/ONC"];
        [self.pickerClassificationArray addObject:@"GP"];
        [self.pickerClassificationArray addObject:@"Neurologist"];
        [self.pickerClassificationArray addObject:@"Other"];
        
        UIPickerView *classificationPickerView = [[UIPickerView alloc] init];
        classificationPickerView.showsSelectionIndicator = YES;
        classificationPickerView.delegate = self;
        classificationPickerView.tag = 200;
        self.classificationField.inputView = classificationPickerView;
        self.classificationField.inputAccessoryView = keyboardDoneButtonView;

    
    self.pickerClassificationArray = [[NSMutableArray alloc] init];
    [self.pickerClassificationArray addObject:@""];
    [self.pickerClassificationArray addObject:@"OB"];
    [self.pickerClassificationArray addObject:@"Pediatrician"];
    [self.pickerClassificationArray addObject:@"Hem/ONC"];
    [self.pickerClassificationArray addObject:@"GP"];
    [self.pickerClassificationArray addObject:@"Neurologist"];
    [self.pickerClassificationArray addObject:@"Other"];
    
    
    
    self.pickerYearArray = [[NSMutableArray alloc] init];
    int i = 1915;
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    
    while (i <= [components year] -1)
    {
        [self.pickerYearArray addObject:[NSString stringWithFormat:@"%d",i]];
        i = i + 1;
        
    }
    UIPickerView *yearPickerView = [[UIPickerView alloc] init];
    yearPickerView.showsSelectionIndicator = YES;
    yearPickerView.delegate = self;
    yearPickerView.tag = 300;
    self.drBirthYear.inputView = yearPickerView;
    self.drBirthYear.inputAccessoryView = keyboardDoneButtonView;
    
    
    self.pickerContinuumArray = [[NSMutableArray alloc] init];
    [self.pickerContinuumArray addObject:@""];
    [self.pickerContinuumArray addObject:@"Skeptic"];
    [self.pickerContinuumArray addObject:@"Facilitator"];
    [self.pickerContinuumArray addObject:@"CB Advocate"];
    [self.pickerContinuumArray addObject:@"CBR Advocate"];

    UIPickerView *continuumPickerView = [[UIPickerView alloc] init];
    continuumPickerView.showsSelectionIndicator = YES;
    continuumPickerView.delegate = self;
    continuumPickerView.tag = 400;
    self.continuum.inputView = continuumPickerView;
    self.continuum.inputAccessoryView = keyboardDoneButtonView;



}
- (void)pickerDoneClicked
{
    [self.credentialField resignFirstResponder];
    [self.classificationField resignFirstResponder];
    [self.drBirthYear resignFirstResponder];
    [self.continuum resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setCredentialField:nil];
    [self setClassificationField:nil];
    [self setOfficePhoneField:nil];
    [self setOfficeFaxField:nil];
    [self setCellField:nil];
    [self setEmailField:nil];
    [self setLblOffice:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"chooseOffice"]) { 
        UINavigationController *navigationController = segue.destinationViewController;
        cbrOfficesChooseViewController *chooseController = (cbrOfficesChooseViewController *)navigationController.parentViewController;
        chooseController.managedObjectContext = self.managedObjectContext;
        
        navigationController.delegate = self;
    }
}

- (void)recordSelected:(cbrOfficesChooseViewController *)controller
{
    // do something here like refreshing the table or whatever
    self.officeItem = [controller nOfficeItem];
    self.lblOffice.text = [[self.officeItem  valueForKey:@"name"] description];
    self.saveButton.enabled = YES;
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { 
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { 
    if (thePickerView.tag == 100)
        return [self.pickerCredentialArray count];
    else if (thePickerView.tag == 200)
        return [self.pickerClassificationArray count];
    else if (thePickerView.tag == 300)
        return [self.pickerYearArray count];
    else if (thePickerView.tag == 400)
        return [self.pickerContinuumArray count];
    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 
    if (thePickerView.tag == 100)
           return [self.pickerCredentialArray objectAtIndex:row];
    else if (thePickerView.tag == 200)
        return [self.pickerClassificationArray objectAtIndex:row];
    else if (thePickerView.tag == 300)
        return [self.pickerYearArray objectAtIndex:row];
    else if (thePickerView.tag == 400)
        return [self.pickerContinuumArray objectAtIndex:row];
    else {
        
        return 0;
    }
    
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
    
    if (thePickerView.tag == 100)
        [self.credentialField setText:[self.pickerCredentialArray objectAtIndex:row]];
    else if (thePickerView.tag == 200)
        [self.classificationField setText:[self.pickerClassificationArray objectAtIndex:row]];
    else if (thePickerView.tag == 300)
        [self.drBirthYear setText:[self.pickerYearArray objectAtIndex:row]];
    else if (thePickerView.tag == 400)
        [self.continuum setText:[self.pickerContinuumArray objectAtIndex:row]];
    
}


- (IBAction)addRecord:(id)sender {
    
    NSString *errorMsg = @"";
    if([self.firstNameField.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"First Name is required"];
    }
    if([self.lastNameField.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Last Name is required"];
    }
    if([self.classificationField.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Classification is required"];
    }
    if([self.drBirthYear.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Dr Birth Year is required"];
    }
    if ([self.emailField.text length] > 0)
    {
        self.emailField.text = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSError *error = NULL;
        NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSTextCheckingResult *match = [regex firstMatchInString:self.emailField.text options:0 range:NSMakeRange(0, [self.emailField.text length])];
        
        if (!match){
            errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Valid Email is required"];
        }
        
    }
    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    
        NSManagedObjectContext *context = self.managedObjectContext;
        NSManagedObject *newProvider = [NSEntityDescription insertNewObjectForEntityForName:@"Providers" inManagedObjectContext:context];
    
        [newProvider setValue:self.firstNameField.text forKey:@"firstName"];
        [newProvider setValue:self.lastNameField.text forKey:@"lastName"];
        [newProvider setValue:self.emailField.text forKey:@"emailPrimary"];
        [newProvider setValue:self.classificationField.text forKey:@"category"];
        [newProvider setValue:self.credentialField.text forKey:@"credential"];
        [newProvider setValue:[NSNumber numberWithInt:[self.drBirthYear.text intValue]] forKey:@"birthYear"];
        [newProvider setValue:self.continuum.text forKey:@"salesContinuum"];
        [newProvider setValue:@"D1" forKey:@"momentumRating"];
        if(self.residentField.isOn)
        {
            [newProvider setValue:@"Resident" forKey:@"providerType"];
        }
        [newProvider setValue:self.officeHours.text forKey:@"pfOfficeHours"];

    
        if (self.officeItem != nil) {
            NSString *relationshipName;
            NSString *entityName = [[self.officeItem entity] name];

            [newProvider setValue:[self.officeItem valueForKey:@"rowId"] forKey:@"facilityId"];
            [newProvider setValue:[self.officeItem valueForKey:@"integrationId"] forKey:@"facilityIntegrationId"];
        
            if ([entityName isEqualToString:@"Offices"]) {	
                relationshipName = @"officeProviders";
            }
        
            NSMutableSet *providerRelation = [[self officeItem] mutableSetValueForKey:relationshipName];
            [providerRelation addObject:newProvider];
        }
    
    
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
        [self recordTransaction:newProvider];
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
    [newTransaction setValue:@"Provider" forKey:@"entityType"];
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
