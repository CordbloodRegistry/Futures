//
//  cbrHospitalEditViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrHospitalEditViewController.h"

#define maxLength 255

@interface cbrHospitalEditViewController()
- (void)recordTransaction:(NSManagedObject *) obj;
@end

@implementation cbrHospitalEditViewController

@synthesize detailItem = _detailItem;
@synthesize preDetailItem = _preDetailItem;
@synthesize nameField = _nameField;
@synthesize addrField = _addrField;
@synthesize addr2Field = _addr2Field;
@synthesize cityField = _cityField;
@synthesize stateField = _stateField;
@synthesize zipField = _zipField;
@synthesize phoneField = _phoneField;
@synthesize faxField = _faxField;
@synthesize annualBirthsField = _annualBirthsField;
@synthesize kitLocationField = _kitLocationField;
@synthesize kitContactField = _kitContactField;
@synthesize kitThresholdField = _kitThresholdField;
@synthesize competitor2Field = _competitor2Field;
@synthesize competitor1Field = _competitor1Field;
@synthesize kitStockingField = _kitStockingField;
@synthesize activeStatus = _activeStatus;
@synthesize reasonField = _reasonField;
@synthesize pickerReasonArray = _pickerReasonArray;
@synthesize pickerComp1Array = _pickerComp1Array;
@synthesize pickerComp2Array = _pickerComp2Array;
@synthesize amountChargedField = _amountChargedField;
@synthesize chargesPatientSwitch = chargesPatientSwitch;
@synthesize percentMedicaidField = _percentMedicaidField;
@synthesize pickerCashPay = _pickerCashPay;
@synthesize pickerMedicaid = _pickerMedicaid;
@synthesize navBar = _navBar;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        _preDetailItem = newDetailItem;
    }
}


