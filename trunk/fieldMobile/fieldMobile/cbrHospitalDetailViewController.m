//
//  cbrHospitalDetailViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrHospitalDetailViewController.h"
#import "cbrCheckInViewController.h"
#import "cbrContactsViewController.h"
#import "cbrProviderDetailViewController.h"

@interface cbrHospitalDetailViewController()
- (void)configureView;
@end

@implementation cbrHospitalDetailViewController
@synthesize momentumImage = _momentumImage;
@synthesize detailCompetitor2 = _detailCompetitor2;
@synthesize detailCompetitor1 = _detailCompetitor1;
@synthesize navBar = _navBar;
@synthesize openActivitiesCell = _openActivitiesCell;
@synthesize kitsCell = _kitsCell;

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize detailCityStateZipLabel = _detailCityStateZipLabel;
@synthesize detailPhoneLabel = _detailPhoneLabel;
@synthesize detailMomentumLabel = _detailMomentumLabel;
@synthesize detailAnnualBirths = _detailAnnualBirths;
@synthesize detailPatientsUndecided = _detailPatientsUndecided;
@synthesize detailPatientsEnrolled = _detailPatientsEnrolled;
@synthesize detailPatientsCollected = _detailPatientsCollected;
@synthesize detailQualityScore = _detailQualityScore;
@synthesize detailCTYield = _detailCTYield;
@synthesize detailAddress = _detailAddress;
@synthesize detailFax = _detailFax;
@synthesize providerItem = _providerItem;
@synthesize detailFacilityIdLabel = _detailFacilityIdLabel;

