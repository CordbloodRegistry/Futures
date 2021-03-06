//
//  cbrProviderSummaryViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrProviderSummaryViewController.h"
#define maxLength 255

@interface cbrProviderSummaryViewController()
- (void)recordTransaction:(NSManagedObject *) obj;
@end

@implementation cbrProviderSummaryViewController

@synthesize detailItem = _detailItem;
@synthesize monthlyBirthLabel = _monthlyBirthLabel;
@synthesize monthlyBirthText = _monthlyBirthText;
//@synthesize stepper = _stepper;
@synthesize status = _status;
@synthesize reasonText = _reasonText;
@synthesize emailText = _emailText;
@synthesize noFaxSwitch = _noFaxSwitch;
@synthesize noEmailSwitch = _noEmailSwitch;
@synthesize pickerReasonArray = _pickerReasonArray;
@synthesize usernameText = _usernameText;
@synthesize sendInviteSwitch = _sendInviteSwitch;
@synthesize resetPasswordSwitch = _resetPasswordSwitch;
@synthesize drBirthYear = _drBirthYear;
@synthesize pickerYearArray = _pickerYearArray;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}


- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        if ([[[self.detailItem  valueForKey:@"status"] description] isEqualToString:@"Active"])
            self.status.on = true;
        else 
            self.status.on = false;
        self.reasonText.text = [[self.detailItem  valueForKey:@"inactiveReason"] description];
        self.emailText.text = [[self.detailItem  valueForKey:@"emailPrimary"] description];
        
        if ([[[self.detailItem  valueForKey:@"noEmail"] description] isEqualToString:@"Y"])
            self.noEmailSwitch.on = true;
        else 
            self.noEmailSwitch.on = false;
        if ([[[self.detailItem  valueForKey:@"noFax"] description] isEqualToString:@"Y"])
            self.noFaxSwitch.on = true;
        else 
            self.noFaxSwitch.on = false;
        //self.stepper.value = [[[self.detailItem  valueForKey:@"monthlyBirth"] description] doubleValue];
        self.monthlyBirthText.text = [[self.detailItem  valueForKey:@"monthlyBirth"] description];
        self.continuum.text = [[self.detailItem  valueForKey:@"salesContinuum"] description];
        
        if ([[[self.detailItem valueForKey:@"birthYear"] description] length] > 0 && [[[self.detailItem valueForKey:@"birthYear"] description] intValue] > 0)
            self.drBirthYear.text = [[self.detailItem  valueForKey:@"birthYear"] description];
        else
            self.drBirthYear.text = @"";

        self.usernameText.text = [[self.detailItem  valueForKey:@"pwaLogin"] description];
        if ([[[self.detailItem  valueForKey:@"sendPWAInvitation"] description] isEqualToString:@"Y"])
            self.sendInviteSwitch.on = true;
        else 
            self.sendInviteSwitch.on = false;
        if ([[[self.detailItem  valueForKey:@"pwaResetPwdFlag"] description] isEqualToString:@"Y"])
            self.resetPasswordSwitch.on = true;
        else 
            self.resetPasswordSwitch.on = false;
        if (![[[self.detailItem  valueForKey:@"pwaActiveFlag"] description] isEqualToString:@"Y"]   && ![[[self.detailItem  valueForKey:@"pwaInvitationSent"] description] isEqualToString:@"Y"])
        {
            //enable username
            [self.usernameText setEnabled:YES];
            //enable send invitation
            [self.sendInviteSwitch setEnabled:YES];

        }
        else if ([[[self.detailItem  valueForKey:@"pwaActiveFlag"] description] isEqualToString:@"Y"])
        {
            //enable reset password
            [self.resetPasswordSwitch setEnabled:YES];
        }

        self.reasonText.text = [[self.detailItem  valueForKey:@"inactiveReason"] description];
        self.pickerReasonArray = [[NSMutableArray alloc] init];
        [self.pickerReasonArray addObject:@""];
        [self.pickerReasonArray addObject:@"Leave of absence"];
        [self.pickerReasonArray addObject:@"Gyn only"];
        [self.pickerReasonArray addObject:@"Retired"];
        [self.pickerReasonArray addObject:@"Deceased"];
        [self.pickerReasonArray addObject:@"Not a doctor"];
        [self.pickerReasonArray addObject:@"Duplicate"];
        [self.pickerReasonArray addObject:@"Cannot Locate Provider"];
        [self.pickerReasonArray addObject:@"Not OB"];
        
        UIPickerView *myPickerView = [[UIPickerView alloc] init];
        myPickerView.showsSelectionIndicator = YES;
        myPickerView.delegate = self;
        myPickerView.tag = 100;
        self.reasonText.inputView = myPickerView;
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
        self.reasonText.inputAccessoryView = keyboardDoneButtonView;

        self.pickerYearArray = [[NSMutableArray alloc] init];
        int i = 1915;
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
        NSInteger pickerRow = [[[self.detailItem  valueForKey:@"birthYear"] description] doubleValue] - 1915;
        if ( pickerRow < 0)
            pickerRow = 0;
        
        while (i <= [components year] - 1)
        {
            [self.pickerYearArray addObject:[NSString stringWithFormat:@"%d",i]];
            i = i + 1;
            
        }
        UIPickerView *yearPickerView = [[UIPickerView alloc] init];
        yearPickerView.showsSelectionIndicator = YES;
        yearPickerView.delegate = self;
        yearPickerView.tag = 200;
        self.drBirthYear.inputView = yearPickerView;
        
        // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
        // Prepare done button
        /*
        UIToolbar* yearDoneButtonView = [[UIToolbar alloc] init];
        //yearDoneButtonView.barStyle = UIBarStyleBlack;
        //yearDoneButtonView.translucent = YES;
        //yearDoneButtonView.tintColor = nil;
        [yearDoneButtonView sizeToFit];
        UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* doneButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(pickerDoneClicked)];
        
        [yearDoneButtonView setItems:[NSArray arrayWithObjects:spacer2,doneButton2, nil]];
         */
        self.drBirthYear.inputAccessoryView = keyboardDoneButtonView;
        [yearPickerView selectRow:pickerRow inComponent:0 animated:YES];
        
        
        self.pickerContinuumArray = [[NSMutableArray alloc] init];
        [self.pickerContinuumArray addObject:@""];
        [self.pickerContinuumArray addObject:@"Skeptic"];
        [self.pickerContinuumArray addObject:@"Facilitator"];
        [self.pickerContinuumArray addObject:@"CB Advocate"];
        [self.pickerContinuumArray addObject:@"CBR Advocate"];
        
        UIPickerView *continuumPickerView = [[UIPickerView alloc] init];
        continuumPickerView.showsSelectionIndicator = YES;
        continuumPickerView.delegate = self;
        continuumPickerView.tag = 300;
        self.continuum.inputView = continuumPickerView;
        self.continuum.inputAccessoryView = keyboardDoneButtonView;
        

        

    }
}
/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UITextField *thefield = textField;
    
    if ([thefield isEqual:self.drBirthYear])
    {
        [self showYearPicker];
        return NO;
    }
    else {
        return YES;
    }
}

