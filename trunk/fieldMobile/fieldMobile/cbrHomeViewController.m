//
//  cbrHomeViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "cbrAppDelegate.h"
#import "cbrHomeViewController.h"
#import "cbrOpportunityViewController.h"
#import "cbrInventoryViewController.h"
#import "cbrHomeSettingsViewController.h"
#import "cbrHospitalViewController.h"
#import "cbrProviderViewController.h"
#import "FUP.h"
#import "asl.h"
#import "Reachability.h"

#import "cbrSendActivityTransactionOperation.h"
#import "cbrSendProviderTransactionOperation.h"
#import "cbrSendHospitalTransactionOperation.h"
#import "cbrSendContactTransactionOperation.h"
#import "cbrSendKitTransactionOperation.h"
#import "cbrSendOrderTransactionOperation.h"
#import "cbrLoadActivityOperation.h"
#import "cbrLoadContactOperation.h"
#import "cbrLoadHospitalOperation.h"
#import "cbrLoadKitOperation.h"
#import "cbrLoadProviderOperation.h"
#import "cbrLoadStatOperation.h"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define WCF_TIMEOUT 900.0

@interface cbrHomeViewController()
@end

@implementation cbrHomeViewController

@synthesize managedObjectContext = _managedObjectContext;
//@synthesize adManagedObjectContext = _adManagedObjectContext;//UPDATED***
@synthesize appObject = _appObject;
@synthesize authenticationToken = _authenticationToken;
@synthesize openActivitiesCell = _openActivitiesCell;
@synthesize kitsCell = _kitsCell;
@synthesize errorReason = _errorReason;
@synthesize syncNumProviders = _syncNumProviders;
@synthesize syncButton = _syncButton;
@synthesize unusableKitsCell = _unusableKitsCell;
@synthesize heroCell = _heroCell;
@synthesize syncNextFUP = _syncNextFUP;
@synthesize navBar = _navBar;
@synthesize syncCell = _syncCell;
@synthesize reachability = _reachability;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.managedObjectContext == nil)
    {
    /*
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        NSPersistentStoreCoordinator *coordinator = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator];
        [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
        [self.managedObjectContext setUndoManager:nil];
    */
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
    }
    //UPDATED***
    /*
    if (self.adManagedObjectContext == nil) 
    {
        self.adManagedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
     */
    // Register context with the notification center
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
           selector:@selector(mergeChanges:)
               name:NSManagedObjectContextDidSaveNotification
             object:nil];
    
    //set the navigation bar color to purple
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed: 64/255.0 green:18/255.0 blue:128/255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewDidUnload {
    [self setOpenActivitiesCell:nil];
    [self setKitsCell:nil];
    [self setSyncButton:nil];
    [self setUnusableKitsCell:nil];
    [self setHeroCell:nil];
    [self setSyncCell:nil];
    [self setACDvsTotal:nil];
    [self setNewEnrollments:nil];
    [self setEducated:nil];
    [self setCTCB_Ratio:nil];
    [self setTotal_Enrollments:nil];
    [self setTotalOpptys:nil];
    [self setTotalCBStorages:nil];
    [self setTotalCTStorages:nil];
    [self setLastSyncDate:nil];
    [super viewDidUnload];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    if ([[segue identifier] isEqualToString:@"seeOpty"]) { 
        cbrOpportunityViewController *addController = (cbrOpportunityViewController *)[segue destinationViewController];
        addController.managedObjectContext = self.managedObjectContext; //UPDATED***
    }

    if ([[segue identifier] isEqualToString:@"myKits"]) {
        cbrInventoryViewController *kitController = (cbrInventoryViewController *)[segue destinationViewController];
        kitController.managedObjectContext = self.managedObjectContext;//UPDATED***
        NSManagedObjectContext *moc = self.managedObjectContext;//UPDATED***
        
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        [fr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc]];
        if ([[userDef stringForKey:@"rmStorageId"] length] > 0)
            [fr setPredicate:[NSPredicate predicateWithFormat: @"(rowId = %@)", [userDef stringForKey:@"rmStorageId"]]];
        else
            [fr setPredicate:[NSPredicate predicateWithFormat: @"(rowId = %@)", @"NULL"]];
        
        NSArray *officeArray = [moc executeFetchRequest:fr error:nil];
        
        if ([officeArray count] >= 1) {
            // pass primary storage object
            kitController.detailItem = [officeArray objectAtIndex:0];
        }

        
    }
    if ([[segue identifier] isEqualToString:@"mySettings"]) {
        cbrHomeSettingsViewController *settingsController = (cbrHomeSettingsViewController *)[segue destinationViewController];
        //settingsController.appObject = self.appObject;
        settingsController.managedObjectContext = self.managedObjectContext;//UPDATED***
    }
    if ([[segue identifier] isEqualToString:@"unusableKits"]) {
        cbrInventoryViewController *inventoryView = (cbrInventoryViewController *)[segue destinationViewController];
        inventoryView.managedObjectContext = self.managedObjectContext;//UPDATED***
    }
 }
- (void)configureView {
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleName"];
    self.navBar.title = [[NSString alloc] initWithFormat:@"%@", bundleName];
    
    if ([userDef stringForKey:@"userId"] == nil ||[userDef stringForKey:@"userId"].length == 0 || [[userDef stringForKey:@"userId"] isEqualToString:@""])
    {
        [self performSelectorOnMainThread:@selector(authUser) withObject:nil waitUntilDone:YES];
    }
    UIColor *cbrRed = [UIColor colorWithRed:155/255.0 green:0/255.0 blue:46/255.0 alpha:1];
    UIColor *cbrPurple = [UIColor colorWithRed:110/255.0 green:98/255.0 blue:174/255.0 alpha:1];
    
    NSInteger openActivities = [self countOpenActivities];
    NSMutableDictionary *kitCounts = [self countExpiredKits];
    NSInteger expiredKits = [[kitCounts valueForKey:@"unusableKits"] integerValue];
    NSInteger myExpiredKits = [[kitCounts valueForKey:@"myKits"] integerValue];
    NSInteger pendingTransaction = [self countPendingTransactions];
    if (openActivities > 0) {
        [[self.openActivitiesCell detailTextLabel] setText:[NSString stringWithFormat:@"%d",openActivities]];
        [[self.openActivitiesCell textLabel] setTextColor:cbrRed];
        [[self.openActivitiesCell detailTextLabel] setTextColor:cbrRed];
        [self.openActivitiesCell setNeedsLayout];
    }
    else {
        [[self.openActivitiesCell detailTextLabel] setText:[NSString stringWithFormat:@""]];
        [[self.openActivitiesCell textLabel] setTextColor:cbrPurple];
        [[self.openActivitiesCell detailTextLabel] setTextColor:cbrPurple];
    }
    if (expiredKits > 0) {
        [[self.unusableKitsCell detailTextLabel] setText:[NSString stringWithFormat:@"%d",expiredKits]];
        [[self.unusableKitsCell textLabel] setTextColor:cbrRed];
        [[self.unusableKitsCell detailTextLabel] setTextColor:cbrRed];
        [self.unusableKitsCell setNeedsLayout];
    }
    else {
        [[self.unusableKitsCell detailTextLabel] setText:[NSString stringWithFormat:@""]];
        [[self.unusableKitsCell textLabel] setTextColor:cbrPurple];
        [[self.unusableKitsCell detailTextLabel] setTextColor:cbrPurple];
    }
    if (myExpiredKits > 0) {
        [[self.kitsCell detailTextLabel] setText:[NSString stringWithFormat:@"%d",myExpiredKits]];
        [[self.kitsCell textLabel] setTextColor:cbrRed];
        [[self.kitsCell detailTextLabel] setTextColor:cbrRed];
        [self.kitsCell setNeedsLayout];
    }
    else {
        [[self.kitsCell detailTextLabel] setText:[NSString stringWithFormat:@""]];
        [[self.kitsCell textLabel] setTextColor:cbrPurple];
        [[self.kitsCell detailTextLabel] setTextColor:cbrPurple];
    }
    
    [[self.syncCell detailTextLabel] setText:[NSString stringWithFormat:@"%d",pendingTransaction]];
    [self.syncCell setNeedsLayout];
    // this controls the number that appears on the app's icon.
    [UIApplication sharedApplication].applicationIconBadgeNumber = expiredKits + openActivities;
    
    [[self syncButton] setTitle:[NSString stringWithFormat:@"Sync (%d)",pendingTransaction]];
    //Sales Metrics on home view
    self.ACDvsTotal.text = [NSString stringWithFormat:@"ACD/Total Opptys:  %@%%", [userDef stringForKey:@"rmACD_Oppty_Pct"]];
    self.ACDvsTotal.textColor = cbrPurple;
    self.NewEnrollments.text = [NSString stringWithFormat:@"New Enrollments:  %@%%", [userDef stringForKey:@"rmNew_Enroll_Pct"]];
    self.NewEnrollments.textColor = cbrPurple;
    self.Educated.text = [NSString stringWithFormat:@"Educated: %@ (%@%%)", [userDef stringForKey:@"rmEducated"], [userDef stringForKey:@"rmEducated_Pct"]];
    self.Educated.textColor = cbrPurple;
    self.CTCB_Ratio.text = [NSString stringWithFormat:@"CT/CB Ratio:  %@%%", [userDef stringForKey:@"rmCB_CT_Ratio"]];
    self.CTCB_Ratio.textColor = cbrPurple;
    self.TotalOpptys.text = [NSString stringWithFormat:@"Total Opptys:  %@", [userDef stringForKey:@"rmTotal_Optys"]];
    self.TotalOpptys.textColor = cbrPurple;
    self.Total_Enrollments.text = [NSString stringWithFormat:@"Total Enrollments:  %@", [userDef stringForKey:@"rmTotal_Enroll"]];
    self.Total_Enrollments.textColor = cbrPurple;
    self.TotalCTStorages.text = [NSString stringWithFormat:@"Total CT Storages:  %@", [userDef stringForKey:@"rmTotal_CT"]];
    self.TotalCTStorages.textColor = cbrPurple;
    self.TotalCBStorages.text = [NSString stringWithFormat:@"Total CB Storages:  %@", [userDef stringForKey:@"rmTotal_CB"]];
    self.TotalCBStorages.textColor = cbrPurple;
    
    self.LastSyncDate.text = [NSString stringWithFormat:@"Last Successful Sync:  %@", [userDef stringForKey:@"rmLastSyncDate"]];
    self.LastSyncDate.textColor = cbrPurple;
    
    [self sendBugsIfPresent];
}