#pragma mark - Managing the detail item
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.    
    if ((self.detailItem == nil) && (self.providerItem != nil))
    {
        NSManagedObjectContext *moc = [self.providerItem managedObjectContext];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
        
        [fr setEntity:entity];
        
        NSPredicate *officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [[self.providerItem  valueForKey:@"facilityId"] description]];
        [fr setPredicate:officePredicate];
        //NSLog(@"%@", officePredicate);
        NSArray *officeArray = [moc executeFetchRequest:fr error:nil];
    
        self.detailItem = [officeArray objectAtIndex:0];

        
    }
    if (self.detailItem) {
        
        self.navBar.title = [[NSString alloc] initWithFormat:@"%@", [[self.detailItem  valueForKey:@"name"] description]];

        [self.detailDescriptionLabel setText:[self.detailItem valueForKey:@"name"]];
        [self.detailFacilityIdLabel setText:[[NSString alloc] initWithFormat:@"Facility Id: %@", [self.detailItem valueForKey:@"integrationId"]]];
        if ([[[self.detailItem valueForKey:@"officeType"] description] isEqualToString:@"Hospital"])
        {
            if  ([[[self.detailItem valueForKey:@"annualBirths"] description] length] > 0)
                [self.detailAnnualBirths setText:[[NSString alloc] initWithFormat:@"Annual # of Births: %@", [self.detailItem valueForKey:@"annualBirths"]]];
            else
                [self.detailAnnualBirths setText:[[NSString alloc] initWithFormat:@"Annual # of Births: Not Available"]];
            if ([[[self.detailItem valueForKey:@"hospAnnualNM75K"] description] length] > 0)
                [self.nm75kBirth setText:[[NSString alloc] initWithFormat:@"NM 75k+ Births: %@", [self.detailItem valueForKey:@"hospAnnualNM75K"]]];
            else
                [self.nm75kBirth setText:[[NSString alloc] initWithFormat:@"NM 75k+ Births: Not Available"]];
        }
        else
        {
            if ([[[self.detailItem valueForKey:@"percentCashPay"] description] length] > 0)
                [self.detailAnnualBirths setText:[[NSString alloc] initWithFormat:@"%% Cash pay: %@", [self.detailItem valueForKey:@"percentCashPay"]]];
            else
                [self.detailAnnualBirths setText:[[NSString alloc] initWithFormat:@"%% Cash pay: Not Available"]];
            if ([[[self.detailItem valueForKey:@"percentMedicaid"] description] length] > 0)
                [self.nm75kBirth setText:[[NSString alloc] initWithFormat:@"%% Medicaid: %@", [self.detailItem valueForKey:@"percentMedicaid"]]];
            else
                [self.nm75kBirth setText:[[NSString alloc] initWithFormat:@"%% Medicaid: Not Available"]];
        }
        
        self.numOfCalls.text = [NSString stringWithFormat:@"# of Calls:  %@", [[self.detailItem  valueForKey:@"calls"] description]];        
        [self.detailPatientsUndecided setText:[NSString stringWithFormat:@"Undecided Patients: %@", @"coming soon."]];
        [self.detailPatientsEnrolled setText: [[NSString alloc] initWithFormat:@"Enrolled Patients: %@", @"coming soon."]];
        self.detailPatientsCollected.text = [[NSString alloc] initWithFormat:@"Collected Patients: %@", @"coming soon."];
        self.detailQualityScore.text = [[NSString alloc] initWithFormat:@"Avg Quality CB Collection Score: %@", @"coming soon."];
        self.detailCTYield.text = [[NSString alloc] initWithFormat:@"Cord Tissue Yield: %@", @"coming soon."];
        
        if ([self.detailItem valueForKey:@"competitor1"] != NULL)
            self.detailCompetitor1.text = [[NSString alloc] initWithFormat:@"Competitor 1: %@", [self.detailItem valueForKey:@"competitor1"]];
        if ([self.detailItem valueForKey:@"competitor2"] != NULL)
            self.detailCompetitor2.text = [[NSString alloc] initWithFormat:@"Competitor 2: %@", [self.detailItem valueForKey:@"competitor2"]];
        
        NSString *addrDisplay = [NSString stringWithFormat:@"%@",[self.detailItem  valueForKey:@"addr"]];
        if ([self.detailItem valueForKey:@"addr2"] != nil)
            addrDisplay = [NSString stringWithFormat:@"%@, %@",addrDisplay,[self.detailItem valueForKey:@"addr2"]];
        
        [self.detailAddress setText:addrDisplay];
        
        self.detailCityStateZipLabel.text = [[NSString alloc] initWithFormat:@"%@, %@ %@", [[self.detailItem  valueForKey:@"city"] description], [[self.detailItem  valueForKey:@"state"] description], [[self.detailItem  valueForKey:@"zipcode"] description]]; 
        
        NSString *phoneNumberString = [[self.detailItem valueForKey:@"mainPhone"] description];
        if([phoneNumberString length] == 10)
        {
            NSRange areaCodeRange = {0, 3};
            NSString *areaCodeString = [phoneNumberString substringWithRange:areaCodeRange];
            
            NSRange prefixRange = {3, 3};
            NSString *prefixString = [phoneNumberString substringWithRange:prefixRange];
            
            NSString *lineNumberString = [phoneNumberString substringFromIndex:6];
            //self.detailPhoneLabel.titleLabel.text = [NSString stringWithFormat:@"Phone: %@",[NSString stringWithFormat:@"(%@) %@-%@", areaCodeString, prefixString, lineNumberString]];
            phoneNumberString = [NSString stringWithFormat:@"(%@) %@-%@", areaCodeString, prefixString, lineNumberString];
            [self.detailPhoneLabel setTitle:[NSString stringWithFormat:@"Phone: %@",phoneNumberString] forState:UIControlStateNormal];
        }
        else
        {
            [self.detailPhoneLabel setTitle:[NSString stringWithFormat:@"Phone: %@",[[self.detailItem valueForKey:@"mainPhone"] description]] forState:UIControlStateNormal];
        }
        
        phoneNumberString = [[self.detailItem valueForKey:@"mainFax"] description];
        if([phoneNumberString length] == 10)
        {
            NSRange areaCodeRange = {0, 3};
            NSString *areaCodeString = [phoneNumberString substringWithRange:areaCodeRange];
            
            NSRange prefixRange = {3, 3};
            NSString *prefixString = [phoneNumberString substringWithRange:prefixRange];
            
            NSString *lineNumberString = [phoneNumberString substringFromIndex:6];
            self.detailFax.text = [NSString stringWithFormat:@"Fax: %@",[NSString stringWithFormat:@"(%@) %@-%@", areaCodeString, prefixString, lineNumberString]];
        }
        else
        {
            [self.detailFax setText:[NSString stringWithFormat:@"Fax: %@",[[self.detailItem valueForKey:@"mainFax"] description]]];
        }
                
        int momentum = 0;
        if ([[[self.detailItem valueForKey:@"officeType"] description] isEqualToString:@"Hospital"])
        {
            self.momentumImage.hidden = false;
            self.detailMomentumLabel.hidden = false;
            self.numOfCalls.hidden = false;
            //self.detailAnnualBirths.hidden = false;
            //self.nm75kBirth.hidden = false;
            
            if ([[[self.detailItem valueForKey:@"rating"] description] length] > 0)
                self.detailMomentumLabel.text = [[NSString alloc] initWithFormat:@"(%@)", [[self.detailItem valueForKey:@"rating"] description]];
            else
                [self.detailMomentumLabel setText:[[NSString alloc] initWithFormat:@"Not Available"]];
            
            momentum = [[self.detailItem valueForKey:@"rating"] intValue];
            if (momentum > 0 && momentum <= 100) {
                [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_1.png"]];}
            else if (momentum > 100 && momentum <= 200) {
                [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_2.png"]];}
            else if (momentum > 200 && momentum <= 300) {
                [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_3.png"]];}
            else if (momentum > 300 && momentum <= 400) {
                [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_4.png"]];}
            else if (momentum > 400 && momentum <= 1000) {
                [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_5.png"]];}
            else {
                [self.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_6.png"]];}
        }
        else
        {
            self.momentumImage.hidden = true;
            self.detailMomentumLabel.hidden = true;
            self.numOfCalls.hidden = true;
            //self.detailAnnualBirths.hidden = true;
            //self.nm75kBirth.hidden = true;
        }
        //self.navigationItem.prompt = [[self.detailItem valueForKey:@"name"] description];
        UIColor *cbrRed = [UIColor colorWithRed:155/255.0 green:0/255.0 blue:46/255.0 alpha:1];
        UIColor *cbrPurple = [UIColor colorWithRed:110/255.0 green:98/255.0 blue:174/255.0 alpha:1];
        
        NSInteger openActivities= [self countOpenActivities:self.detailItem];
        if (openActivities > 0) {
            [[self.openActivitiesCell detailTextLabel] setText:[NSString stringWithFormat:@"%d",openActivities] ];
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

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDetailCityStateZipLabel:nil];
    [self setDetailPhoneLabel:nil];
    [self setDetailMomentumLabel:nil];
    [self setDetailAnnualBirths:nil];
    [self setDetailAnnualBirths:nil];
    [self setDetailPatientsUndecided:nil];
    [self setDetailPatientsEnrolled:nil];
    [self setDetailPatientsCollected:nil];
    [self setDetailQualityScore:nil];
    [self setDetailCTYield:nil];
    [self setDetailAddress:nil];
    [self setDetailFax:nil];
    [self setMomentumImage:nil];
    [self setDetailCompetitor2:nil];
    [self setDetailCompetitor1:nil];
    [self setOpenActivitiesCell:nil];
    [self setKitsCell:nil];
    [self setNavBar:nil];
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
    if ([[segue identifier] isEqualToString:@"officeMoreInfo"] || [[segue identifier] isEqualToString:@"seeHistory"] || [[segue identifier] isEqualToString:@"seeNotes"] || [[segue identifier] isEqualToString:@"hospitalCheckIn"] || [[segue identifier] isEqualToString:@"hospitalContacts"] || [[segue identifier] isEqualToString:@"seeKits"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
}


- (IBAction)makeCall:(id)sender {
    NSString *strButton = [[NSString alloc] initWithFormat:@"tel://%@", [[self.detailItem valueForKey:@"mainPhone"] description]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strButton]];
/*
    
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"%@",[self.detailItem valueForKey:@"mainPhone"]];
    [phone replaceOccurrencesOfString:@" " 
                           withString:@"" 
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@"(" 
                           withString:@"" 
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@")" 
                           withString:@"" 
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, [phone length])];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
    [[UIApplication sharedApplication] openURL:url];
 */
}

- (IBAction)getDirections:(id)sender {
    CLLocationManager *clm = [[CLLocationManager alloc] init];
    
    clm.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [clm startUpdatingLocation];
    
    CLLocationCoordinate2D currentLocation = [[clm location] coordinate];
    NSString* address = [[NSString alloc] initWithFormat:@"%@, %@, %@, %@", [[self.detailItem  valueForKey:@"addr"] description],[[self.detailItem  valueForKey:@"city"] description], [[self.detailItem  valueForKey:@"state"] description], [[self.detailItem  valueForKey:@"zipcode"] description]]; 
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
                     currentLocation.latitude, currentLocation.longitude,
                     [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [clm stopUpdatingLocation];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];}

- (NSInteger)countOpenActivities:(NSManagedObject *) office
{
    NSManagedObjectContext *moc = [office managedObjectContext];
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];

    NSEntityDescription *actionEntity = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];

    [fr setEntity:actionEntity];
        
    NSPredicate *statusPredicate = [NSPredicate predicateWithFormat:@"(officeId = %@ && status = %@ && (descriptionType != %@ || descriptionType = nil))", [self.detailItem valueForKey:@"rowId"],@"Open", @"Note from RM"];
        
    [fr setPredicate:statusPredicate];
 
    NSArray *actionArray = [moc executeFetchRequest:fr error:nil];
    
    return [actionArray count];
}

- (NSInteger)countExpiredKits:(NSManagedObject *) office
{
    NSManagedObjectContext *moc = [office managedObjectContext];
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *kitEntity = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
    [fr setEntity:kitEntity];
    NSDate *today = [NSDate date];
    int daysToAdd = 180;  
    NSDate *agingDate = [today dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    NSPredicate *assetPredicate = [NSPredicate predicateWithFormat: @"(assignedOfficeId = %@) && (expirationDate <= %@) && (status != %@ || status == nil)", [office valueForKey:@"rowId"],agingDate,@"Inactive/Lost"];

    [fr setPredicate:assetPredicate];
   
    NSArray *assetArray = [moc executeFetchRequest:fr error:nil];
    
    return [assetArray count];
}

- (IBAction)goYelp:(id)sender {
    NSMutableString *name = [[NSMutableString alloc] initWithFormat:@"%@",[self.detailItem valueForKey:@"name"]];
    [name replaceOccurrencesOfString:@" " 
                           withString:@"+" 
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, [name length])];
    [name replaceOccurrencesOfString:@"'" 
                           withString:@"" 
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, [name length])];
    [name replaceOccurrencesOfString:@"’" 
                           withString:@"" 
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, [name length])];
    NSMutableString *city = [[NSMutableString alloc] initWithFormat:@"%@",[self.detailItem valueForKey:@"city"]];
    [city replaceOccurrencesOfString:@" " 
                          withString:@"+" 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, [city length])];
    [city replaceOccurrencesOfString:@"’" 
                          withString:@"" 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, [city length])];
    [city replaceOccurrencesOfString:@")" 
                          withString:@"" 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, [city length])];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.yelp.com/search?find_desc=%@&find_loc=%@", [name stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [city stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];

}
- (IBAction)goTwitter:(id)sender {
    NSMutableString *name = [[NSMutableString alloc] initWithFormat:@"%@",[self.detailItem valueForKey:@"name"]];
    [name replaceOccurrencesOfString:@" " 
                          withString:@" " 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, [name length])];
    [name replaceOccurrencesOfString:@"'" 
                          withString:@"" 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, [name length])];
    [name replaceOccurrencesOfString:@"’" 
                          withString:@"" 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, [name length])];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/#!/search/users/%@", [name stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    NSLog(@"%@",url);
    [[UIApplication sharedApplication] openURL:url];

}
@end
