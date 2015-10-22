//
//  cbrCheckInViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrCheckInViewController.h"

@interface cbrCheckInViewController()
- (void)recordTransaction:(NSManagedObject *) obj;
- (void)setNewDate;
- (void)dismissDateSet;
- (void)cancelDateSet;
@end

@implementation cbrCheckInViewController
@synthesize pickerArray = _pickerArray;
@synthesize pickerClaim = _pickerClaim;
@synthesize pickerType = _pickerType;
@synthesize pickerParentClaim = _pickerParentClaim;
@synthesize checkInNextType = _checkInNextType;
@synthesize dueDt = _dueDt;
@synthesize intClaim = _intClaim;
@synthesize intSubClaim = _intSubClaim;
@synthesize checkInNextDate = _checkInNextDate;
@synthesize locationManager = _locationManager;
@synthesize pickerView = _pickerView;
@synthesize theDatePicker = _theDatePicker;
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
    
    self.checkInNextDate.text = @"";
    self.checkInNextType.text = @"";
    self.intClaim = 0;
    self.intSubClaim = 0;
    self.pickerArray = [[NSMutableArray alloc] init];
    [self.pickerArray addObject:@""];
    [self.pickerArray addObject:@"To Do"];
    
    
    UIPickerView *myPickerView = [[UIPickerView alloc] init];
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.delegate = self;
    myPickerView.tag = 100;
    self.checkInNextType.inputView = myPickerView;
    
    
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
    self.checkInNextType.inputAccessoryView = keyboardDoneButtonView;  


    
    self.pickerType = [[NSMutableArray alloc] init];
    [self.pickerType addObject:@""];
    [self.pickerType addObject:@"Dr Call"];
    [self.pickerType addObject:@"Staff Call"];
    [self.pickerType addObject:@"Office Visit/Drop-Off"];
    [self.pickerType addObject:@"Hosp Call"];
    
    UIPickerView *typePickerView = [[UIPickerView alloc] init];
    typePickerView.showsSelectionIndicator = YES;
    typePickerView.delegate = self;
    typePickerView.tag = 200;
    self.callType.inputView = typePickerView;
    self.callType.inputAccessoryView = keyboardDoneButtonView;
    if ([[[self.detailItem entity] name] isEqualToString:@"Offices"])
    {
        self.callType.text = @"Hosp Call";
        [typePickerView selectRow:3 inComponent:0 animated:0];
    }
    
    
    NSManagedObjectContext *moc = [self.detailItem managedObjectContext];
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *claimsEntity = [NSEntityDescription entityForName:@"Claims" inManagedObjectContext:moc];
    [fr setEntity:claimsEntity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fr setSortDescriptors:sortDescriptors];
    self.arrayClaims = [[moc executeFetchRequest:fr error:nil] mutableCopy];
    
    self.pickerClaim = [[NSMutableArray alloc] init];
    self.pickerParentClaim = [[NSMutableArray alloc] init];
    [self.pickerParentClaim addObject:@""];
    for (id parent in self.arrayClaims)
    {
        if ([[self.pickerParentClaim filteredArrayUsingPredicate:[NSPredicate
                                            predicateWithFormat:@"self == %@", [parent valueForKey:@"parentLIC"]]] count] == 0)
                [self.pickerParentClaim addObject:[parent valueForKey:@"parentLIC"]];
    }

    
    UIPickerView *claimsPickerView = [[UIPickerView alloc] init];
    claimsPickerView.showsSelectionIndicator = YES;
    claimsPickerView.delegate = self;
    claimsPickerView.tag = 300;
    self.claimUsed.inputView = claimsPickerView;
    self.claimUsed.inputAccessoryView = keyboardDoneButtonView;
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    theDatePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [theDatePicker setDatePickerMode:UIDatePickerModeDate];
    theDatePicker.minimumDate=[NSDate date];

}