-(void) updatePendingCount
{
    NSInteger pendingTransaction = [self countPendingTransactions];
    [[self.syncCell detailTextLabel] setText:[NSString stringWithFormat:@"%d",pendingTransaction]];
    [self.syncCell setNeedsLayout];
    
    [[self syncButton] setTitle:[NSString stringWithFormat:@"Sync TEST (%d)",pendingTransaction]];
}

- (void)sendBugsIfPresent
{
	NSError *err;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dir = [paths objectAtIndex:0];
	NSString *path =  [dir stringByAppendingPathComponent:@"bug.txt"];

	
	NSString *GBug = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	if (GBug == nil) return;
	[[NSFileManager defaultManager] removeItemAtPath:path error:&err];
	
    [self sendEmail:@"Exception from Futures" body:GBug];
    }


- (NSInteger)countOpenActivities {
    NSManagedObjectContext *moc = self.managedObjectContext;//UPDATED***
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *actionEntity = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];
    
    [fr setEntity:actionEntity];
    
    NSPredicate *statusPredicate = [NSPredicate predicateWithFormat:@"(status = %@ && (descriptionType != %@ || descriptionType = nil))", @"Open", @"Note from RM"];
    
    [fr setPredicate:statusPredicate];
    
    NSArray *actionArray = [moc executeFetchRequest:fr error:nil];
    
    return [actionArray count];
}
- (NSMutableDictionary *)countExpiredKits {
    //NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];    
    //NSString *userStorageId = [userDef stringForKey:@"rmStorageId"];
    
    NSMutableDictionary *kitCounts = [[NSMutableDictionary alloc] init];
    NSManagedObjectContext *moc = self.managedObjectContext;//UPDATED***
    
    NSDate *today = [NSDate date];
    int daysToAdd = 180;  
    NSDate *agingDate = [today dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
/*    
    [fr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc]];
    [fr setPredicate:[NSPredicate predicateWithFormat: @"(officeType = %@)", @"RM Dropoff Location"]];
    //[fr setPredicate:[NSPredicate predicateWithFormat: @"(rowId = %@)", userStorageId]];

    
    NSArray *officeArray = [moc executeFetchRequest:fr error:nil];
    
    if ([officeArray count] >= 1) {
        [fr setEntity:[NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc]];
        [fr setPredicate:[NSPredicate predicateWithFormat: @"(expirationDate == NULL || expirationDate <= %@) && assignedOfficeId = %@",agingDate,[[officeArray objectAtIndex:0] valueForKey:@"rowId"]]];
        
        NSArray *myKits = [moc executeFetchRequest:fr error:nil];
        
        [kitCounts setValue:[NSNumber numberWithInt:[myKits count]] forKey:@"myKits"];
    }
  */
    [fr setEntity:[NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc]];
    //[fr setPredicate:[NSPredicate predicateWithFormat: @"(expirationDate == NULL || expirationDate <= %@) && assignedOfficeId = %@",agingDate,userStorageId]];
    
    // show all rm locations
    NSFetchRequest *frr = [[NSFetchRequest alloc] init];
    [frr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:self.managedObjectContext]];
    [frr setPredicate:[NSPredicate predicateWithFormat:@"officeType =%@",@"RM Dropoff Location"]];
    NSArray *rmOfficeArray = [self.managedObjectContext executeFetchRequest:frr error:nil];//UPDATED***
    NSString *relationship = @"";
    for (NSManagedObject *item in rmOfficeArray)
    {
        if ([relationship isEqualToString:@""]) {
            relationship = [NSString stringWithFormat:@"assignedOfficeId == '%@'",[item valueForKey:@"rowId"]];
        }
        else {
            relationship = [NSString stringWithFormat:@"%@ || assignedOfficeId == '%@'",relationship, [item valueForKey:@"rowId"]];
        }
    }
    if ([rmOfficeArray count] > 0) {
        relationship = [NSString stringWithFormat:@"(%@)",relationship];
        [fr setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:[NSPredicate predicateWithFormat:relationship],[NSPredicate predicateWithFormat: @"(expirationDate == NULL || expirationDate <= %@) && (status != %@ || status == nil)",agingDate,@"Inactive/Lost"],nil]]];
        // end show all rm locations
        
        NSArray *myKits = [moc executeFetchRequest:fr error:nil];
        
        [kitCounts setValue:[NSNumber numberWithInt:[myKits count]] forKey:@"myKits"];
        
        [fr setEntity:[NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc]];
        [fr setPredicate:[NSPredicate predicateWithFormat: @"(expirationDate == NULL || expirationDate <= %@) && (status != %@ || status == nil)",agingDate,@"Inactive/Lost"]];
        
        NSArray *unusableKits = [moc executeFetchRequest:fr error:nil];
        
        [kitCounts setValue:[NSNumber numberWithInt:[unusableKits count]] forKey:@"unusableKits"];
    }
    else {
        [kitCounts setValue:[NSNumber numberWithInt:0] forKey:@"unusableKits"];
    }
    
    return kitCounts;
}
- (int)countPendingTransactions {
    NSManagedObjectContext *moc = self.managedObjectContext;//UPDATED***
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:[NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:moc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(status = nil)"];
    [fr setPredicate:predicate];
    
    NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
    return [resultsArray count];
}

#pragma mark - CBR Synchronization Methods
- (IBAction)synchronizeApp:(id)sender {
    
    // initiate background process: allows user to navigate away from app while sync is occurring
    /*
     syncTask = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        // If you’re worried about exceeding 10 minutes, handle it here
    }];
    */
    
    // Check network
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    self.reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
    //self.reachability = [Reachability reachabilityForInternetConnection];
	[self.reachability startNotifier];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Synchronizing";
    HUD.detailsLabelText = @"please be patient";
	HUD.dimBackground = YES;
    HUD.square = YES;
    self.authenticationToken = @"";
    if ([self isConnectionAvailable])
    {
        //[self performSelectorOnMainThread:@selector(showHUD) withObject:nil waitUntilDone:NO];
        //[HUD showWhileExecuting:@selector(synchronizeData) onTarget:self withObject:nil animated:YES];
        [HUD show:YES];
        [self synchronizeDataOperation];
        //[HUD showWhileExecuting:@selector(synchronizeDataOperation) onTarget:self withObject:nil animated:YES];
        
        
    }
     else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A network connection was not detected."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

- (void) synchronizeDataAlertOnMainThread
{
    [self configureView];
	HUD.dimBackground = NO;
    [HUD hide:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [self.view setUserInteractionEnabled:YES];
    for(UITabBarItem *item in [[self.tabBarController tabBar] items])
        item.enabled = true;

    if (([self.authenticationToken isEqualToString:@"error"]) ||
        ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A problem occurred during the sync.  Please try again."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSInteger pendingTransaction = [self countPendingTransactions];
        [[self syncButton] setTitle:[NSString stringWithFormat:@"Sync (%d)",pendingTransaction]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Sync is Complete"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Status"];
    @try
    {
        [operationQueue removeObserver:self forKeyPath:@"operations"];        
        [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kReachabilityChangedNotification];
    }
    @catch (id Exception)
    {
    }
}

- (void)synchronizeDataOperation
{
    //[[self syncButton] setTitle:[NSString stringWithFormat:@"Syncing.."]];
    HUD.detailsLabelText = @"Authenticating";
    
    // disable the UI
    for(UITabBarItem *item in [[self.tabBarController tabBar] items])
        item.enabled = false;
    [self.view setUserInteractionEnabled:NO];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // establish filenames for temp storage
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filenamePath = [NSString stringWithString:[filePaths objectAtIndex:0]];
    NSString *filenamePathProviders = [filenamePath stringByAppendingString:@"/providers.json"];
    NSString *filenamePathFacilities = [filenamePath stringByAppendingString:@"/facilities.json"];
    NSString *filenamePathProviderStats = [filenamePath stringByAppendingString:@"/providerStats.json"];
    NSString *filenamePathFacilityStats = [filenamePath stringByAppendingString:@"/facilityStats.json"];
    NSString *filenamePathContacts = [filenamePath stringByAppendingString:@"/contacts.json"];
    NSString *filenamePathActivities =[filenamePath stringByAppendingString:@"/activities.json"];
    NSString *filenamePathKits = [filenamePath stringByAppendingString:@"/kits.json"];
    
    
    operationQueue = [NSOperationQueue new];
    
    NSInvocationOperation *authOp = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(renewUser)
                                        object:nil];
    [operationQueue addOperation:authOp];

    
        // PUSH UPDATES TO SIEBEL
        if (![self.authenticationToken isEqualToString:@"error"])
        {

        [operationQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];

        
        NSInvocationOperation *loadRMOp = [[NSInvocationOperation alloc]
                                         initWithTarget:self
                                         selector:@selector(loadRMData)
                                         object:nil];
        [loadRMOp addDependency:authOp];
        [operationQueue addOperation:loadRMOp];

        NSInvocationOperation *loadSalesMetricsOp = [[NSInvocationOperation alloc]
                                           initWithTarget:self
                                           selector:@selector(loadSalesMetrics)
                                           object:nil];
        [loadSalesMetricsOp addDependency:authOp];
        [operationQueue addOperation:loadSalesMetricsOp];
        

            //HUD.detailsLabelText = @"Sending Providers";
            cbrSendProviderTransactionOperation *pushProvidersOp = [[cbrSendProviderTransactionOperation alloc]initWithDescription:@"Sending Providers"];
            [pushProvidersOp addDependency:authOp];
            [operationQueue addOperation:pushProvidersOp];
            //[self pushProviders];
            
            // PUSH CONTACTS (new / edit)
            //HUD.detailsLabelText = @"Sending Contacts";
            cbrSendContactTransactionOperation  *pushContactsOp = [[cbrSendContactTransactionOperation alloc]initWithDescription:@"Sending Contacts"];
            [pushContactsOp addDependency:authOp];
            [operationQueue addOperation:pushContactsOp];
            //[self pushOfficeContacts];
            
            // push Hospitals (new / edit)
            HUD.detailsLabelText = @"Sending Hospitals";
            cbrSendHospitalTransactionOperation  *pushHospitalsOp = [[cbrSendHospitalTransactionOperation alloc]initWithDescription:@"Sending Hospitals"];
            [pushHospitalsOp addDependency:authOp];
            [pushHospitalsOp addDependency:pushContactsOp];
            [operationQueue addOperation:pushHospitalsOp];
            //[self pushOffices];
            
            
            // push Actions (new / edit)
            //HUD.detailsLabelText = @"Sending Activities";
            cbrSendActivityTransactionOperation  *pushActivitiesOp = [[cbrSendActivityTransactionOperation alloc]initWithDescription:@"Sending Activities"];
            [pushActivitiesOp addDependency:authOp];
            [pushActivitiesOp addDependency:pushProvidersOp];
            [pushActivitiesOp addDependency:pushHospitalsOp];
            [operationQueue addOperation:pushActivitiesOp];
            //[self pushActivities];
            
            // push Kit Transactions (new)
            //HUD.detailsLabelText = @"Sending Kits";
            cbrSendKitTransactionOperation  *pushKitsOp = [[cbrSendKitTransactionOperation alloc]initWithDescription:@"Sending Kits"];
            [pushKitsOp addDependency:authOp];
            [pushKitsOp addDependency:pushProvidersOp];
            [pushKitsOp addDependency:pushHospitalsOp];
            [operationQueue addOperation:pushKitsOp];
            //[self pushKits];
            
            // push Orders (new)
            //HUD.detailsLabelText = @"Sending Orders";
            cbrSendOrderTransactionOperation *pushOrdersOp = [[cbrSendOrderTransactionOperation alloc]initWithDescription:@"Sending Orders"];
            [pushOrdersOp addDependency:authOp];
            [pushOrdersOp addDependency:pushHospitalsOp];
            [operationQueue addOperation:pushOrdersOp];
            //[self pushOrders];
             

            //Providers            
            NSInvocationOperation *getProvidersOp = [[NSInvocationOperation alloc]
                                               initWithTarget:self
                                                     selector:@selector(getProviders:)
                                                     object: filenamePathProviders];
            [getProvidersOp addDependency:authOp];
            [getProvidersOp addDependency:loadRMOp];
            [getProvidersOp addDependency:pushProvidersOp];
            [getProvidersOp addDependency:pushHospitalsOp];
            [getProvidersOp addDependency:pushActivitiesOp];
            [getProvidersOp addDependency:pushContactsOp];
            [getProvidersOp addDependency:pushKitsOp];
            [getProvidersOp addDependency:pushOrdersOp];
            [operationQueue addOperation:getProvidersOp];
            
            
            //Provider Stats
            NSInvocationOperation *getProviderStatOp = [[NSInvocationOperation alloc]
                                                     initWithTarget:self
                                                     selector:@selector(getProvidersStat:)
                                                     object: filenamePathProviderStats];
            [getProviderStatOp addDependency:authOp];
            [getProviderStatOp addDependency:loadRMOp];
            [getProviderStatOp addDependency:pushProvidersOp];
            [getProviderStatOp addDependency:pushHospitalsOp];
            [getProviderStatOp addDependency:pushActivitiesOp];
            [getProviderStatOp addDependency:pushContactsOp];
            [getProviderStatOp addDependency:pushKitsOp];
            [getProviderStatOp addDependency:pushOrdersOp];
            [getProviderStatOp addDependency:getProvidersOp];        
            [operationQueue addOperation:getProviderStatOp];

            
            //Hospital
            NSInvocationOperation *getHospitalsOp = [[NSInvocationOperation alloc]
                                                     initWithTarget:self
                                                     selector:@selector(getHospitals:)
                                                     object: filenamePathFacilities];
            [getHospitalsOp addDependency:authOp];
            [getHospitalsOp addDependency:loadRMOp];
            [getHospitalsOp addDependency:pushProvidersOp];
            [getHospitalsOp addDependency:pushHospitalsOp];
            [getHospitalsOp addDependency:pushActivitiesOp];
            [getHospitalsOp addDependency:pushContactsOp];
            [getHospitalsOp addDependency:pushKitsOp];
            [getHospitalsOp addDependency:pushOrdersOp];
            [operationQueue addOperation:getHospitalsOp];
            
            //Hospital Stats            
            NSInvocationOperation *getHospitalStatOp = [[NSInvocationOperation alloc]
                                                     initWithTarget:self
                                                        selector:@selector(getHospitalsStat:)
                                                     object: filenamePathFacilityStats];
            [getHospitalStatOp addDependency:authOp];
            [getHospitalStatOp addDependency:loadRMOp];
            [getHospitalStatOp addDependency:pushHospitalsOp];
            [getHospitalStatOp addDependency:pushProvidersOp];
            [getHospitalStatOp addDependency:pushHospitalsOp];
            [getHospitalStatOp addDependency:pushActivitiesOp];
            [getHospitalStatOp addDependency:pushContactsOp];
            [getHospitalStatOp addDependency:pushKitsOp];
            [getHospitalStatOp addDependency:pushOrdersOp];
            [getHospitalStatOp addDependency:getHospitalsOp];
            [operationQueue addOperation:getHospitalStatOp];
            
            //Contacts
            NSInvocationOperation *getContactsOp = [[NSInvocationOperation alloc]
                                                        initWithTarget:self
                                                        selector:@selector(getContacts:)
                                                        object: filenamePathContacts];
            [getContactsOp addDependency:authOp];
            [getContactsOp addDependency:loadRMOp];
            [getContactsOp addDependency:pushHospitalsOp];
            [getContactsOp addDependency:pushProvidersOp];
            [getContactsOp addDependency:pushHospitalsOp];
            [getContactsOp addDependency:pushActivitiesOp];
            [getContactsOp addDependency:pushContactsOp];
            [getContactsOp addDependency:pushKitsOp];
            [getContactsOp addDependency:pushOrdersOp];
            [operationQueue addOperation:getContactsOp];

            //Activities
            NSInvocationOperation *getActivitiesOp = [[NSInvocationOperation alloc]
                                                        initWithTarget:self
                                                        selector:@selector(getActivities:)
                                                        object: filenamePathActivities];
            [getActivitiesOp addDependency:authOp];
            [getActivitiesOp addDependency:loadRMOp];
            [getActivitiesOp addDependency:pushHospitalsOp];
            [getActivitiesOp addDependency:pushProvidersOp];
            [getActivitiesOp addDependency:pushHospitalsOp];
            [getActivitiesOp addDependency:pushActivitiesOp];
            [getActivitiesOp addDependency:pushContactsOp];
            [getActivitiesOp addDependency:pushKitsOp];
            [getActivitiesOp addDependency:pushOrdersOp];
            [operationQueue addOperation:getActivitiesOp];
            
            //Kits
            NSInvocationOperation *getKitsOp = [[NSInvocationOperation alloc]
                                                        initWithTarget:self
                                                        selector:@selector(getKits:)
                                                        object: filenamePathKits];
            [getKitsOp addDependency:authOp];
            [getKitsOp addDependency:loadRMOp];
            [getKitsOp addDependency:pushHospitalsOp];
            [getKitsOp addDependency:pushProvidersOp];
            [getKitsOp addDependency:pushHospitalsOp];
            [getKitsOp addDependency:pushActivitiesOp];
            [getKitsOp addDependency:pushContactsOp];
            [getKitsOp addDependency:pushKitsOp];
            [getKitsOp addDependency:pushOrdersOp];
            [operationQueue addOperation:getKitsOp];
            
        }
    
}
- (void) processData
{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];

    
   if ([fullSyncFlag isEqualToString:@"Y"])
       [self resetCoreData];
 
    [self getClaims:[[NSString stringWithString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]] stringByAppendingString:@"/claims.json"]];
    // REFRESH CORE DATA
    NSLog(@"Refreshing Database");
    HUD.detailsLabelText = @"Refreshing Database";
    self.syncNextFUP = [[NSMutableArray alloc] init];
    
    // PROCESS DATA GOTTEN FROM SIEBEL
    HUD.detailsLabelText = @"Loading Kits";
    cbrLoadKitOperation *loadAssetOp = [[cbrLoadKitOperation alloc]init];
    [operationQueue addOperation:loadAssetOp];
    [loadAssetOp setCompletionBlock: ^{
        HUD.detailsLabelText = @"Loading Activities";
    }];
    
    
    
    //NSLog(@"%@",[HUD.detailsLabelText description]);
    cbrLoadActivityOperation *loadActivityOp = [[cbrLoadActivityOperation alloc]init];
    [loadActivityOp addDependency:loadAssetOp];
    [operationQueue addOperation:loadActivityOp];
    [loadActivityOp setCompletionBlock: ^{
        HUD.detailsLabelText = @"Loading Contacts";
    }];
    
    
    
    //NSLog(@"%@",[HUD.detailsLabelText description]);
    cbrLoadContactOperation *loadContactOp = [[cbrLoadContactOperation alloc]init];
    [loadContactOp addDependency:loadActivityOp];
    [operationQueue addOperation:loadContactOp];
    [loadContactOp setCompletionBlock: ^{
        HUD.detailsLabelText = @"Loading Hospitals";
    }];
    
    //NSLog(@"%@",[HUD.detailsLabelText description]);
    cbrLoadHospitalOperation *loadHospitalOp = [[cbrLoadHospitalOperation alloc]init];
    [loadHospitalOp addDependency:loadContactOp];
    [operationQueue addOperation:loadHospitalOp];
    [loadHospitalOp setCompletionBlock: ^{
        HUD.detailsLabelText = @"Loading Providers";
    }];
    
    
    //NSLog(@"%@",[HUD.detailsLabelText description]);
    cbrLoadProviderOperation *loadProviderOp = [[cbrLoadProviderOperation alloc]init];
    [loadProviderOp addDependency:loadHospitalOp];
    [operationQueue addOperation:loadProviderOp];
    [loadProviderOp setCompletionBlock: ^{
        HUD.detailsLabelText = @"Processing Data";
    }];
    
    
    //NSLog(@"%@",[HUD.detailsLabelText description]);
    //load FUP
    cbrLoadStatOperation *loadStatOp = [[cbrLoadStatOperation alloc]init];
    [loadStatOp addDependency:loadProviderOp];
    [operationQueue addOperation:loadStatOp];
    
    
    [loadStatOp setCompletionBlock: ^{
        //resetFullSyncFlag
        if(![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
        {
            NSLog(@"resetFullSyncFlag");
            [self resetFullSyncFlag];
        }
        HUD.detailsLabelText = @"Sync is Complete";
        
        [self endSync:nil];
        
        //[self performSelectorOnMainThread:@selector(cleanupFiles) withObject:nil waitUntilDone:YES];
        
        self.syncNextFUP = nil;
        //[self performSelectorOnMainThread:@selector(configureView) withObject:nil waitUntilDone:YES];
        //[self configureView];
        
        NSArray *nControllers = [self.tabBarController viewControllers];
        for (id nav in nControllers) {
            UINavigationController *navController = (UINavigationController *)nav;
            NSArray *vController = [navController viewControllers];
            for (id view in vController) {
                if ([view isKindOfClass:[cbrHospitalViewController class]]) {
                    cbrHospitalViewController *hospView = (cbrHospitalViewController *)view;
                    hospView.managedObjectContext = self.managedObjectContext;//UPDATED***
                    hospView.fetchedResultsController = nil;
                    [hospView.tableView reloadData];
                    [hospView.navigationController popToRootViewControllerAnimated:YES];
                }
                if ([view isKindOfClass:[cbrProviderViewController class]]) {
                    cbrProviderViewController *provView = (cbrProviderViewController *)view;
                    provView.managedObjectContext = self.managedObjectContext;//UPDATED***
                    provView.fetchedResultsController = nil;
                    [provView.tableView reloadData];
                    [provView.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self.view setUserInteractionEnabled:YES];
        for(UITabBarItem *item in [[self.tabBarController tabBar] items])
            item.enabled = true;
        //[self performSelectorOnMainThread:@selector(updatePendingCount) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(synchronizeDataAlertOnMainThread) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(cleanupFiles) withObject:nil waitUntilDone:YES];

    }];
}

- (void)cleanupFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filenamePath = [NSString stringWithString:[filePaths objectAtIndex:0]];
    NSString *filenamePathProviders = [filenamePath stringByAppendingString:@"/providers.json"];
    NSString *filenamePathFacilities = [filenamePath stringByAppendingString:@"/facilities.json"];
    NSString *filenamePathProviderStats = [filenamePath stringByAppendingString:@"/providerStats.json"];
    NSString *filenamePathFacilityStats = [filenamePath stringByAppendingString:@"/facilityStats.json"];
    NSString *filenamePathContacts = [filenamePath stringByAppendingString:@"/contacts.json"];
    NSString *filenamePathActivities =[filenamePath stringByAppendingString:@"/activities.json"];
    NSString *filenamePathKits = [filenamePath stringByAppendingString:@"/kits.json"];
    NSString *filenamePathClaims = [filenamePath stringByAppendingString:@"/claims.json"];
    NSError *error = nil;
    
    //cleanup
    [fileManager removeItemAtPath:filenamePathFacilities error:&error];
    if (error)
        NSLog(@"Error deleting Facility file: %@\n%@", [error localizedDescription], [error userInfo]);
    [fileManager removeItemAtPath:filenamePathActivities error:&error];
    if (error)
        NSLog(@"Error deleting Activity file: %@\n%@", [error localizedDescription], [error userInfo]);
    [fileManager removeItemAtPath:filenamePathContacts error:&error];
    if (error)
        NSLog(@"Error deleting Contact file: %@\n%@", [error localizedDescription], [error userInfo]);
    [fileManager removeItemAtPath:filenamePathKits error:&error];
    if (error)
        NSLog(@"Error deleting Kit file: %@\n%@", [error localizedDescription], [error userInfo]);
    [fileManager removeItemAtPath:filenamePathProviders error:&error];
    if (error)
        NSLog(@"Error deleting Provider file: %@\n%@", [error localizedDescription], [error userInfo]);
    [fileManager removeItemAtPath:filenamePathProviderStats error:&error];
    if (error)
        NSLog(@"Error deleting Provider Stat file: %@\n%@", [error localizedDescription], [error userInfo]);
    [fileManager removeItemAtPath:filenamePathFacilityStats error:&error];
    if (error)
        NSLog(@"Error deleting Facility Stat file: %@\n%@", [error localizedDescription], [error userInfo]);
    [fileManager removeItemAtPath:filenamePathClaims error:&error];
    if (error)
        NSLog(@"Error deleting Claims file: %@\n%@", [error localizedDescription], [error userInfo]);
    
}



-(void) getProviders:(NSString*)filename

{
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {
        NSLog(@"ENTER get Providers");

        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *strAuthorization = [userDef stringForKey:@"authorization"];
        NSString *userName = [userDef stringForKey:@"userId"];
        NSString *lastSync = [userDef stringForKey:@"rmLastSyncDate"];
        NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
        if ([lastSync isKindOfClass:[NSDate class]])
            NSLog(@"is a date");
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a z"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormat dateFromString:lastSync];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a"];
        NSString *formattedLastSync = [dateFormat stringFromDate:dateFromString];
        formattedLastSync = [NSString stringWithFormat:@"%@",CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)formattedLastSync, NULL, CFSTR("!$&'()*+,-./:;=?@_~"), kCFStringEncodingUTF8)];

        
        NSData *theRequest;
        NSMutableURLRequest *request;
        NSError *error = nil;
        NSHTTPURLResponse *httpResponse = nil;
        
        // establish filenames for temp storage
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandleWrite;

        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLProviderList"];
        NSString *temp;
        if ([fullSyncFlag isEqualToString:@"Y"] || ([lastSync length] == 0) || [lastSync isEqualToString:@"(null)"] )
            temp = [NSString stringWithFormat:@"ownerId=%@",userName];
        else
            temp = [NSString stringWithFormat:@"ownerId=%@&lastSyncDate=%@",userName,formattedLastSync];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",className,temp]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
        [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
        theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
        
        [fileManager createFileAtPath:filename contents: nil attributes:nil];
        fileHandleWrite = [NSFileHandle fileHandleForWritingAtPath:filename];
        [fileHandleWrite writeData:theRequest];
        [fileHandleWrite closeFile];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSLog(@"END get Providers");
    }
}


-(void) getProvidersStat:(NSString*)filename

{
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {    
        NSLog(@"ENTER get Providers Stat");
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *strAuthorization = [userDef stringForKey:@"authorization"];
        NSString *userName = [userDef stringForKey:@"userId"];
        NSString *lastSync = [userDef stringForKey:@"rmLastSyncDate"];
        //NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
        if ([lastSync isKindOfClass:[NSDate class]])
            NSLog(@"is a date");
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a z"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormat dateFromString:lastSync];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a"];
        NSString *formattedLastSync = [dateFormat stringFromDate:dateFromString];
        formattedLastSync = [NSString stringWithFormat:@"%@",CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)formattedLastSync, NULL, CFSTR("!$&'()*+,-./:;=?@_~"), kCFStringEncodingUTF8)];
        
        
        NSData *theRequest;
        NSMutableURLRequest *request;
        NSError *error = nil;
        NSHTTPURLResponse *httpResponse = nil;
        
        // establish filenames for temp storage
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandleWrite;
        
        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLProviderStatList"];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?ownerId=%@",className,userName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
        [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
        theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
        
        [fileManager createFileAtPath:filename contents: nil attributes:nil];
        fileHandleWrite = [NSFileHandle fileHandleForWritingAtPath:filename];
        [fileHandleWrite writeData:theRequest];
        [fileHandleWrite closeFile];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSLog(@"END get Providers Stat");
    }
}

-(void)getHospitals:(NSString*)filename

{
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {
        NSLog(@"ENTER get Hospitals");
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *strAuthorization = [userDef stringForKey:@"authorization"];
        NSString *userName = [userDef stringForKey:@"userId"];
        NSString *lastSync = [userDef stringForKey:@"rmLastSyncDate"];
        NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
        if ([lastSync isKindOfClass:[NSDate class]])
            NSLog(@"is a date");
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a z"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormat dateFromString:lastSync];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a"];
        NSString *formattedLastSync = [dateFormat stringFromDate:dateFromString];
        formattedLastSync = [NSString stringWithFormat:@"%@",CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)formattedLastSync, NULL, CFSTR("!$&'()*+,-./:;=?@_~"), kCFStringEncodingUTF8)];

        
        NSData *theRequest;
        NSMutableURLRequest *request;
        NSError *error = nil;
        NSHTTPURLResponse *httpResponse = nil;
        
        // establish filenames for temp storage
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandleWrite;

        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLFacilityList"];
        NSString *temp;
        if ([fullSyncFlag isEqualToString:@"Y"] || ([lastSync length] == 0) || [lastSync isEqualToString:@"(null)"] )
            temp = [NSString stringWithFormat:@"ownerId=%@",userName];
        else
            temp = [NSString stringWithFormat:@"ownerId=%@&lastSyncDate=%@",userName,formattedLastSync];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",className,temp]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
        [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
        theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
        
        [fileManager createFileAtPath:filename contents: nil attributes:nil];
        fileHandleWrite = [NSFileHandle fileHandleForWritingAtPath:filename];
        [fileHandleWrite writeData:theRequest];
        [fileHandleWrite closeFile];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSLog(@"END get Hospitals");
    }
}