- (void)configureView
{
    // Update the user interface for the detail item.  
    if (self.detailItem) {
        if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Office"])
        {
            self.navBar.title = [[NSString alloc] initWithFormat:@"%@", @"Update Office"];
            self.nameField.enabled = TRUE;
        }
        else
        {
            self.navBar.title = [[NSString alloc] initWithFormat:@"%@", @"Update Hospital"];
            self.nameField.enabled = FALSE;
        }
        if ([self.detailItem valueForKey:@"name"] != NULL)
            [self.nameField setText:[self.detailItem valueForKey:@"name"]];
        
        if ([self.detailItem valueForKey:@"mainPhone"] != NULL)
            self.phoneField.text = [self.detailItem  valueForKey:@"mainPhone"];
        if ([self.detailItem valueForKey:@"mainFax"] != NULL)
            self.faxField.text = [self.detailItem  valueForKey:@"mainFax"];
        if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"])
        {
            self.annualBirthLabel.text = @"Annual # of Births:";
            if ([self.detailItem valueForKey:@"annualBirths"] != NULL)
                self.annualBirthsField.text = [[self.detailItem valueForKey:@"annualBirths"] description];
            
           
        }
        else
        {
            self.annualBirthLabel.text = @"% Cash Pay:";
            if ([[[self.detailItem valueForKey:@"percentCashPay"] description] length] > 0)
                self.annualBirthsField.text = [[self.detailItem valueForKey:@"percentCashPay"] description];
            else
                self.annualBirthsField.text = @"";
        }
        if ([[[self.detailItem valueForKey:@"percentMedicaid"] description] length] > 0)
            self.percentMedicaidField.text = [[self.detailItem valueForKey:@"percentMedicaid"] description];
        else
            self.percentMedicaidField.text = @"";
        if ([self.detailItem valueForKey:@"kitLocation"] != NULL)
            self.kitLocationField.text = [self.detailItem  valueForKey:@"kitLocation"];
        if ([self.detailItem valueForKey:@"kitThreshold"] != NULL)
            self.kitThresholdField.text = [[self.detailItem valueForKey:@"kitThreshold"] description];
        
        if ([self.detailItem valueForKey:@"competitor1"] != NULL)
            self.competitor1Field.text = [self.detailItem valueForKey:@"competitor1"];
        if ([self.detailItem valueForKey:@"competitor2"] != NULL)
            self.competitor2Field.text = [self.detailItem valueForKey:@"competitor2"];
        self.reasonField.text = [self.detailItem valueForKey:@"inactiveReason"];
        self.amountChargedField.text = [[self.detailItem valueForKey:@"amountCharged"] description];
        
        if ([[self.detailItem valueForKey:@"stockingOffice"] isEqualToString:@"Y"])
        {
            [self.kitStockingField setOn:YES];
        }
        else {
            [self.kitStockingField setOn:NO];
        }
        if ([[self.detailItem valueForKey:@"status"] isEqualToString:@"Active"])
        {
            [self.activeStatus setOn:YES];
        }
        else {
            [self.activeStatus setOn:NO];
        }
        if ([[self.detailItem valueForKey:@"chargesPatient"] isEqualToString:@"Y"])
        {
            [self.chargesPatientSwitch setOn:YES];
        }
        else {
            [self.chargesPatientSwitch setOn:NO];
        }
    
        self.pickerReasonArray = [[NSMutableArray alloc] init];
        [self.pickerReasonArray addObject:@""];
        [self.pickerReasonArray addObject:@"OFC - Closed"];
        [self.pickerReasonArray addObject:@"OFC - Duplicate"];
        [self.pickerReasonArray addObject:@"OFC - Moved"];
        [self.pickerReasonArray addObject:@"HOSP - No LMD"];
        [self.pickerReasonArray addObject:@"HOSP - Closed"];
        [self.pickerReasonArray addObject:@"HOSP - Duplicate"];
        [self.pickerReasonArray addObject:@"HOSP - Not a hospital"];
        
        UIPickerView *myPickerView = [[UIPickerView alloc] init];
        myPickerView.showsSelectionIndicator = YES;
        myPickerView.delegate = self;
        myPickerView.tag = 50;
        self.reasonField.inputView = myPickerView;
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
        self.reasonField.inputAccessoryView = keyboardDoneButtonView;
       
        self.pickerComp1Array = [[NSMutableArray alloc] init];
        [self.pickerComp1Array addObject:@""];
        [self.pickerComp1Array addObject:@"Alpha Cord"];
        [self.pickerComp1Array addObject:@"Americord Registry"];
        [self.pickerComp1Array addObject:@"AssureImmune"];
        [self.pickerComp1Array addObject:@"CORD:USE"];
        [self.pickerComp1Array addObject:@"Celebration Stem Cell Centre"];
        [self.pickerComp1Array addObject:@"CorCell"];
        [self.pickerComp1Array addObject:@"Cord Blood Solutions"];
        [self.pickerComp1Array addObject:@"Cord Inc."];
        [self.pickerComp1Array addObject:@"Cord Partners"];
        [self.pickerComp1Array addObject:@"Cord for Life (Lifeforce Cryobanks company)"];
        [self.pickerComp1Array addObject:@"CordTrack Partners"];
        [self.pickerComp1Array addObject:@"Cryo-Cell International"];
        [self.pickerComp1Array addObject:@"Cryobanks International"];
        [self.pickerComp1Array addObject:@"CureSource"];
        [self.pickerComp1Array addObject:@"DomaniCell"];
        [self.pickerComp1Array addObject:@"Elie Katz Umbilical Cord Blood Program"];
        [self.pickerComp1Array addObject:@"Family Cord Blood Services (California Cryobank)"];
        [self.pickerComp1Array addObject:@"GeneCell"];
        [self.pickerComp1Array addObject:@"Genesis Bank"];
        [self.pickerComp1Array addObject:@"HemaLife"];
        [self.pickerComp1Array addObject:@"LifeSource Cryobank LLC"];
        [self.pickerComp1Array addObject:@"Lifebank USA"];
        [self.pickerComp1Array addObject:@"Lifeline Cryogenics"];
        [self.pickerComp1Array addObject:@"MAZE Labs"];
        [self.pickerComp1Array addObject:@"NeoCells (ViviCells)"];
        [self.pickerComp1Array addObject:@"New England Cord Blood Bank"];
        [self.pickerComp1Array addObject:@"Newborn Blood Banking"];
        [self.pickerComp1Array addObject:@"PacifiCord"];
        [self.pickerComp1Array addObject:@"Regenerative Medicine Institute (RMI)"];
        [self.pickerComp1Array addObject:@"Safetycord, Inc."];
        [self.pickerComp1Array addObject:@"Securacell"];
        [self.pickerComp1Array addObject:@"Southern Cord"];
        [self.pickerComp1Array addObject:@"StemCyte Family (Cord Blood Family Trust)"];
        [self.pickerComp1Array addObject:@"Stembanc"];
        [self.pickerComp1Array addObject:@"Stork Medical"];
        [self.pickerComp1Array addObject:@"ViaCord"];
        [self.pickerComp1Array addObject:@"Xytex Cord Blood Bank"];
        
        UIPickerView *comp1PickerView = [[UIPickerView alloc] init];
        comp1PickerView.showsSelectionIndicator = YES;
        comp1PickerView.delegate = self;
        comp1PickerView.tag = 100;
        self.competitor1Field.inputView = comp1PickerView;
        // Plug the keyboardDoneButtonView into the text field...
        self.competitor1Field.inputAccessoryView = keyboardDoneButtonView;  
        
        self.pickerComp2Array = [[NSMutableArray alloc] init];
        [self.pickerComp2Array addObject:@""];
        [self.pickerComp2Array addObject:@"Alpha Cord"];
        [self.pickerComp2Array addObject:@"Americord Registry"];
        [self.pickerComp2Array addObject:@"AssureImmune"];
        [self.pickerComp2Array addObject:@"CORD:USE"];
        [self.pickerComp2Array addObject:@"Celebration Stem Cell Centre"];
        [self.pickerComp2Array addObject:@"CorCell"];
        [self.pickerComp2Array addObject:@"Cord Blood Solutions"];
        [self.pickerComp2Array addObject:@"Cord Inc."];
        [self.pickerComp2Array addObject:@"Cord Partners"];
        [self.pickerComp2Array addObject:@"Cord for Life (Lifeforce Cryobanks company)"];
        [self.pickerComp2Array addObject:@"CordTrack Partners"];
        [self.pickerComp2Array addObject:@"Cryo-Cell International"];
        [self.pickerComp2Array addObject:@"Cryobanks International"];
        [self.pickerComp2Array addObject:@"CureSource"];
        [self.pickerComp2Array addObject:@"DomaniCell"];
        [self.pickerComp2Array addObject:@"Elie Katz Umbilical Cord Blood Program"];
        [self.pickerComp2Array addObject:@"Family Cord Blood Services (California Cryobank)"];
        [self.pickerComp2Array addObject:@"GeneCell"];
        [self.pickerComp2Array addObject:@"Genesis Bank"];
        [self.pickerComp2Array addObject:@"HemaLife"];
        [self.pickerComp2Array addObject:@"LifeSource Cryobank LLC"];
        [self.pickerComp2Array addObject:@"Lifebank USA"];
        [self.pickerComp2Array addObject:@"Lifeline Cryogenics"];
        [self.pickerComp2Array addObject:@"MAZE Labs"];
        [self.pickerComp2Array addObject:@"NeoCells (ViviCells)"];
        [self.pickerComp2Array addObject:@"New England Cord Blood Bank"];
        [self.pickerComp2Array addObject:@"Newborn Blood Banking"];
        [self.pickerComp2Array addObject:@"PacifiCord"];
        [self.pickerComp2Array addObject:@"Regenerative Medicine Institute (RMI)"];
        [self.pickerComp2Array addObject:@"Safetycord, Inc."];
        [self.pickerComp2Array addObject:@"Securacell"];
        [self.pickerComp2Array addObject:@"Southern Cord"];
        [self.pickerComp2Array addObject:@"StemCyte Family (Cord Blood Family Trust)"];
        [self.pickerComp2Array addObject:@"Stembanc"];
        [self.pickerComp2Array addObject:@"Stork Medical"];
        [self.pickerComp2Array addObject:@"ViaCord"];
        [self.pickerComp2Array addObject:@"Xytex Cord Blood Bank"];
        
        UIPickerView *comp2PickerView = [[UIPickerView alloc] init];
        comp2PickerView.showsSelectionIndicator = YES;
        comp2PickerView.delegate = self;
        comp2PickerView.tag = 200;
        self.competitor2Field.inputView = comp2PickerView;
        
        self.competitor2Field.inputAccessoryView = keyboardDoneButtonView;
        
        if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Office"])
        {
            self.pickerCashPay = [[NSMutableArray alloc] init];
            int i = 0;
            while (i <= 100)
            {
                [self.pickerCashPay addObject:[NSString stringWithFormat:@"%d",i]];
                i = i + 5;
                
            }
            UIPickerView *cashpayPickerView = [[UIPickerView alloc] init];
            cashpayPickerView.showsSelectionIndicator = YES;
            cashpayPickerView.delegate = self;
            cashpayPickerView.tag = 300;
            self.annualBirthsField.inputView = cashpayPickerView;
            
            [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer,doneButton, nil]];
            
            // Plug the keyboardDoneButtonView into the text field...
            self.annualBirthsField.inputAccessoryView = keyboardDoneButtonView;

            
            self.pickerMedicaid = [[NSMutableArray alloc] init];
            i = 0;
            while (i <= 100)
            {
                [self.pickerMedicaid addObject:[NSString stringWithFormat:@"%d",i]];
                i = i + 5;
                
            }
            UIPickerView *medicaidPickerView = [[UIPickerView alloc] init];
            medicaidPickerView.showsSelectionIndicator = YES;
            medicaidPickerView.delegate = self;
            medicaidPickerView.tag = 400;
            self.percentMedicaidField.inputView = medicaidPickerView;
            
            [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer,doneButton, nil]];
            
            // Plug the keyboardDoneButtonView into the text field...
            self.percentMedicaidField.inputAccessoryView = keyboardDoneButtonView;
            
            //Kit Replenishment contact
            if ([self.detailItem valueForKey:@"kitContactId"] != NULL)
            {
                
                self.kitConIdField =[NSString stringWithFormat:@"%@",[[self.detailItem valueForKey:@"kitContactId"] description]];
                self.kitContactField.text =[NSString stringWithFormat:@"%@ %@",[[self.detailItem valueForKey:@"kitContactFirstName"] description], [[self.detailItem valueForKey:@"kitContactLastName"] description]];
            }
            self.pickerContactArray = [[NSMutableArray alloc] init];
            [self.pickerContactArray addObject:@""];

            self.pickerConIdArray = [[NSMutableArray alloc] init];
            NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
            [contact setValue:@"" forKey:@"rowId"];
            [contact setValue:@"" forKey:@"firstName"];
            [contact setValue:@"" forKey:@"lastName"];
            [self.pickerConIdArray addObject:contact];

            //
            NSManagedObjectContext *moc = [self.detailItem managedObjectContext];
            NSFetchRequest *fr = [[NSFetchRequest alloc] init];
            NSEntityDescription *contactEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:moc];
            [fr setEntity:contactEntity];
            
            NSPredicate *conPredicate = [NSPredicate predicateWithFormat: @"(officeId = %@ AND role = %@)",[self.detailItem valueForKey:@"rowId"],@"Provider"];
            [fr setPredicate:conPredicate];
            
            NSArray *conArray = [moc executeFetchRequest:fr error:nil];
            for (NSManagedObject *contact in conArray)
            {
                [self.pickerContactArray addObject:[NSString stringWithFormat:@"%@ %@",[contact valueForKey:@"firstName"], [contact valueForKey:@"lastName"]]];
                [self.pickerConIdArray addObject:contact];
            }
            UIPickerView *myContactPickerView = [[UIPickerView alloc] init];
            myContactPickerView.showsSelectionIndicator = YES;
            myContactPickerView.delegate = self;
            myContactPickerView.tag = 500;
            self.kitContactField.inputView = myContactPickerView;
        }
        
    }
}


