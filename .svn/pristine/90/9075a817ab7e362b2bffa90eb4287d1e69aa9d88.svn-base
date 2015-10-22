//
//  cbrActionUpdateViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrActionUpdateViewController.h"

#define maxLength 255

@interface cbrActionUpdateViewController ()
- (void)recordTransaction:(NSManagedObject *) obj;
- (void)configureView;
@end

@implementation cbrActionUpdateViewController
@synthesize activityDueDate = _activityDueDate;
@synthesize activityDescType = _activityDescType;
@synthesize activityComments = _activityComments;
@synthesize entityName = _entityName;
@synthesize actId = _actId;
@synthesize locationManager = _locationManager;
@synthesize activityStatus = _activityStatus;
@synthesize missingComment = _missingComment;
@synthesize completedComment = _completedComment;

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
- (void)configureView
{
    self.missingComment = @"N";
    
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        
        NSArray *providerArray = [[NSArray alloc] init];
        if ([self.detailItem valueForKey:@"contactId"] != nil)
        {
            NSManagedObjectContext *moc = [self.detailItem managedObjectContext];
            NSFetchRequest *fr = [[NSFetchRequest alloc] init];
            NSEntityDescription *providerEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:moc];
            [fr setEntity:providerEntity];
            NSPredicate *providerPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"contactId"]];
            [fr setPredicate:providerPredicate];
            providerArray = [moc executeFetchRequest:fr error:nil];
            
            for (NSManagedObject *provider in providerArray) {
                [self.entityName setText:[[NSString alloc] initWithFormat:@"Provider: %@ %@",[provider valueForKey:@"firstName"],[provider valueForKey:@"lastName"]]];
            }
        }
            
        if (([self.detailItem valueForKey:@"officeId"] != nil) && [providerArray count] ==0)
        {
            NSManagedObjectContext *moc = [self.detailItem managedObjectContext];
            NSFetchRequest *fr = [[NSFetchRequest alloc] init];
            NSEntityDescription *officeEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
            [fr setEntity:officeEntity];
            NSPredicate *officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"officeId"]];
            [fr setPredicate:officePredicate];
            NSArray *officeArray = [moc executeFetchRequest:fr error:nil];
            
            for (NSManagedObject *office in officeArray) {
                [self.entityName setText:[[NSString alloc] initWithFormat:@"Facility: %@",[office valueForKey:@"name"]]];
            }
        }
        [self.actId setText:[NSString stringWithFormat:@"Activity Id: %@",[self.detailItem valueForKey:@"integrationId"]]];
        if ([self.detailItem valueForKey:@"type"] != NULL)
            [self.activityDescType setText:[[NSString alloc] initWithFormat:@"%@",[self.detailItem valueForKey:@"type"]]];
        if ([self.detailItem valueForKey:@"note"] != NULL)
            [self.activityComments setText:[[NSString alloc] initWithFormat:@"%@",[self.detailItem valueForKey:@"note"]]];
        else
            [self.activityComments setText:@""];
        /*
        if(([[self.detailItem valueForKey:@"type"] isEqualToString:@"Email - Outbound"] && [[self.detailItem valueForKey:@"descriptionType"] rangeOfString:@"NAR - CG/OFC"].location != NSNotFound)  ||
           
           ([[self.detailItem valueForKey:@"type"] rangeOfString:@"CFM"].location != NSNotFound) ||
           
           ([[self.detailItem valueForKey:@"type"] isEqualToString:@"FYI"] && [[self.detailItem valueForKey:@"subType"] rangeOfString:@"New Kit / CT Training"].location != NSNotFound)  ||
           
           ([[self.detailItem valueForKey:@"type"] isEqualToString:@"To Do"] && [[self.detailItem valueForKey:@"subType"] rangeOfString:@"Follow-up"].location != NSNotFound)  ||
           
           ([[self.detailItem valueForKey:@"type"] isEqualToString:@"Email - Outbound"] && [[self.detailItem valueForKey:@"descriptionType"] rangeOfString:@"NAR - HOSP"].location != NSNotFound))
       */
        if ([[self.detailItem valueForKey:@"longNotes"] length] > 0)
            [self.activityComments setText:[[NSString alloc] initWithFormat:@"%@ %@",self.activityComments.text, [self.detailItem valueForKey:@"longNotes"]]];
        if ([self.detailItem valueForKey:@"dueDate"] != NULL){
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateStyle:NSDateFormatterShortStyle];
            [df setTimeStyle:NSDateFormatterNoStyle];
            
            NSString *fourDigitYearFormat = [[df dateFormat]
                                             stringByReplacingOccurrencesOfString:@"yy"
                                             withString:@"yyyy"];
            [df setDateFormat:fourDigitYearFormat];

            [self.activityDueDate setText:[[NSString alloc] initWithFormat:@"Complete By: %@",[df stringFromDate:[self.detailItem valueForKey:@"dueDate"]]]];
        }
        self.activityStatus = [[NSString alloc] initWithFormat:@"%@",[self.detailItem valueForKey:@"status"]];
        self.completedComment = [[NSString alloc] initWithFormat:@"%@",[self.detailItem valueForKey:@"comments"]];    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)viewDidUnload
{
    [self setActivityDueDate:nil];
    [self setActivityDescType:nil];
    [self setActivityComments:nil];
    [self setEntityName:nil];
    [self setActId:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Table view delegate

- (IBAction)doneCheckIn:(id)sender {
    NSString *errorMsg = @"";
    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userName = [userDef stringForKey:@"userId"];
        
        self.activityStatus = @"Done";
        
        NSManagedObjectContext *context = [self.detailItem managedObjectContext];

        NSString *strComment = [[NSString alloc] initWithFormat:@"Completed by %@\n%@", userName,[self.detailItem valueForKey:@"comments"]];
        strComment  = (strComment.length > 255) ? [strComment substringToIndex:20] : strComment;
        
        if ([[self.detailItem valueForKey:@"comments"] description] != NULL && [[[self.detailItem valueForKey:@"comments"] description] length] > 0)
            [self.detailItem setValue:strComment forKey:@"comments"];
        [self.detailItem setValue:self.activityStatus forKey:@"status"];
        
        if ([self.activityStatus isEqualToString:@"Done"]) {
            NSDate *now = [NSDate date];
            [self.detailItem setValue:now forKey:@"actionDate"];
        }
        if ([self.detailItem valueForKey:@"contactId"] != NULL)
        {
            NSEntityDescription *providerEntity = [NSEntityDescription entityForName:@"Providers" inManagedObjectContext:context];
            NSFetchRequest *fr = [[NSFetchRequest alloc] init];
            [fr setEntity:providerEntity];
            
            // Set example predicate and sort orderings..
            NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"contactId"]];
            [fr setPredicate:actionPredicate];
            
            NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
            [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
            
            // actions
            NSArray *providerArray = [context executeFetchRequest:fr error:nil];
            
            for (NSManagedObject *provider in providerArray)
            {
                [self.detailItem setValue:provider forKey:@"actionProvider"];
                [self setNextFollowUpProvider:provider];
            }
        }
        if ([self.detailItem valueForKey:@"officeId"] != NULL)
        {
            NSEntityDescription *officeEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:context];
            NSFetchRequest *fr = [[NSFetchRequest alloc] init];
            [fr setEntity:officeEntity];
            
            // Set example predicate and sort orderings..
            NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"officeId"]];
            [fr setPredicate:actionPredicate];
            
            NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
            [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
            
            NSArray *officeArray = [context executeFetchRequest:fr error:nil];
            
            for (NSManagedObject *office in officeArray)
            {
                [self.detailItem setValue:office forKey:@"actionOffice"];
                [self setNextFollowUpOffice:office];
            }
        }
        
        [self recordTransaction:self.detailItem];
        
        [context save:nil];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void) closeActivity {
    
    self.activityStatus = @"Done";
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDef stringForKey:@"userId"];
    
    NSString *strComment = [[NSString alloc] initWithFormat:@"Completed by %@\n%@", userName,[self.detailItem valueForKey:@"comments"]];
    strComment  = (strComment.length > 255) ? [strComment substringToIndex:20] : strComment;

    self.completedComment = strComment;
    NSManagedObjectContext *context = [self.detailItem managedObjectContext];
    
    [self.detailItem setValue:strComment forKey:@"comments"];
    [self.detailItem setValue:self.activityStatus forKey:@"status"];
    
    if ([self.activityStatus isEqualToString:@"Done"]) {
        NSDate *now = [NSDate date];
        [self.detailItem setValue:now forKey:@"actionDate"];
    }
    if ([self.detailItem valueForKey:@"contactId"] != NULL)
    {
        NSEntityDescription *providerEntity = [NSEntityDescription entityForName:@"Providers" inManagedObjectContext:context];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        [fr setEntity:providerEntity];
        
        // Set example predicate and sort orderings..
        NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"contactId"]];
        [fr setPredicate:actionPredicate];
        
        NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
        [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
        
        // actions
        NSArray *providerArray = [context executeFetchRequest:fr error:nil];
        
        for (NSManagedObject *provider in providerArray)
        {
            [self.detailItem setValue:provider forKey:@"actionProvider"];
            [self setNextFollowUpProvider:provider];
        }
    }
    if ([self.detailItem valueForKey:@"officeId"] != NULL)
    {
        NSEntityDescription *officeEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:context];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        [fr setEntity:officeEntity];
        
        // Set example predicate and sort orderings..
        NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"officeId"]];
        [fr setPredicate:actionPredicate];
        
        NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
        [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
        
        NSArray *officeArray = [context executeFetchRequest:fr error:nil];
        
        for (NSManagedObject *office in officeArray)
        {
            [self.detailItem setValue:office forKey:@"actionOffice"];
            [self setNextFollowUpOffice:office];
        }
    }
    
    [self recordTransaction:self.detailItem];
    
    [context save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) saveRecord {
    
    NSManagedObjectContext *context = [self.detailItem managedObjectContext];
    
    [self.detailItem setValue:self.completedComment forKey:@"comments"];
    //[self.detailItem setValue:self.activityStatus forKey:@"status"];
    /*
     if ([self.activityStatus isEqualToString:@"Done"]) {
     NSDate *now = [NSDate date];
     [self.detailItem setValue:now forKey:@"actionDate"];
     }
     */
    if ([self.detailItem valueForKey:@"contactId"] != NULL)
    {
        NSEntityDescription *providerEntity = [NSEntityDescription entityForName:@"Providers" inManagedObjectContext:context];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        [fr setEntity:providerEntity];
        
        // Set example predicate and sort orderings..
        NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"contactId"]];
        [fr setPredicate:actionPredicate];
        
        NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
        [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
        
        // actions
        NSArray *providerArray = [context executeFetchRequest:fr error:nil];
        
        for (NSManagedObject *provider in providerArray)
        {
            [self.detailItem setValue:provider forKey:@"actionProvider"];
            [self setNextFollowUpProvider:provider];
        }
    }
    if ([self.detailItem valueForKey:@"officeId"] != NULL)
    {
        NSEntityDescription *officeEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:context];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        [fr setEntity:officeEntity];
        
        // Set example predicate and sort orderings..
        NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"officeId"]];
        [fr setPredicate:actionPredicate];
        
        NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
        [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
        
        NSArray *officeArray = [context executeFetchRequest:fr error:nil];
        
        for (NSManagedObject *office in officeArray)
        {
            [self.detailItem setValue:office forKey:@"actionOffice"];
            [self setNextFollowUpOffice:office];
        }
    }
    [self recordTransaction:self.detailItem];
    
    [context save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)saveCheckIn:(id)sender {
    NSString *errorMsg = @"";
    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        self.missingComment = @"Y";
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Close Activity" message:@"Do you want to close this activity?"  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];    
        self.missingComment = @"N";
        [alert show];
    }
}