-(void)getHospitalsStat:(NSString*)filename

{
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {
        NSLog(@"ENTER get Hospitals Stat");
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *strAuthorization = [userDef stringForKey:@"authorization"];
        NSString *userName = [userDef stringForKey:@"userId"];
        NSString *lastSync = [userDef stringForKey:@"rmLastSyncDate"];
        //NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
        if ([lastSync isKindOfClass:[NSDate class]])
            NSLog(@"is a date");
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a z"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormat dateFromString:lastSync];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a"];
        NSString *formattedLastSync = [dateFormat stringFromDate:dateFromString];
        formattedLastSync = [NSString stringWithFormat:@"%@",CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)formattedLastSync, NULL, CFSTR("!$&'()*+,-./:;=?@_~"), kCFStringEncodingUTF8)];
        
        NSData *theRequest;
        NSMutableURLRequest *request;
        NSError *error = nil;
        NSHTTPURLResponse *httpResponse = nil;
        
        // establish filenames for temp storage
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandleWrite;
        
        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLFacilityStatList"];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?ownerId=%@",className,userName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
        [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
        theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
        
        [fileManager createFileAtPath:filename contents: nil attributes:nil];
        fileHandleWrite = [NSFileHandle fileHandleForWritingAtPath:filename];
        [fileHandleWrite writeData:theRequest];
        [fileHandleWrite closeFile];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSLog(@"END get Hospitals");
    }
}


