//
//  cbrProviderDetailViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrProviderDetailViewController.h"
#import "cbrHospitalDetailViewController.h"

@interface cbrProviderDetailViewController()
- (void)configureView;
@end

@implementation cbrProviderDetailViewController
@synthesize facilityLabel = _facilityLabel;
@synthesize momentumLabel = _momentumLabel;
@synthesize momentumImage = _momentumImage;
@synthesize numBirthLabel = _numBirthLabel;
@synthesize phoneButton = _phoneButton;
@synthesize addrLabel = _addrLabel;
@synthesize navBar = _navBar;
@synthesize nameLabel = _nameLabel;
@synthesize myObject = _myObject;
@synthesize openActivitiesCell = _openActivitiesCell;
@synthesize kitsCell = _kitsCell;
@synthesize emailLabel = _emailLabel;
@synthesize providerIDLabel = _providerIDLabel;
@synthesize avgQualityScoreLabel = _avgQualityScoreLabel;
@synthesize ageLabel = _ageLabel;
@synthesize continuumLabel = _continuumLabel;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize detailItem = _detailItem;

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
        
        self.navBar.title = [[NSString alloc] initWithFormat:@"%@ %@", [[self.detailItem  valueForKey:@"firstName"] description], [[self.detailItem  valueForKey:@"lastName"] description]];
        self.nameLabel.text = [[NSString alloc] initWithFormat:@"%@ %@, %@ (%@)", [[self.detailItem  valueForKey:@"firstName"] description], [[self.detailItem  valueForKey:@"lastName"] description], [[self.detailItem  valueForKey:@"credential"] description], [[self.detailItem  valueForKey:@"category"] description]];
        self.providerIDLabel.text = [[NSString alloc] initWithFormat:@"Provider ID: %@", [[self.detailItem  valueForKey:@"personUID"] description]];

        if ([[[self.detailItem valueForKey:@"salesContinuum"] description] length] > 0)
        {
            self.continuumLabel.text = [[NSString alloc] initWithFormat:@"Continuum: %@", [[self.detailItem valueForKey:@"salesContinuum"] description]];
        }
        else
            self.continuumLabel.text = @"Continuum: Not Available";

        
        if ([[[self.detailItem valueForKey:@"birthYear"] description] length] > 0 && [[[self.detailItem valueForKey:@"birthYear"] description] intValue] > 0)
        {
            NSDate *currentDate = [NSDate date];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
            NSInteger calcAge = [components year] - [[[self.detailItem valueForKey:@"birthYear"] description] intValue];
            self.ageLabel.text = [[NSString alloc] initWithFormat:@"Dr Age: %d", calcAge];
        }
        else
            self.ageLabel.text = @"Dr Age: Not Available";

        
        if ([[[self.detailItem valueForKey:@"monthlyBirth"] description] length] > 0)
            self.numBirthLabel.text = [[NSString alloc] initWithFormat:@"Monthly # of Births: %@", [[self.detailItem valueForKey:@"monthlyBirth"] description]];
        else
            self.numBirthLabel.text = @"Monthly # of Births: N/A";

        if ([self.detailItem valueForKey:@"avgQualityScore"] != [NSNull null])
            self.avgQualityScoreLabel.text = [[NSString alloc] initWithFormat:@"Avg Quality CB Collection Score: %@", [[self.detailItem valueForKey:@"avgQualityScore"] description]];
        else
            self.avgQualityScoreLabel.text = @"Avg Quality CB Collection Score: N/A";
        
        
 
        if ([[[self.detailItem valueForKey:@"rating"] description] length] > 0)
            self.momentumLabel.text = [[NSString alloc] initWithFormat:@"(%@)", [[self.detailItem valueForKey:@"rating"] description]];
        else 
            self.momentumLabel.text = @"";

        //self.emailLabel.text = [[self.detailItem valueForKey:@"emailPrimary"] description];
        
        if ([[self.detailItem valueForKey:@"emailPrimary"] length] > 0)
            self.emailLabel.text = [[NSString alloc] initWithFormat:@"%@", [self.detailItem valueForKey:@"emailPrimary"]];
        else
            self.emailLabel.text = @"No email on file";
        if ([[self.detailItem valueForKey:@"pfOfficeHours"] length] > 0)
            self.officeHoursLabel.text = [[NSString alloc] initWithFormat:@"Doctor's Office Hours: %@", [self.detailItem valueForKey:@"pfOfficeHours"]];
        else
            self.officeHoursLabel.text = @"No Doctor's Office Hours on file";
        
        NSString *momentum = [[self.detailItem valueForKey:@"rating"] description];
        if ([momentum isEqualToString:@"P1"]) {
            [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_1.png"]];}
        else if ([momentum isEqualToString:@"P2"]) {
            [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_2.png"]];}
        else if ([momentum isEqualToString:@"P3"]) {
            [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_3.png"]];}
        else if ([momentum isEqualToString:@"P4"]) {
            [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_4.png"]];}
        else if ([momentum isEqualToString:@"P5"]) {
            [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_5.png"]];}
        else {
            [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_6.png"]];}

        NSString *phoneNumberString = [[self.detailItem valueForKey:@"pfPhone"] description];
        if([phoneNumberString length] == 10)
        {
            NSRange areaCodeRange = {0, 3};
            NSString *areaCodeString = [phoneNumberString substringWithRange:areaCodeRange];
        
            NSRange prefixRange = {3, 3};
            NSString *prefixString = [phoneNumberString substringWithRange:prefixRange];
        
            NSString *lineNumberString = [phoneNumberString substringFromIndex:6];
            phoneNumberString = [NSString stringWithFormat:@"(%@) %@-%@", areaCodeString, prefixString, lineNumberString];
            [self.phoneButton setTitle:[NSString stringWithFormat:@"Phone: %@",phoneNumberString] forState:UIControlStateNormal];
        }
        else
        {
            [self.phoneButton setTitle:[NSString stringWithFormat:@"Phone: %@",[[self.detailItem valueForKey:@"pfPhone"] description]] forState:UIControlStateNormal];
        }


        self.facilityLabel.text = [[self.detailItem valueForKey:@"facilityName"] description];
        if ([[self.detailItem valueForKey:@"facilityAddr2"] description].length > 0)
            self.addrLabel.text = [[NSString alloc] initWithFormat:@"%@, %@\n%@, %@ %@", [[self.detailItem  valueForKey:@"facilityAddr"] description], [[self.detailItem  valueForKey:@"facilityAddr2"] description], [[self.detailItem  valueForKey:@"facilityCity"] description], [[self.detailItem  valueForKey:@"facilityState"] description], [[self.detailItem  valueForKey:@"facilityZipcode"] description]];
        else
            self.addrLabel.text = [[NSString alloc] initWithFormat:@"%@\n%@, %@ %@", [[self.detailItem  valueForKey:@"facilityAddr"] description], [[self.detailItem  valueForKey:@"facilityCity"] description], [[self.detailItem  valueForKey:@"facilityState"] description], [[self.detailItem  valueForKey:@"facilityZipcode"] description]];
        
        
        UIColor *cbrRed = [UIColor colorWithRed:155/255.0 green:0/255.0 blue:46/255.0 alpha:1];
        UIColor *cbrPurple = [UIColor colorWithRed:110/255.0 green:98/255.0 blue:174/255.0 alpha:1];
        
        NSInteger openActivities= [self countOpenActivities:self.detailItem];
        if (openActivities > 0) {
            [[self.openActivitiesCell detailTextLabel] setText:[NSString stringWithFormat:@"%d",openActivities]];
            [[self.openActivitiesCell textLabel] setTextColor:cbrRed];
            [[self.openActivitiesCell detailTextLabel] setTextColor:cbrRed];
        }
        else {
            [[self.openActivitiesCell detailTextLabel] setText:[NSString stringWithFormat:@""]];
            [[self.openActivitiesCell textLabel] setTextColor:cbrPurple];
            [[self.openActivitiesCell detailTextLabel] setTextColor:cbrPurple];
        }
        NSInteger expiredKits = [self countExpiredKits:self.detailItem];
        if (expiredKits > 0) {
            [[self.kitsCell detailTextLabel] setText:[NSString stringWithFormat:@"%d",expiredKits]];
            [[self.kitsCell textLabel] setTextColor:cbrRed];
            [[self.kitsCell detailTextLabel] setTextColor:cbrRed];
        }
        else {
            [[self.kitsCell detailTextLabel] setText:[NSString stringWithFormat:@""]];
            [[self.kitsCell textLabel] setTextColor:cbrPurple];
            [[self.kitsCell detailTextLabel] setTextColor:cbrPurple];
        }

        //Sales Metrics on Provider view
        self.ACDvsTotal.text = [NSString stringWithFormat:@"ACD/Total Opptys:  %@%%", [[self.detailItem  valueForKey:@"aCDvsTotal"] description]];
        self.NewEnrollments.text = [NSString stringWithFormat:@"New Enrollments:  %@%%", [[self.detailItem  valueForKey:@"newEnrollments"] description]];
        self.Educated.text = [NSString stringWithFormat:@"Educated:  %@ (%@%%)", [[self.detailItem  valueForKey:@"educated"] description], [[self.detailItem  valueForKey:@"educated_pct"] description]];
        self.CTCB_Ratio.text = [NSString stringWithFormat:@"CT/CB Ratio:  %@%%", [[self.detailItem  valueForKey:@"cTCB_Ratio"] description]];
        self.TotalOpptys.text = [NSString stringWithFormat:@"Total Opptys:  %@", [[self.detailItem  valueForKey:@"totalOpptys"] description]];
        self.Total_Enrollments.text = [NSString stringWithFormat:@"Total Enrollments:  %@", [[self.detailItem  valueForKey:@"total_Enrollments"] description]];
        self.TotalCBStorages.text = [NSString stringWithFormat:@"Total CT Storages:  %@", [[self.detailItem  valueForKey:@"totalCTStorages"] description]];
        self.TotalCTStorages.text = [NSString stringWithFormat:@"Total CB Storages:  %@", [[self.detailItem  valueForKey:@"totalCBStorages"] description]];
        self.PenetrationRate.text = [NSString stringWithFormat:@"Penetration Rate:  %@%%", [[self.detailItem  valueForKey:@"penetrationRate"] description]];
        self.numOfCalls.text = [NSString stringWithFormat:@"# of Calls:  %@", [[self.detailItem  valueForKey:@"calls"] description]];

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
    //[self configureView];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setFacilityLabel:nil];
    [self setAddrLabel:nil];
    [self setMomentumImage:nil];
    [self setNumBirthLabel:nil];
    [self setPhoneButton:nil];
    [self setAddrLabel:nil];
    [self setNavBar:nil];
    [self setMomentumLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"seePatients"] || [[segue identifier] isEqualToString:@"providerCheckIn"] || [[segue identifier] isEqualToString:@"seeOffices"] || [[segue identifier] isEqualToString:@"notesList"] || [[segue identifier] isEqualToString:@"providerContacts"] || [[segue identifier] isEqualToString:@"kitScan"]|| [[segue identifier] isEqualToString:@"seeSummary"] || [[segue identifier] isEqualToString:@"moreInfo"] || [[segue identifier] isEqualToString:@"seeHistory"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
    
    else if ([[segue identifier] isEqualToString:@"hospitalDetail"])
    {  
        /*
        NSManagedObjectContext *moc = self.managedObjectContext;
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];

        [fr setEntity:entity];
        
        NSPredicate *officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [[self.detailItem  valueForKey:@"facilityId"] description]];
        [fr setPredicate:officePredicate];
        NSLog(@"%@", officePredicate);
        
        NSSortDescriptor *officeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];

        [fr setSortDescriptors:[NSArray arrayWithObject:officeSortDescriptor]];
        NSArray *officeArray = [moc executeFetchRequest:fr error:nil];
        
        cbrHospitalDetailViewController *hospitalController = (cbrHospitalDetailViewController *)[segue destinationViewController];
        
        hospitalController.providerItem = self.detailItem;
        [[segue destinationViewController] setDetailItem:[officeArray objectAtIndex:0]];
    */
        cbrHospitalDetailViewController *hospitalController = (cbrHospitalDetailViewController *)[segue destinationViewController];
        
        hospitalController.providerItem = self.detailItem;
        
    }
     
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
//    NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    self.detailItem = selectedObject;


}

- (NSInteger)countOpenActivities:(NSManagedObject *) office
{
    NSManagedObjectContext *moc = [office managedObjectContext];
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *actionEntity = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];
    
    [fr setEntity:actionEntity];
    
    NSPredicate *statusPredicate = [NSPredicate predicateWithFormat:@"(contactId = %@ && status = %@ && (descriptionType != %@ || descriptionType = nil))", [self.detailItem valueForKey:@"rowId"],@"Open", @"Note from RM"];
    
    [fr setPredicate:statusPredicate];
    
    NSArray *actionArray = [moc executeFetchRequest:fr error:nil];
    
    return [actionArray count];
}

- (NSInteger)countExpiredKits:(NSManagedObject *) provider
{
    NSManagedObjectContext *moc = [provider managedObjectContext];
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *kitEntity = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
    [fr setEntity:kitEntity];
    NSDate *today = [NSDate date];
    int daysToAdd = 180;  
    NSDate *agingDate = [today dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    
    //NSPredicate *assetPredicate = [NSPredicate predicateWithFormat: @"(assignedContactId = %@) && (expirationDate <= %@)", [provider valueForKey:@"rowId"],agingDate];
    NSPredicate *assetPredicate = [NSPredicate predicateWithFormat: @"(assignedOfficeId = %@) && (expirationDate <= %@)  && (status != %@ || status == nil)", [provider valueForKey:@"facilityId"],agingDate,@"Inactive/Lost"];
    
    
    [fr setPredicate:assetPredicate];
    
    NSArray *assetArray = [moc executeFetchRequest:fr error:nil];
    
    return [assetArray count];
}


- (IBAction)callPhone:(id)sender {
    NSString *strButton = [[NSString alloc] initWithFormat:@"tel://%@", [[self.detailItem valueForKey:@"pfPhone"] description]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strButton]];
}

- (IBAction)mapDirections:(id)sender {
    CLLocationManager *clm = [[CLLocationManager alloc] init];
    
    clm.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [clm startUpdatingLocation];
    
    CLLocationCoordinate2D currentLocation = [[clm location] coordinate];
    NSString* address = [[NSString alloc] initWithFormat:@"%@, %@, %@, %@", [[self.detailItem  valueForKey:@"facilityAddr"] description],[[self.detailItem  valueForKey:@"facilityCity"] description], [[self.detailItem  valueForKey:@"facilityState"] description], [[self.detailItem  valueForKey:@"facilityZipcode"] description]]; 
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
                     currentLocation.latitude, currentLocation.longitude,
                     [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [clm stopUpdatingLocation];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];}

@end