- (void)recordTransaction:(NSManagedObject *) obj {
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
    [newTransaction setValue:@"Update" forKey:@"transactionType"];
    
    [clm stopUpdatingLocation];
    
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    
    //[context save:nil];
}


- (void)setNextFollowUpOffice:(NSManagedObject *) office {
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
        NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(descriptionType != 'Note from RM' || descriptionType = nil) && (dueDate != NULL) && (officeId = %@) && (status = 'Open')", [office valueForKey:@"rowId"]];

        [fr setPredicate:actionPredicate];
        [fr setSortDescriptors:[NSArray arrayWithObject:actionSortDescriptor]];
        
        NSArray *actionArray = [moc executeFetchRequest:fr error:nil];
        
        if ([actionArray count] > 0) {
            [office setValue:[[actionArray objectAtIndex:0] valueForKey:@"dueDate"] forKey:@"nextFUDate"];
        }
        else {
            [office setValue:nil forKey:@"nextFUDate"];
        }
    }
}
- (void)setNextFollowUpProvider:(NSManagedObject *) provider {
    NSManagedObjectContext *moc = [provider managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSEntityDescription *assetEntity = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
    NSSortDescriptor *assetSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"expirationDate" ascending:YES];
    
    NSEntityDescription *actionEntity = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];
    NSSortDescriptor *actionSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    
    NSDate *today = [NSDate date];
    
    // asset first
    [fr setEntity:assetEntity];
    
    NSPredicate *assetPredicate = [NSPredicate predicateWithFormat: @"(assignedContactId = %@) && (expirationDate <= %@) && (status != %@)", [provider valueForKey:@"rowId"],today,@"Inactive/Lost"];
    
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
        else {
            [provider setValue:nil forKey:@"nextFUDate"];
        }
    }    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (![self.missingComment isEqualToString:@"Y"])
    {
        if (buttonIndex == 1)
            [self closeActivity];
        else
            [self.navigationController popViewControllerAnimated:YES];
        
    }
}



@end