-(void)getContacts:(NSString*)filename

{
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {
        NSLog(@"ENTER get Contacts");
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *strAuthorization = [userDef stringForKey:@"authorization"];
        NSString *userName = [userDef stringForKey:@"userId"];
        NSString *lastSync = [userDef stringForKey:@"rmLastSyncDate"];
        NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
        if ([lastSync isKindOfClass:[NSDate class]])
            NSLog(@"is a date");
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a z"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormat dateFromString:lastSync];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a"];
        NSString *formattedLastSync = [dateFormat stringFromDate:dateFromString];
        formattedLastSync = [NSString stringWithFormat:@"%@",CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)formattedLastSync, NULL, CFSTR("!$&'()*+,-./:;=?@_~"), kCFStringEncodingUTF8)];
        
        NSData *theRequest;
        NSMutableURLRequest *request;
        NSError *error = nil;
        NSHTTPURLResponse *httpResponse = nil;
        
        // establish filenames for temp storage
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandleWrite;
        
        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLFacilityContactList"];
        
        NSString *temp;
        if ([fullSyncFlag isEqualToString:@"Y"] || ([lastSync length] == 0) || [lastSync isEqualToString:@"(null)"] )
            temp = [NSString stringWithFormat:@"ownerId=%@",userName];
        else
            temp = [NSString stringWithFormat:@"ownerId=%@&lastSyncDate=%@",userName,formattedLastSync];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",className,temp]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
        [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
        theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
        
        
        [fileManager createFileAtPath:filename contents: nil attributes:nil];
        fileHandleWrite = [NSFileHandle fileHandleForWritingAtPath:filename];
        [fileHandleWrite writeData:theRequest];
        [fileHandleWrite closeFile];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        NSLog(@"END get Contacts");
    }
}

