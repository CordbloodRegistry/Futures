//
//  cbrHomeSettingsViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrHomeSettingsViewController.h"
#import "cbrAppDelegate.h"
#define WCF_TIMEOUT 900.0

@implementation cbrHomeSettingsViewController
@synthesize loginObject;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize appObject = _appObject;
@synthesize storageFacility = _storageFacility;

@synthesize autoSyncFlg;
@synthesize autoSyncFreq;
@synthesize storageFacilityName;
@synthesize storageFacilityAddr;
@synthesize storageFacilityCity;
@synthesize trademark;

- (void)configureView
{
    self.appObject = [NSUserDefaults standardUserDefaults];
    if (self.appObject != nil)
    {
        [self.loginObject setTitle:[self.appObject stringForKey:@"userId"]  forState:UIControlStateNormal];
        //self.pwd.text = [self.appObject stringForKey:@"password"];
        
        self.autoSyncFlg.on = [self.appObject integerForKey:@"autoSyncFlg"];
        self.autoSyncFreq.text = [NSString stringWithFormat:@"%d",[self.appObject integerForKey:@"syncFreq"]];
        
        NSManagedObjectContext *moc = self.managedObjectContext;
        
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        [fr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc]];
        //[fr setPredicate:[NSPredicate predicateWithFormat: @"(officeType = %@)", @"RM Dropoff Location"]];
        [fr setPredicate:[NSPredicate predicateWithFormat: @"(rowId = %@)", [self.appObject stringForKey:@"rmStorageId"]]];
        NSArray *officeArray = [moc executeFetchRequest:fr error:nil];
        
        if ([officeArray count] >= 1) {
            self.storageFacility = [officeArray objectAtIndex:0];
            self.storageFacilityName.text = [[officeArray objectAtIndex:0] valueForKey:@"name"];
            self.storageFacilityAddr.text = [[officeArray objectAtIndex:0] valueForKey:@"addr"];
            if ([[[officeArray objectAtIndex:0] valueForKey:@"addr2"] length] > 0) {
                self.storageFacilityAddr.text = [NSString stringWithFormat:@"%@, %@",[[officeArray objectAtIndex:0] valueForKey:@"addr"],[[officeArray objectAtIndex:0] valueForKey:@"addr2"]];
            }
            
            self.storageFacilityCity.text = [NSString stringWithFormat:@"%@, %@ %@",[[officeArray objectAtIndex:0] valueForKey:@"city"],[[officeArray objectAtIndex:0] valueForKey:@"state"],[[officeArray objectAtIndex:0] valueForKey:@"zipcode"]];
        }
        NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        self.trademark.text = [NSString stringWithFormat:@"%@\n\nVersion %@", @"The information contained in this program is confidential trade secret information of Cbr Systems, Inc.", version];
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.managedObjectContext == nil) 
    {
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    [self configureView];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureView];
}

- (void)viewDidUnload
{
    [self setAutoSyncFlg:nil];
    [self setAutoSyncFreq:nil];
    [self setStorageFacilityName:nil];
    [self setStorageFacilityAddr:nil];
    [self setStorageFacilityCity:nil];
    [self setLoginObject:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)saveSettings:(id)sender {
    
    NSString *errorMsg = @"";
    /*
    if([self.storageFacilityName.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Name is required"];
    }
    if([self.storageFacilityAddr.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Address is required"];
    }
    if([self.storageFacilityCity.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"City is required"];
    }
    if([self.storageFacilityState.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"State is required"];
    }
    if([self.storageFacilityZip.text length] == 0)
    {
        errorMsg = [NSString stringWithFormat:@"%@%@\n",errorMsg,@"Zipcode is required"];
    }
     */
    if ([errorMsg length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Storage Facility Error" message:errorMsg  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        /*
        NSManagedObjectContext *moc = self.managedObjectContext;
        NSManagedObject *managedObject = nil;
        
        if (self.storageFacility == nil)
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Offices" inManagedObjectContext:moc];
        else {
            managedObject = self.storageFacility;
        }
        
        [managedObject setValue:self.storageFacilityName.text forKey:@"name"];
        [managedObject setValue:self.storageFacilityAddr.text forKey:@"addr"];
        [managedObject setValue:self.storageFacilitySuite.text forKey:@"addr2"];
        [managedObject setValue:self.storageFacilityCity.text forKey:@"city"];
        [managedObject setValue:self.storageFacilityState.text forKey:@"state"];
        [managedObject setValue:self.storageFacilityZip.text forKey:@"zipcode"]; 
        [managedObject setValue:@"RM Dropoff Location" forKey:@"officeType"];
        [moc save:nil];
        
        if (self.storageFacility == nil)
            [self recordTransaction:managedObject txnType:@"Create"];
        else {
            [self recordTransaction:managedObject txnType:@"Update"];
        }
        
        //[managedObject setInteger:[[NSNumber numberWithBool:self.autoSyncFlg.isOn] integerValue] forKey:@"autoSyncFlg"];
        //[managedObject setInteger:[[NSString stringWithFormat:@"%@",self.autoSyncFreq.text] intValue] forKey:@"syncFreq"];
        //[managedObject synchronize];
        */
        //[self dismissModalViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)resetUI:(id)sender {
    NSError *error;
    //Erase the persistent store from coordinator and also file manager.
    NSPersistentStoreCoordinator *sC = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator];
    NSPersistentStore *store = [[sC persistentStores] lastObject];
    NSURL *storeURL = store.URL;
    [sC removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    
    
    NSLog(@"Data Reset");
    
    //Make new persistent store for future saves   (Taken From Above Answer)
    if (![sC addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // do something with the error
    }
    //abort();
}

- (IBAction)loginChange:(id)sender {    
    NSUserDefaults *managedObject = [NSUserDefaults standardUserDefaults];
    
        NSString *msg = @"Enter username and password";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:msg  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];    
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *username = [alert textFieldAtIndex:0];
        username.text = [managedObject stringForKey:@"userId"];
        [alert show];
}

- (NSString*)authenticateLogin: (NSString *)userName pass: (NSString *)passWord {
    NSError *error;
    NSMutableDictionary *authUser = [[NSMutableDictionary alloc] init];
    [authUser setValue:userName forKey:@"UserName"];
    [authUser setValue:passWord forKey:@"Password"];
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
    
    if ([error userInfo] == nil)
    {
        strAuth = [strAuth substringFromIndex:1];
        strAuth = [strAuth substringToIndex:[strAuth length]-1];
    }
    else
    {
        strAuth = @"failure";
    }        
    
    return strAuth;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //exit(0);
    }
    else {
        UITextField *loginField = [alertView textFieldAtIndex:0];
        UITextField *passwordField = [alertView textFieldAtIndex:1];
        
        NSString *authResult = [self authenticateLogin:loginField.text pass:passwordField.text];
        
        // if things are good, save the username and password that was used to authenticate
        if (![authResult isEqualToString:@"failure"]) {
            NSUserDefaults *managedObject = [NSUserDefaults standardUserDefaults];
            
            [managedObject setObject:[loginField.text uppercaseString] forKey:@"userId"];
            [managedObject setObject:passwordField.text forKey:@"password"];
            [managedObject setObject:authResult forKey:@"authorization"];
            
            // synchronize the settings
            [managedObject synchronize];
            
        }
        // if things are bad, call the alert box again
        else {
            [self loginChange:nil];
        }        
    }
}

- (void)recordTransaction:(NSManagedObject *) obj txnType:(NSString *) type
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
    [newTransaction setValue:type forKey:@"transactionType"];
    
    [clm stopUpdatingLocation];
    
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    
    [context save:nil];
}

@end