- (void)viewDidUnload
{
    [self setDueDt:nil];
    [self setCheckInNextDate:nil];
    [self setCheckInNextType:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    if (thePickerView.tag == 300)
        return 2;
    else
        return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (thePickerView.tag == 100)
        return [self.pickerArray count];
    else if (thePickerView.tag == 200)
        return [self.pickerType count];
    else if (thePickerView.tag == 300)
    {
        if (component == 0)
            return [self.pickerParentClaim count];
    
        else
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.parentLIC = %@", self.claimUsed.text];
            NSArray * filteredArray = [self.arrayClaims filteredArrayUsingPredicate:predicate];
            self.pickerClaim = [[NSMutableArray alloc] init];
            [self.pickerClaim addObject:@""];
            
            for (id claims in filteredArray)
            {
                [self.pickerClaim addObject:[claims valueForKey:@"value"]];
            }
            return [self.pickerClaim count];
        }
    }
    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (thePickerView.tag == 100)
        return [self.pickerArray objectAtIndex:row];
    else if (thePickerView.tag == 200)
        return [self.pickerType objectAtIndex:row];
    else if (thePickerView.tag == 300)
        if (component == 0)
            return [self.pickerParentClaim objectAtIndex:row];
        else
        {
            /*NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.parentLIC = %@", self.claimUsed.text];
            NSArray * filteredArray = [self.arrayClaims filteredArrayUsingPredicate:predicate];
            self.pickerClaim = [[NSMutableArray alloc] init];
            [self.pickerClaim addObject:@""];
            
            for (id claims in filteredArray)
            {
                [self.pickerClaim addObject:[claims valueForKey:@"value"]];
            }*/
            return [self.pickerClaim objectAtIndex:row];
        }
    else
        return 0;
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (thePickerView.tag == 100)
        [self.checkInNextType setText:[self.pickerArray objectAtIndex:row]];
    else if (thePickerView.tag == 200)
        [self.callType setText:[self.pickerType objectAtIndex:row]];
    else if (thePickerView.tag == 300)
    {
        if (component == 0)
        {
            [self.claimUsed setText:[self.pickerParentClaim objectAtIndex:row]];
            [thePickerView reloadComponent:1];
            [thePickerView selectRow:0 inComponent:1 animated:0];
            self.intClaim = row;
            self.intSubClaim = 0;
        }
        else
        {
            self.intSubClaim = row;
            [self.claimUsed setText:[[NSString alloc] initWithFormat:@"%@ - %@", [self.pickerParentClaim objectAtIndex:self.intClaim],[self.pickerClaim objectAtIndex:row]]];
            //[self.claimUsed setText:[self.pickerClaim objectAtIndex:row]];
        }
    }
}
- (void)pickerDoneClicked
{
    [self.checkInNextType resignFirstResponder];
    [self.callType resignFirstResponder];
    [self.claimUsed resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.checkInNextType || theTextField == self.checkInNextDate || theTextField == self.callType || theTextField == self.claimUsed){
        [theTextField resignFirstResponder];
    }
    return NO;
}