- (void)pickerDoneClicked
{
    [self.reasonField resignFirstResponder];
    
    [self.competitor1Field resignFirstResponder];
    [self.competitor2Field resignFirstResponder];
    [self.annualBirthsField resignFirstResponder];
    [self.percentMedicaidField resignFirstResponder];
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




#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { 
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { 
    if (thePickerView.tag == 50)
        return [self.pickerReasonArray count];
    else if (thePickerView.tag == 100)
        return [self.pickerComp1Array count];
    else if (thePickerView.tag == 200)
        return [self.pickerComp2Array count];
    else if (thePickerView.tag == 300)
        return [self.pickerCashPay count];
    else if (thePickerView.tag == 400)
        return [self.pickerMedicaid count];
    else if (thePickerView.tag == 500)
        return [self.pickerContactArray count];
    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 
    if (thePickerView.tag == 50)
        return [self.pickerReasonArray objectAtIndex:row];
    else if (thePickerView.tag == 100)
        return [self.pickerComp1Array objectAtIndex:row];
    else if (thePickerView.tag == 200)
        return [self.pickerComp2Array objectAtIndex:row];
    else if (thePickerView.tag == 300)
        return [self.pickerCashPay objectAtIndex:row];
    else if (thePickerView.tag == 400)
        return [self.pickerMedicaid objectAtIndex:row];
    else if (thePickerView.tag == 500)
        return [self.pickerContactArray objectAtIndex:row];
    else {
        
        return 0;
    }
    
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
    if (thePickerView.tag == 50)
        [self.reasonField setText:[self.pickerReasonArray objectAtIndex:row]];
    else if (thePickerView.tag == 100)
        [self.competitor1Field setText:[self.pickerComp1Array objectAtIndex:row]];
    else if (thePickerView.tag == 200)
        [self.competitor2Field setText:[self.pickerComp2Array objectAtIndex:row]];
    else if (thePickerView.tag == 300)
        [self.annualBirthsField setText:[self.pickerCashPay objectAtIndex:row]];
    else if (thePickerView.tag == 400)
        [self.percentMedicaidField setText:[self.pickerMedicaid objectAtIndex:row]];
    else if (thePickerView.tag == 500)
    {
        [self.kitContactField setText:[self.pickerContactArray objectAtIndex:row]];
        self.kitConIdField = [[self.pickerConIdArray objectAtIndex:row] valueForKey:@"rowId"];
    }
    
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
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

    [self setAnnualBirthsField:nil];
    [self setKitLocationField:nil];
    [self setKitThresholdField:nil];
    [self setCompetitor2Field:nil];
    [self setCompetitor1Field:nil];
    [self setKitStockingField:nil];
    [self setActiveStatus:nil];
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

    [newTransaction setValue:[[obj valueForKey:@"rowId"] description] forKey:@"entityId"];
    [newTransaction setValue:@"Facility" forKey:@"entityType"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.latitude] forKey:@"latitude"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.longitude] forKey:@"longitude"];
    [newTransaction setValue:today forKey:@"transactionDate"];
    [newTransaction setValue:@"Update" forKey:@"transactionType"];

    [clm stopUpdatingLocation];
    
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    
    //[context save:nil];
}