-(void)getActivities:(NSString*)filename

{
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {
        NSLog(@"ENTER get Activities");
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *strAuthorization = [userDef stringForKey:@"authorization"];
        NSString *userName = [userDef stringForKey:@"userId"];
        NSString *lastSync = [userDef stringForKey:@"rmLastSyncDate"];
        NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
        if ([lastSync isKindOfClass:[NSDate class]])
            NSLog(@"is a date");
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a z"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormat dateFromString:lastSync];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a"];
        NSString *formattedLastSync = [dateFormat stringFromDate:dateFromString];
        formattedLastSync = [NSString stringWithFormat:@"%@",CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)formattedLastSync, NULL, CFSTR("!$&'()*+,-./:;=?@_~"), kCFStringEncodingUTF8)];
        
        NSData *theRequest;
        NSMutableURLRequest *request;
        NSError *error = nil;
        NSHTTPURLResponse *httpResponse = nil;
        
        // establish filenames for temp storage
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandleWrite;
        
        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLActivityList"];
        
        NSString *temp;
        if ([fullSyncFlag isEqualToString:@"Y"] || ([lastSync length] == 0) || [lastSync isEqualToString:@"(null)"] )
            temp = [NSString stringWithFormat:@"ownerId=%@",userName];
        else
            temp = [NSString stringWithFormat:@"ownerId=%@&lastSyncDate=%@",userName,formattedLastSync];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",className,temp]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
        [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
        theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
        
        
        [fileManager createFileAtPath:filename contents: nil attributes:nil];
        fileHandleWrite = [NSFileHandle fileHandleForWritingAtPath:filename];
        [fileHandleWrite writeData:theRequest];
        [fileHandleWrite closeFile];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSLog(@"END get Activities");
    }
}