#pragma mark - Table view delegate
- (IBAction)saveCheckIn:(id)sender {
    NSString *errorMsg = @"";
    //NSString *callNoteComments = [[NSString alloc] initWithFormat:@"N: %@\n\nC: %@", self.noteN.text, self.noteC.text];
    
    if([self.callType.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Call Type is required."];
    }
    if(self.intClaim == 0 && ![self.callType.text isEqualToString:@"Office Visit/Drop-Off"])
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Call Objective is required."];
    }
    if(self.intSubClaim == 0 && ![self.callType.text isEqualToString:@"Office Visit/Drop-Off"])
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Call Objective is required."];
    }
    //if([callNoteComments length] > 1500)
    //{
    //    errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"You have exceeded the 1500 char limit.  Please update and try again."];
    //}
    
    if ((![self.checkInNextDate.text isEqualToString:@""]) && [self.checkInNextType.text isEqualToString:@""])
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Type is required."];
    }
    
    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        NSManagedObjectContext *context = [self.detailItem managedObjectContext];
        NSManagedObject *newAction = [NSEntityDescription insertNewObjectForEntityForName:@"Actions" inManagedObjectContext:context];
                
        NSDate *now = [NSDate date];
        
        //[newAction setValue:@"Call Note" forKey:@"note"];
        //[newAction setValue:callNoteComments forKey:@"longNotes"];
        [newAction setValue:now forKey:@"actionDate"];
        [newAction setValue:@"Done" forKey:@"status"];
        [newAction setValue:@"Other" forKey:@"type"];
        [newAction setValue:self.callType.text forKey:@"subType"];
        [newAction setValue:self.claimUsed.text forKey:@"note"];
        [newAction setValue:@"Note from RM" forKey:@"descriptionType"];
        
        NSString *relationshipName;
        if (self.detailItem != nil) {
            NSString *entityName = [[self.detailItem entity] name];
            
            if ([entityName isEqualToString:@"Offices"]) {
                relationshipName = @"actionOffice";
                [newAction setValue:[self.detailItem valueForKey:@"rowId"] forKey:@"officeId"];
            }
            if ([entityName isEqualToString:@"Providers"]) {
                relationshipName = @"actionProvider";
                [newAction setValue:[self.detailItem valueForKey:@"rowId"] forKey:@"contactId"];
                [newAction setValue:[self.detailItem valueForKey:@"facilityId"] forKey:@"officeId"];
            }
            
            [newAction setValue:self.detailItem forKey:relationshipName];
        }
        
        [self recordTransaction:newAction];
        
        if (![self.checkInNextDate.text isEqualToString:@""] || ![self.checkInNextType.text isEqualToString:@""])
        {
            NSManagedObject *newSchedule = [NSEntityDescription insertNewObjectForEntityForName:@"Actions" inManagedObjectContext:context];
            //[newSchedule setValue:self.checkInNextNote.text forKey:@"note"];
            [newSchedule setValue:@"Open" forKey:@"status"];
            NSDateFormatter *myDateReader = [[NSDateFormatter alloc] init];
            [myDateReader setDateFormat:@"MM/dd/yyyy"]; // for example
            NSDate *itsDate = [myDateReader dateFromString:self.checkInNextDate.text];
            [newSchedule setValue:itsDate forKey:@"dueDate"];
            [newSchedule setValue:self.checkInNextType.text forKey:@"type"];
            [newSchedule setValue:@"Follow-Up" forKey:@"subType"];
            //[newSchedule setValue:self.checkInNextType.text forKey:@"descriptionType"];
            [newSchedule setValue:@"Follow-up" forKey:@"descriptionType"];
            [newSchedule setValue:[newAction valueForKey:@"contactId"] forKey:@"contactId"];
            [newSchedule setValue:[newAction valueForKey:@"officeId"] forKey:@"officeId"];
            
            if (self.detailItem != nil)
                [newSchedule setValue:self.detailItem forKey:relationshipName];
            
            if ([newAction valueForKey:@"contactId"] != nil)
            {
                //[self setNextFollowUpProvider:self.detailItem];
                NSEntityDescription *providerEntity = [NSEntityDescription entityForName:@"Providers" inManagedObjectContext:context];
                NSFetchRequest *fr = [[NSFetchRequest alloc] init];
                [fr setEntity:providerEntity];
                
                NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [newAction valueForKey:@"contactId"]];
                [fr setPredicate:actionPredicate];
                
                NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
                [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
                
                // actions
                NSArray *providerArray = [context executeFetchRequest:fr error:nil];
                
                for (NSManagedObject *provider in providerArray)
                {
                    //[self.detailItem setValue:provider forKey:@"actionProvider"];
                    [self setNextFollowUpProvider:provider];
                }
            }
            if ([newAction valueForKey:@"officeId"] != nil)
            {
                //[self setNextFollowUpOffice:self.detailItem];
                NSEntityDescription *officeEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:context];
                NSFetchRequest *fr = [[NSFetchRequest alloc] init];
                [fr setEntity:officeEntity];
                
                // Set example predicate and sort orderings..
                NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [newAction valueForKey:@"officeId"]];
                [fr setPredicate:actionPredicate];
                
                NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
                [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
                
                NSArray *officeArray = [context executeFetchRequest:fr error:nil];
                
                for (NSManagedObject *office in officeArray)
                {
                    //[self.detailItem setValue:office forKey:@"actionOffice"];
                    [self setNextFollowUpOffice:office];
                }
            }
            
            
            
            
            [self recordTransaction:newSchedule];
        }
        [context save:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setNextFollowUpOffice:(NSManagedObject *) office
{
    NSManagedObjectContext *moc = [office managedObjectContext];
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSEntityDescription *assetEntity = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
    NSSortDescriptor *assetSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"expirationDate" ascending:YES];
    
    NSEntityDescription *actionEntity = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];
    NSSortDescriptor *actionSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    
    NSDate *today = [NSDate date];
    
    // asset first
    [fr setEntity:assetEntity];
    
    NSPredicate *assetPredicate = [NSPredicate predicateWithFormat: @"(assignedOfficeId = %@) && (expirationDate <= %@) && (status != %@)", [office valueForKey:@"rowId"],today, @"Inactive/Lost"];
    
    [fr setPredicate:assetPredicate];
    [fr setSortDescriptors:[NSArray arrayWithObject:assetSortDescriptor]];
    
    NSArray *assetArray = [moc executeFetchRequest:fr error:nil];
    
    if ([assetArray count] > 0) {
        [office setValue:today forKey:@"nextFUDate"];
    }
    else {
        // actions next
        [fr setEntity:actionEntity];
        
        // Set example predicate and sort orderings..
        NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(descriptionType != 'Note from RM' || descriptionType = nil) &&(dueDate != NULL) && (officeId = %@) && (status = 'Open')", [office valueForKey:@"rowId"]];
        
        [fr setPredicate:actionPredicate];
        [fr setSortDescriptors:[NSArray arrayWithObject:actionSortDescriptor]];
        
        NSArray *actionArray = [moc executeFetchRequest:fr error:nil];
        
        if ([actionArray count] > 0) {
            [office setValue:[[actionArray objectAtIndex:0] valueForKey:@"dueDate"] forKey:@"nextFUDate"];
        }
    }
}
- (void)setNextFollowUpProvider:(NSManagedObject *) provider
{
    NSManagedObjectContext *moc = [provider managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSEntityDescription *assetEntity = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
    NSSortDescriptor *assetSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"expirationDate" ascending:YES];
    
    NSEntityDescription *actionEntity = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];
    NSSortDescriptor *actionSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    
    NSDate *today = [NSDate date];
    
    // asset first
    [fr setEntity:assetEntity];
    
    NSPredicate *assetPredicate = [NSPredicate predicateWithFormat: @"(assignedContactId = %@) && (expirationDate <= %@)  && (status != %@)", [provider valueForKey:@"rowId"],today, @"Inactive/Lost"];
    
    [fr setPredicate:assetPredicate];
    [fr setSortDescriptors:[NSArray arrayWithObject:assetSortDescriptor]];
    
    NSArray *assetArray = [moc executeFetchRequest:fr error:nil];
    
    if ([assetArray count] > 0) {
        [provider setValue:today forKey:@"nextFUDate"];
    }
    else {
        // actions next
        [fr setEntity:actionEntity];
        
        // Set example predicate and sort orderings..
        NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(descriptionType != 'Note from RM' || descriptionType = nil) &&(dueDate != NULL) && (contactId = %@) && (status = 'Open')", [provider valueForKey:@"rowId"]];
        
        [fr setPredicate:actionPredicate];
        [fr setSortDescriptors:[NSArray arrayWithObject:actionSortDescriptor]];
        
        NSArray *actionArray = [moc executeFetchRequest:fr error:nil];
        
        if ([actionArray count] > 0) {
            [provider setValue:[[actionArray objectAtIndex:0] valueForKey:@"dueDate"] forKey:@"nextFUDate"];
        }
    }    
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
    
    [newTransaction setValue:@"Action" forKey:@"entityType"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.latitude] forKey:@"latitude"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.longitude] forKey:@"longitude"];
    [newTransaction setValue:today forKey:@"transactionDate"];
    [newTransaction setValue:@"Create" forKey:@"transactionType"];
    
    [clm stopUpdatingLocation];
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    //[context save:nil];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField { 
    UITextField *thefield = textField;
    
    if ([thefield isEqual:self.checkInNextDate])
    {
        //[self setDue];
        [self.checkInNextType resignFirstResponder];
        [self.callType resignFirstResponder];
        [self.claimUsed resignFirstResponder];

        [self setNewDate];
        return NO;
    }
    else {
        [self cancelDateSet];
        return YES;
    }
}