- (IBAction)saveChanges:(id)sender {
    
    NSString *errorMsg = @"";
    if([self.annualBirthsField.text integerValue] <= 0 && self.activeStatus.isOn && [[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"] && self.activeStatus.isOn)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Annual # of Births is required"];
    }
    if([self.annualBirthsField.text integerValue] < 0 && [[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Office"] && self.activeStatus.isOn)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"% Cash Pay is required"];
    }
    if([[self.percentMedicaidField description] integerValue] < 0 && [[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Office"] && self.activeStatus.isOn)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"% Medicaid is required"];
    }

    if (self.kitStockingField.isOn && self.activeStatus.isOn)
    {
        if([self.kitLocationField.text length] == 0 && [[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"])
        {
            errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Kit Location is required"];
        }
        //if([self.kitThresholdField.text integerValue] < [[self.detailItem valueForKey:@"kitThreshold"] integerValue])
        if([self.kitThresholdField.text integerValue] < 0)
        {
            errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"New Kit Re-order Threshold must be equal to or higher than 0"];
        }
        //for Hospital, require Primary Kit Contact
        //for Office, Kit Contact is required.
        if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"])
        {
            NSManagedObjectContext *moc = [self.detailItem managedObjectContext];
            
            NSFetchRequest *fr = [[NSFetchRequest alloc] init];
            [fr setEntity:[NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:moc]];        
            [fr setPredicate:[NSPredicate predicateWithFormat: @"(officeId = %@) && (role = %@)", [self.detailItem valueForKey:@"rowId"],@"Primary Kit Contact"]];
            
            NSArray *contactArray = [moc executeFetchRequest:fr error:nil];
            
            if ([contactArray count] < 1) {
                errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Primary Kit Contact must be added"];
            }
        }
        else if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Office"])
        {
            if([self.kitContactField.text length] == 0)
            {
                errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Kit Contact is required"];
            }
            else{
                //[self.detailItem setValue:self.kitConIdField forKey:@"kitContactId"];
                for (NSManagedObject *contact in self.pickerConIdArray)
                    if ([self.kitConIdField isEqualToString:[contact valueForKey:@"rowId"]])
                    {
                        [self.detailItem setValue:[contact valueForKey:@"rowId"] forKey:@"kitContactId"];
                        [self.detailItem setValue:[contact valueForKey:@"firstName"] forKey:@"kitContactFirstName"];
                        [self.detailItem setValue:[contact valueForKey:@"lastName"] forKey:@"kitContactLastName"];
                        
                    }
                
            }
        }
    }
    if([self.nameField.text length] <= 0 && self.activeStatus.isOn)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Facility Name is required"];
    }
    
    if(!self.activeStatus.isOn && [self.reasonField.text length] <= 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Inactive Reason is required"];
    }
    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        [self.detailItem setValue:self.nameField.text forKey:@"name"];
        [self.detailItem setValue:self.phoneField.text forKey:@"mainPhone"];
        [self.detailItem setValue:self.faxField.text forKey:@"mainFax"];
        //[self.detailItem setValue:self.nameField.text forKey:@"name"];
        [self.detailItem setValue:self.kitLocationField.text forKey:@"kitLocation"];
        [self.detailItem setValue:[NSNumber numberWithInt:[self.kitThresholdField.text intValue]] forKey:@"kitThreshold"];
        if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"])
        {
            [self.detailItem setValue:[NSNumber numberWithInt:[self.annualBirthsField.text intValue]] forKey:@"annualBirths"];
        }
        else
        {
            if([self.annualBirthsField.text length] > 0)
                [self.detailItem setValue:[NSNumber numberWithInt:[self.annualBirthsField.text intValue]] forKey:@"percentCashPay"];
            if([self.percentMedicaidField.text length] > 0)
                [self.detailItem setValue:[NSNumber numberWithInt:[self.percentMedicaidField.text intValue]] forKey:@"percentMedicaid"];
        }
        [self.detailItem setValue:self.competitor1Field.text forKey:@"competitor1"];
        [self.detailItem setValue:self.competitor2Field.text forKey:@"competitor2"];
        if (self.kitStockingField.isOn) {
            [self.detailItem setValue:@"Y" forKey:@"stockingOffice"];
        }
        else {
            [self.detailItem setValue:@"N" forKey:@"stockingOffice"];
        }
        if (self.activeStatus.isOn) {
            [self.detailItem setValue:@"Active" forKey:@"status"];
        }
        else {
            [self.detailItem setValue:@"Inactive" forKey:@"status"];
        }
        [self.detailItem setValue:self.reasonField.text forKey:@"inactiveReason"];
        
        if (self.chargesPatientSwitch.isOn) {
            [self.detailItem setValue:@"Y" forKey:@"chargesPatient"];
        }
        else {
            [self.detailItem setValue:@"N" forKey:@"chargesPatient"];
        }
        [self.detailItem setValue:[NSNumber numberWithInt:[self.amountChargedField.text intValue]] forKey:@"amountCharged"];

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
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex 
{
    if(buttonIndex==0)
    {
        //Code that will run after you press ok button 
    }
}
- (IBAction)kitStockingFieldChange:(id)sender {
    if (!self.kitStockingField.isOn) {
        self.kitLocationField.text = @"";
        self.kitThresholdField.text = @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of sections.
    if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Office"] && section == 1)
        //Hide Annual Births for Office
        return 4;
    else if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"] && section == 3)
        //Hide Additional Info section for Hospital
        return 0;
    else if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"] && section == 2)
        //Hide Kit Contact for Hospital
        return 3;
    else
        switch (section) {

            case 0:     //General Info
                return 3;
                break;
                
            case 1:     //Competitor/Annual Birth
                return 3;
                break;
                
            case 2:     //Kit Information
                return 4;
                break;
            case 3:     //Additional Info
                return 2;
                break;
                
            case 4:     //Status
                return 2;
                break;
                
            default:
                return 0;
        }

}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //hides Additional Information for Hospital
    if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"] && section == 3)
        return [[UIView alloc] initWithFrame:CGRectZero];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //hides Additional Information for Hospital
    if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"] && section == 3)
        return 1;
    return 32;
}



@end