-(void)getKits:(NSString*)filename

{
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {
        NSLog(@"ENTER get Kits");
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *strAuthorization = [userDef stringForKey:@"authorization"];
        NSString *userName = [userDef stringForKey:@"userId"];
        NSString *lastSync = [userDef stringForKey:@"rmLastSyncDate"];
        //NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
        if ([lastSync isKindOfClass:[NSDate class]])
            NSLog(@"is a date");
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a z"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormat dateFromString:lastSync];
        [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a"];
        NSString *formattedLastSync = [dateFormat stringFromDate:dateFromString];
        formattedLastSync = [NSString stringWithFormat:@"%@",CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)formattedLastSync, NULL, CFSTR("!$&'()*+,-./:;=?@_~"), kCFStringEncodingUTF8)];
        
        NSData *theRequest;
        NSMutableURLRequest *request;
        NSError *error = nil;
        NSHTTPURLResponse *httpResponse = nil;
        
        // establish filenames for temp storage
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandleWrite;
        
        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLAssetList"];
        
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@?ownerId=%@",className,userName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
        [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
        theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
        
        
        [fileManager createFileAtPath:filename contents: nil attributes:nil];
        fileHandleWrite = [NSFileHandle fileHandleForWritingAtPath:filename];
        [fileHandleWrite writeData:theRequest];
        [fileHandleWrite closeFile];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSLog(@"END get Kits");
    }
}

-(void)getClaims:(NSString*)filename
{
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {
        NSError *error = nil;
        NSManagedObjectContext *moc = self.managedObjectContext;
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Claims" inManagedObjectContext:moc];
        NSFetchRequest *requestClaims = [[NSFetchRequest alloc] init];
        [requestClaims setEntity:entityDesc];
        
        //NSManagedObject *matches = nil;
        NSArray *objects = [moc executeFetchRequest:requestClaims error:&error];
        for (NSManagedObject *match in objects)
        {
            [moc deleteObject:match];
            /*
             count++;
             if (count % LOOP_LIMIT == 0) {
             [moc save:&error];
             [moc reset];
             }
             */
        }
        [moc save:&error];
        
        NSLog(@"ENTER get Claims");
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *strAuthorization = [userDef stringForKey:@"authorization"];
        
        NSData *theRequest;
        NSMutableURLRequest *request;
        NSHTTPURLResponse *httpResponse = nil;
        
        // establish filenames for temp storage
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandleWrite;
        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLClaimsList"];
        
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@",className]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
        [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
        theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
        
        
        [fileManager createFileAtPath:filename contents: nil attributes:nil];
        fileHandleWrite = [NSFileHandle fileHandleForWritingAtPath:filename];
        [fileHandleWrite writeData:theRequest];
        [fileHandleWrite closeFile];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    
    [self loadClaims:[[NSData alloc] initWithContentsOfFile:filename]];
}
- (void)authUser {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
     NSString *msg = @"Enter username and password";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:msg  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];    
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *username = [alert textFieldAtIndex:0];
        username.text = [userDef stringForKey:@"userId"];
        [alert show];
  //  }
    
}
- (NSString*)authenticateLogin: (NSString *)userName pass: (NSString *)passWord {
    //current location
    CLLocationManager *clm = [[CLLocationManager alloc] init];
    
    //self.locationManager.delegate = self;
    clm.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    // Set a movement threshold for new events.
    clm.distanceFilter = 500;
    
    [clm startUpdatingLocation];
    
    CLLocation *myLocation = [clm location];
    
    NSError *error;
    NSMutableDictionary *authUser = [[NSMutableDictionary alloc] init];
    [authUser setValue:userName forKey:@"UserName"];
    [authUser setValue:passWord forKey:@"Password"];
    [authUser setValue:[NSNumber numberWithFloat:myLocation.coordinate.latitude] forKey:@"Latitude"];
    [authUser setValue:[NSNumber numberWithFloat:myLocation.coordinate.longitude] forKey:@"Longitude"];

    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLAuthUser"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authUser options:kNilOptions error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:className]  
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData    
                                                       timeoutInterval: WCF_TIMEOUT];     

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    NSData *receivedData = [NSData data];
    NSURLResponse *response;
    
    receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *strAuth = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ([error userInfo] == nil) {
        strAuth = [strAuth substringFromIndex:1];
        strAuth = [strAuth substringToIndex:[strAuth length]-1];
    }
    else {
        self.authenticationToken = @"error";
        self.errorReason = [[NSString alloc] initWithFormat:@"%@",[error localizedDescription]];
        strAuth = @"failure";
    }        

    return strAuth;
}