- (void) setNewDate {


    UIToolbar *controlToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width, 44)];
    
    [controlToolbar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDateSet)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDateSet)];
    
    [controlToolbar setItems:[NSArray arrayWithObjects:spacer, cancelButton, setButton, nil] animated:NO];
    
    
    [theDatePicker setFrame:CGRectMake(0, controlToolbar.frame.size.height - 15, theDatePicker.frame.size.width, theDatePicker.frame.size.height)];
    
    if (!pickerView) {
        pickerView = [[UIView alloc] initWithFrame:theDatePicker.frame];
    } else {
        [pickerView setHidden:NO];
    }
    
    
    //CGFloat pickerViewYpositionHidden = self.view.frame.size.height + pickerView.frame.size.height;
    CGFloat pickerViewYpositionHidden = pickerView.frame.size.height;
    
    //CGFloat pickerViewYposition = self.view.frame.size.height - pickerView.frame.size.height;
   
    [pickerView setFrame:CGRectMake(pickerView.frame.origin.x,
                                    pickerViewYpositionHidden,
                                    pickerView.frame.size.width,
                                    pickerView.frame.size.height)];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    [pickerView addSubview:controlToolbar];
    [pickerView addSubview:theDatePicker];
    [theDatePicker setHidden:NO];
    
    
    [self.view addSubview:pickerView];
    /*
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [pickerView setFrame:CGRectMake(pickerView.frame.origin.x,
                                                         pickerViewYposition,
                                                         pickerView.frame.size.width,
                                                         pickerView.frame.size.height)];
                     }
                     completion:nil];
   */
}


- (void)cancelDateSet {
    //[dateSheet dismissWithClickedButtonIndex:0 animated:YES];
    CGFloat pickerViewYpositionHidden = self.view.frame.size.height + pickerView.frame.size.height;
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [pickerView setFrame:CGRectMake(pickerView.frame.origin.x,
                                                         pickerViewYpositionHidden,
                                                         pickerView.frame.size.width,
                                                         pickerView.frame.size.height)];
                     }
                     completion:nil];
}

- (void)dismissDateSet {
    /*
    NSArray *listOfViews = [self.view subviews];
    
    for (UIView *subview in listOfViews)
    {
        if ([subview isKindOfClass:[UIView class]])
        {
            self.dueDt = [(UIDatePicker *)subview date];
        }
    }
    */
    self.dueDt = [theDatePicker date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    [self.checkInNextDate setText:[df stringFromDate:self.dueDt]];
    //[dateSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self cancelDateSet];
}


@end