-(void) showYearPicker
{
    dateSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [dateSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    //UIDatePicker *birthYrPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    UIPickerView *birthYrPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    //birthYrPicker.minimumDate=[NSDate date];
    
    [dateSheet addSubview:birthYrPicker];
    
    UIToolbar *controlToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,dateSheet.bounds.size.width, 44)];
    
    //[controlToolBar setBarStyle:UIBarStyleBlack];
    //[controlToolBar setTranslucent:YES];
    //[controlToolBar setTintColor:nil];
    [controlToolBar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissDateSet)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelDateSet)];
    
    [controlToolBar setItems:[NSArray arrayWithObjects:spacer,cancelButton,setButton,nil]];
    
    [dateSheet addSubview:controlToolBar];
    
    [dateSheet showFromTabBar:self.tabBarController.tabBar];
    
    [dateSheet setBounds:CGRectMake(0, 0, 320, 485)];

}
- (void)cancelDateSet {
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dismissDateSet {
    NSArray *listOfViews = [dateSheet subviews];
    NSDate *dueDt;
    for (UIView *subview in listOfViews)
    {
        if ([subview isKindOfClass:[UIDatePicker class]])
        {
            dueDt = [(UIDatePicker *)subview date];
        }
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    [self.drBirthYear setText:[df stringFromDate:dueDt]];
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
}
*/

- (void)pickerDoneClicked
{
    [self.reasonText resignFirstResponder];
    [self.drBirthYear resignFirstResponder];
    [self.continuum resignFirstResponder];
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
    
    [self configureView];
    
}

- (void)viewDidUnload
{
    //[self setDisplayCount:nil];
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



#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { 
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { 
    if (thePickerView.tag == 100)
        return [self.pickerReasonArray count];
    else if (thePickerView.tag == 200)
        return [self.pickerYearArray count];
    else if (thePickerView.tag == 300)
        return [self.pickerContinuumArray count];
    else
        return 0;
}



- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (thePickerView.tag == 100)
        return [self.pickerReasonArray objectAtIndex:row];
    else if (thePickerView.tag == 200)
        return [self.pickerYearArray objectAtIndex:row];
    else if (thePickerView.tag == 300)
        return [self.pickerContinuumArray objectAtIndex:row];
    else
        return 0;
    
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (thePickerView.tag == 100)
        [self.reasonText setText:[self.pickerReasonArray objectAtIndex:row]];
    else if (thePickerView.tag == 200)
        [self.drBirthYear setText:[self.pickerYearArray objectAtIndex:row]];
    else if (thePickerView.tag == 300)
        [self.continuum setText:[self.pickerContinuumArray objectAtIndex:row]];
    
}


#pragma mark - Custom
/*
- (IBAction)valueChanged:(UIStepper *)sender
{
    double value = [sender value];
    
    [self.monthlyBirthLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
    //[self.monthlyBirthText setText:[NSString stringWithFormat:@"%d", (int)value]];
}
*/

- (IBAction)saveChanges:(id)sender
{
    
    NSString *errorMsg = @"";
    if(!self.status.isOn && [self.reasonText.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Inactive Reason is required"];
    }
    if([self.drBirthYear.text length] <= 0 && self.status.isOn)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Dr Birth Year is required"];
    }
    if([self.monthlyBirthText.text integerValue] <= 0 && self.status.isOn)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Monthly # of Births is required"];
    }
    if([self.continuum.text length] <= 0 && self.status.isOn)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Continuum is required"];
    }
    if ([self.emailText.text length] > 0)
    {
        self.emailText.text = [self.emailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSError *error = NULL;
        NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSTextCheckingResult *match = [regex firstMatchInString:self.emailText.text options:0 range:NSMakeRange(0, [self.emailText.text length])];
        
        if (!match){
            errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Valid Email is required"];
        }        
    }
    if ([self.usernameText.text length] > 0)
    {
        self.usernameText.text = [self.usernameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSError *error = NULL;
        NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSTextCheckingResult *match = [regex firstMatchInString:self.usernameText.text options:0 range:NSMakeRange(0, [self.usernameText.text length])];
        
        if (!match){
            errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Valid Username is required"];
        }
    }

    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        if(self.status.isOn)
            [self.detailItem setValue:@"Active" forKey:@"status"];
        else
            [self.detailItem setValue:@"Inactive" forKey:@"status"];
        if(self.noEmailSwitch.isOn)
            [self.detailItem setValue:@"Y" forKey:@"noEmail"];
        else
            [self.detailItem setValue:@"N" forKey:@"noEmail"];
        if(self.noFaxSwitch.isOn)
            [self.detailItem setValue:@"Y" forKey:@"noFax"];
        else
            [self.detailItem setValue:@"N" forKey:@"noFax"];
        if(self.sendInviteSwitch.isOn)
            [self.detailItem setValue:@"Y" forKey:@"sendPWAInvitation"];
        else
            [self.detailItem setValue:@"N" forKey:@"sendPWAInvitation"];
        if(self.resetPasswordSwitch.isOn)
            [self.detailItem setValue:@"Y" forKey:@"pwaResetPwdFlag"];
        else
            [self.detailItem setValue:@"N" forKey:@"pwaResetPwdFlag"];
    
        [self.detailItem setValue:[NSNumber numberWithInt:[self.monthlyBirthText.text intValue]] forKey:@"monthlyBirth"];
        [self.detailItem setValue:self.reasonText.text forKey:@"inactiveReason"];
        [self.detailItem setValue:self.emailText.text forKey:@"emailPrimary"];
        [self.detailItem setValue:self.usernameText.text forKey:@"pwaLogin"];
        if ([self.drBirthYear.text length] > 0)
            [self.detailItem setValue:[NSNumber numberWithInt:[self.drBirthYear.text intValue]] forKey:@"birthYear"];
        [self.detailItem setValue:self.continuum.text forKey:@"salesContinuum"];
        
        
        [self recordTransaction:self.detailItem];

        // Save the context.
        NSError *error = nil;
        if (![[[self detailItem] managedObjectContext] save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }   
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)recordTransaction:(NSManagedObject *) obj
{
    NSManagedObjectContext *context = [self.detailItem managedObjectContext];
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
    [newTransaction setValue:@"Update" forKey:@"transactionType"];
    
    [clm stopUpdatingLocation];
    
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    
    //[context save:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section 
{ 
    return 20;
}




@end