- (void)sendEmail:(NSString *)subject body:(NSString *)body{
    
    NSError *error;
    NSMutableDictionary *authUser = [[NSMutableDictionary alloc] init];
    [authUser setValue:subject forKey:@"Subject"];
    [authUser setValue:body forKey:@"Body"];
    
    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLSendEmail"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authUser options:kNilOptions error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:className]  
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData    
                                                       timeoutInterval: WCF_TIMEOUT];     
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    /*
     
    //Uncomment to switch to SyncRequest instead of Async
    NSData *receivedData = [NSData data];
    NSURLResponse *response;
    
    receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
     */
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){}];
     
    if ([error userInfo] == nil) {
    }
    else {
        self.authenticationToken = @"error";
        self.errorReason = [[NSString alloc] initWithFormat:@"%@",[error localizedDescription]];
    }        
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //exit(0);
    }
    else {
        UITextField *loginField = [alertView textFieldAtIndex:0];
        UITextField *passwordField = [alertView textFieldAtIndex:1];
        /*
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Authenticating";
        HUD.detailsLabelText = @"please be patient";
        HUD.dimBackground = YES;
        HUD.square = YES;
        [HUD show:YES];
        */
        NSString *authResult = [self authenticateLogin:loginField.text pass:passwordField.text];
        //[HUD hide:YES afterDelay:3];
        
        // if things are good, save the username and password that was used to authenticate
        if (![authResult isEqualToString:@"failure"]) {
            NSUserDefaults *managedObject = [NSUserDefaults standardUserDefaults];
            
            [managedObject setObject:[loginField.text uppercaseString] forKey:@"userId"];
            [managedObject setObject:passwordField.text forKey:@"password"];
            [managedObject setObject:authResult forKey:@"authorization"];
            
            // synchronize the settings
            [managedObject synchronize];
            
            self.authenticationToken = @"";
            //[self loadRMData];
            
        }
        // if things are bad, call the alert box again
        else {
            if ([self.authenticationToken isEqualToString:@"error"]  && [self.errorReason isEqualToString:@"A server with the specified hostname could not be found."]) {
                NSString *msg = @"Unable to connect to server.  Make sure you have a network connection.";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                [self performSelectorOnMainThread:@selector(authUser) withObject:nil waitUntilDone:YES];
            }
        }        
    }
}
- (void)renewUser {

    NSLog(@"Enter renewUser");
    
    NSError *error;

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *strUser = [userDef stringForKey:@"userId"];
    NSString *strToken = [userDef stringForKey:@"authorization"];
        NSMutableDictionary *authUser = [[NSMutableDictionary alloc] init];
        [authUser setValue:strUser forKey:@"UserName"];
        [authUser setValue:[userDef stringForKey:@"password"] forKey:@"Password"];
        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLRenewUser"];                
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:className]  
                                                               cachePolicy: NSURLRequestReloadIgnoringCacheData    
                                                           timeoutInterval: WCF_TIMEOUT];     
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strToken forHTTPHeaderField:@"Authorization"];

        NSData *receivedData = [NSData data];
        NSURLResponse *response;
        
        receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *strRenew = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        if ([error userInfo] == nil)
        {
            if ([strRenew isEqualToString:@"true"]) {
                self.authenticationToken = @"";
            }
            else
            {
                self.authenticationToken = @"error";
                NSString *authResult = [self authenticateLogin:[userDef stringForKey:@"userId"] pass:[userDef stringForKey:@"password"]];        
                if (![authResult isEqualToString:@"failure"]) 
                {
                    NSUserDefaults *managedObject = [NSUserDefaults standardUserDefaults];
                    [managedObject setObject:authResult forKey:@"authorization"];
                    [self renewUser];
                }
                else
                {
                    //LDAP
                    //[self performSelectorOnMainThread:@selector(authUser) withObject:nil waitUntilDone:YES];
                    //[self authUser];
                }
            }
        }
        else
        {
            self.authenticationToken = @"error";
            NSString *authResult = [self authenticateLogin:[userDef stringForKey:@"userId"] pass:[userDef stringForKey:@"password"]];        
            if (![authResult isEqualToString:@"failure"]) 
            {
                NSUserDefaults *managedObject = [NSUserDefaults standardUserDefaults];
                [managedObject setObject:authResult forKey:@"authorization"];
                [self renewUser];
            }
            else
            {
                if (operationQueue != NULL)
                    [operationQueue cancelAllOperations];
                //LDAP
                [self performSelectorOnMainThread:@selector(authUser) withObject:nil waitUntilDone:YES];
                //[self authUser];
            }
        }
  
    
    /*
    NSString *authResult = [self authenticateLogin:[userDef stringForKey:@"userId"] pass:[userDef stringForKey:@"password"]]; 
    
    if (![authResult isEqualToString:@"failure"]) {
        
        NSError *error;
        NSUserDefaults *managedObject = [NSUserDefaults standardUserDefaults];
        [managedObject setObject:authResult forKey:@"authorization"];
        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLRenewUser"];                
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:className]  
                                                               cachePolicy: NSURLRequestReloadIgnoringCacheData    
                                                           timeoutInterval: WCF_TIMEOUT];     
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authResult forHTTPHeaderField:@"Authorization"];
        
        NSData *receivedData = [NSData data];
        NSURLResponse *response;
        
        receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // synchronize the settings
        [managedObject synchronize];
        
        self.authenticationToken = @"";
        [self loadRMData];
    }
    else {
        [self performSelectorOnMainThread:@selector(authUser) withObject:nil waitUntilDone:YES];
    }        
    */
    
    NSLog(@"END renewUser");
    
}

- (void)endSync:(NSError *)comments{
    NSError *error;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *authUser = [[NSMutableDictionary alloc] init];
    
    [authUser setValue:[userDef stringForKey:@"userId"] forKey:@"UserName"];
    [authUser setValue:[userDef stringForKey:@"password"] forKey:@"Password"];
    [authUser setValue:[comments description] forKey:@"Comments"];
     if ([self.authenticationToken isEqualToString:@"error"])
     {
         [authUser setValue:@"Error" forKey:@"Status"];
     }
     else
     {
         
         if (![[userDef stringForKey:@"Status"] isEqualToString:@"Error"])
         {
             [authUser setValue:@"Done" forKey:@"Status"];
             NSDate *date = [NSDate date];
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
             [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
             [dateFormat setDateFormat:@"MM/dd/yy hh:mm:ss a z"];
             NSString *dateString = [dateFormat stringFromDate:date];
             [userDef setObject:[NSString stringWithFormat:@"%@",dateString] forKey:@"rmLastSyncDate"];
         }
         else
            [authUser setValue:@"Error" forKey:@"Status"];
     }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authUser options:kNilOptions error:&error];
    
    
    
    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLEndSync"];
    
    NSString *strToken = [userDef stringForKey:@"authorization"];
    //NSData *tokenData = [NSData dataWithBytes:[strToken UTF8String] length:[strToken lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:className]  
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData    
                                                       timeoutInterval:WCF_TIMEOUT];     
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:strToken forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:jsonData];
    
    NSData *receivedData = [NSData data];
    NSURLResponse *response;
    
    receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *strRenew = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ([error userInfo] == nil) {
        //NSLog(@"End Sync OK - %@", strRenew);
    }
    else {
        self.authenticationToken = @"error";
        self.errorReason = [[NSString alloc] initWithFormat:@"%@",[error localizedDescription]];
        //NSLog(@"End Sync FAIL - %@", [error userInfo]);
    }
    
    
}

-(void)resetFullSyncFlag
{
//cbrURLRMFullSyncUpdate
    NSError *error;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *authUser = [[NSMutableDictionary alloc] init];
    
    [authUser setValue:[userDef stringForKey:@"rmRowId"] forKey:@"EmployeeId"];
    [authUser setValue:@"N" forKey:@"FullSyncFlag"];
    //[authUser setValue:[comments description] forKey:@"Comments"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authUser options:kNilOptions error:&error];
    
    
    
    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLRMFullSyncUpdate"];
    
    NSString *strToken = [userDef stringForKey:@"authorization"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:className]
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:WCF_TIMEOUT];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:strToken forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:jsonData];
    
    NSData *receivedData = [NSData data];
    NSURLResponse *response;
    
    receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *strRenew = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ([error userInfo] == nil)
    {
        [userDef setValue:@"N" forKey:@"rmFullSync"];
        [userDef synchronize];
        //NSLog(@"reset Full Sync Flag OK - %@", strRenew);
    }
    else {
        self.authenticationToken = @"error";
        self.errorReason = [[NSString alloc] initWithFormat:@"%@",[error localizedDescription]];
        NSLog(@"End Sync FAIL - %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void)resetCoreData {
    NSError *error;
    //Erase the persistent store from coordinator and also file manager.
    NSPersistentStoreCoordinator *sC = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator];
    NSPersistentStore *store = [[sC persistentStores] lastObject];
    NSURL *storeURL = store.URL;
    [sC removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];

    NSString *storePath = [storeURL absoluteString];

        
    //Make new persistent store for future saves
    if (![sC addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // do something with the error
    }
    else
    {
        //re-initialize MOC after reseting core data
        if (sC != nil)
        {
            self.managedObjectContext = [[NSManagedObjectContext alloc] init];
            [self.managedObjectContext setPersistentStoreCoordinator:sC];
        }
        
    }
        if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
        NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
        if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:storePath error:&error]) {
            // Handle error
        }
    }
}


- (void) loadRMData
{
    
    NSLog(@"Enter loadRMData");

    NSData *theRequest;
    NSMutableURLRequest *request;
    NSError *error;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];    
    NSString *strAuthorization = [userDef stringForKey:@"authorization"];
    NSString *userName = [[userDef stringForKey:@"userId"] uppercaseString];
    
    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLRMData"];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@?ownerId=%@",className,userName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
    [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
    theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&error];
    
    //parse out the json data
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:theRequest options:kNilOptions error:&error];
    NSArray* rmData = [json objectForKey:@"RMInfo"];
    NSUserDefaults *managedObject = [NSUserDefaults standardUserDefaults];

    //[managedObject setObject:[NSString stringWithFormat:@"%@",@"N"] forKey:@"rmFullSync"];

    if ([rmData valueForKey:@"RowId"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"RowId"]] forKey:@"rmRowId"];
    if ([rmData valueForKey:@"PersonUId"] != [NSNull null]) 
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"PersonUId"]] forKey:@"rmPersonId"];
    if ([rmData valueForKey:@"FirstName"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"FirstName"]] forKey:@"rmFirstName"];
    if ([rmData valueForKey:@"LastName"] != [NSNull null]) 
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"LastName"]] forKey:@"rmLastName"];
    if ([rmData valueForKey:@"EmailAddress"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"EmailAddress"]] forKey:@"rmEmail"];
    else
        [managedObject setObject:[NSString stringWithFormat:@""] forKey:@"rmEmail"];
    if ([rmData valueForKey:@"Territory"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"Territory"]] forKey:@"rmTerritory"];
    else
        [managedObject setObject:[NSString stringWithFormat:@""] forKey:@"rmTerritory"];
    if ([rmData valueForKey:@"StorageFacilityId"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"StorageFacilityId"]] forKey:@"rmStorageId"];
    else
        [managedObject setObject:[NSString stringWithFormat:@""] forKey:@"rmStorageId"];
    if ([rmData valueForKey:@"StorageFacilityName"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"StorageFacilityName"]] forKey:@"rmStorage"];
    else
        [managedObject setObject:[NSString stringWithFormat:@""] forKey:@"rmStorage"];
    if ([rmData valueForKey:@"ManagerId"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"ManagerId"]] forKey:@"rdRowId"];
    else
        [managedObject setObject:[NSString stringWithFormat:@""] forKey:@"rdRowId"];
    if ([rmData valueForKey:@"ManagerLogin"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"ManagerLogin"]] forKey:@"rdLogin"];
    else
        [managedObject setObject:[NSString stringWithFormat:@""] forKey:@"rdLogin"];
    if ([rmData valueForKey:@"ManagerEmailAddress"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"ManagerEmailAddress"]] forKey:@"rdEmail"];
    else
        [managedObject setObject:[NSString stringWithFormat:@""] forKey:@"rdEmail"];
    if ([rmData valueForKey:@"ManagerRegion"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"ManagerRegion"]] forKey:@"rmRegion"];
    else
        [managedObject setObject:[NSString stringWithFormat:@""] forKey:@"rmRegion"];
    if ([rmData valueForKey:@"FullSyncFlag"] != [NSNull null])
    {
        if (![[managedObject valueForKey:@"rmFullSync"] isEqualToString:@"Y"])
        {
            [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"FullSyncFlag"]] forKey:@"rmFullSync"];
        }
    }
    else
    {
        if (![[managedObject valueForKey:@"rmFullSync"] isEqualToString:@"Y"])
            [managedObject setObject:[NSString stringWithFormat:@"%@",@"N"] forKey:@"rmFullSync"];
    }
    
    //override FullSyncFlag if no successful sync yet
    NSString *lastSync = [userDef stringForKey:@"rmLastSyncDate"];
    if (([lastSync length] == 0) || [lastSync isEqualToString:@"(null)"] )
        [managedObject setObject:[NSString stringWithFormat:@"%@",@"Y"] forKey:@"rmFullSync"];

    NSLog(@"END loadRMData");
    
}

- (void)loadClaims:(NSData *)responseData
{
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSError *error;
    //parse out the json data
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* claims = [json objectForKey:@"ClaimsList"];
    // create new records
    NSManagedObject *managedObject;
    NSUInteger count = 0, LOOP_LIMIT = 100;
    count = 0;
    @autoreleasepool {
        for (NSDictionary *item in claims) {
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Claims" inManagedObjectContext:moc];
            [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Value"]] forKey:@"value"];
            [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"ParentValue"]] forKey:@"parentLIC"];
            [managedObject setValue:[NSNumber numberWithInt:count] forKey:@"order"];
            
            count++;
            if (count == LOOP_LIMIT) {
                [moc save:nil];
                [moc reset];
                count = 0;
            }
        }
    }
    if (count != 0) {
        [moc save:nil];
        [moc reset];
    }
}

- (void) loadSalesMetrics
{
    
    NSLog(@"Enter loadSalesMetrics");
    
    NSData *theRequest;
    NSMutableURLRequest *request;
    NSError *error;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *strAuthorization = [userDef stringForKey:@"authorization"];
    NSString *userName = [[userDef stringForKey:@"userId"] uppercaseString];
    
    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLSalesMetrics"];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@?ownerId=%@",className,userName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
    [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
    theRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&error];
    
    //parse out the json data
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:theRequest options:kNilOptions error:&error];
    NSArray* rmData = [json objectForKey:@"RMSalesMetrics"];
    NSUserDefaults *managedObject = [NSUserDefaults standardUserDefaults];
    
    if ([rmData valueForKey:@"ACD_Oppty_Pct"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"ACD_Oppty_Pct"]] forKey:@"rmACD_Oppty_Pct"];
    
    if ([rmData valueForKey:@"CB_CT_Ratio"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"CB_CT_Ratio"]] forKey:@"rmCB_CT_Ratio"];
    
    if ([rmData valueForKey:@"Educated_Pct"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"Educated_Pct"]] forKey:@"rmEducated_Pct"];
    
    if ([rmData valueForKey:@"Educated"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"Educated"]] forKey:@"rmEducated"];
    
    if ([rmData valueForKey:@"New_Enroll_Pct"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"New_Enroll_Pct"]] forKey:@"rmNew_Enroll_Pct"];

    if ([rmData valueForKey:@"Total_CB"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"Total_CB"]] forKey:@"rmTotal_CB"];
    
    if ([rmData valueForKey:@"Total_CT"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"Total_CT"]] forKey:@"rmTotal_CT"];
    
    if ([rmData valueForKey:@"Total_Enroll"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"Total_Enroll"]] forKey:@"rmTotal_Enroll"];

    if ([rmData valueForKey:@"Total_Optys"] != [NSNull null])
        [managedObject setObject:[NSString stringWithFormat:@"%@",[rmData valueForKey:@"Total_Optys"]] forKey:@"rmTotal_Optys"];
    
    
    NSLog(@"END loadSalesMetrics");
    
}



#pragma mark observeValueForKeyPath
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == operationQueue && [keyPath isEqualToString:@"operations"])
    {
        if ([operationQueue.operations count] == 0)
        {
            // Do something here when your queue has completed
            NSLog(@"processing data...");
            [operationQueue removeObserver:self forKeyPath:@"operations"];
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
            {
                [self endSync:nil];
                //[self performSelectorOnMainThread:@selector(configureView) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(synchronizeDataAlertOnMainThread) withObject:nil waitUntilDone:YES];
                
            }
            else
            {
                if ((![self.authenticationToken isEqualToString:@"error"]) ||
                    (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"]))
                    [self processData];
                else
                {
                    HUD.dimBackground = NO;
                    [HUD hide:YES];
                    
                    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                    
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    [self.view setUserInteractionEnabled:YES];
                    for(UITabBarItem *item in [[self.tabBarController tabBar] items])
                        item.enabled = true;
                }
            }
        }
        else
        {
            HUD.detailsLabelText = @"Retrieving Data";
        }
    }
    else {
        HUD.detailsLabelText = @"Processing...";
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD.delegate = nil;
    HUD = nil;
}
#pragma mark MergeContext
- (void)mergeChanges:(NSNotification *)notification
{
    /*
	NSManagedObjectContext *mainContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
	// Merge changes into the main context on the main thread
	[mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                  withObject:notification
                               waitUntilDone:YES];
    */
    @try
    {
        if ([notification object] == [self managedObjectContext]) return;
        
        if (![NSThread isMainThread]) {
            [self performSelectorOnMainThread:@selector(mergeChanges:) withObject:notification waitUntilDone:YES];
            return;
        }
        
        [[self managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
    }
    @catch (NSException *exception)
    {
         NSLog(@"failed to mergeChanges: %@", exception);
    }

}

#pragma mark Network check
- (void)connectionChanged:(NSNotification*)note
{
	Reachability* r = [note object];
	NetworkStatus ns = r.currentReachabilityStatus;
    [r startNotifier];
	if (ns == NotReachable)
	{
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
	}
}

- (BOOL) isConnectionAvailable
{
    
    Reachability *r = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [r currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return FALSE;
    }
    else {
        return TRUE;
    }
}

@end
