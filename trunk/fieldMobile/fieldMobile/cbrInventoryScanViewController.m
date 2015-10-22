//
//  cbrInventoryScanViewController.m
//  fieldDevice
//
//  Created by Hai Tran on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrInventoryScanViewController.h"
#import "RedLaserSDK.h"
#import "cbrInventoryScanOverlayController.h"
#import "cbrAppDelegate.h"
#import "LineaSDK.h"

@interface cbrInventoryScanViewController ()
@end

@implementation cbrInventoryScanViewController
@synthesize linea;
@synthesize debug;
@synthesize scanMode;
@synthesize scannedLabel;
@synthesize scanButton;
@synthesize rescanButton;
@synthesize zbarReader;

@synthesize detailItem = _detailItem;
@synthesize scanType = _scanType;
@synthesize barcodesScanned = _barcodesScanned;
@synthesize lblDepositError;
@synthesize depositIds = _depositIds;
@synthesize scannedIds = _scannedIds;

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad {

    self.barcodesScanned = 0;
    if ([self.scanType isEqualToString:@"count"]) {
        self.scanMode.text = [[NSString alloc] initWithFormat:@"# Of Kits Counted: %@",self.barcodesScanned]; 
    }
    else {
        self.scanMode.text = [[NSString alloc] initWithFormat:@"# Of Kits Transferred: %@",self.barcodesScanned];
        [scanButton setTitle:@"Save"];
        scanButton.enabled = NO;
    }
    
    self.depositIds = [[NSMutableArray alloc] init];

    cbrinventoryScanViewController = self;
    
	linea = [Linea sharedDevice];
	[linea addDelegate:self];
    [linea connect];
        
    [super viewDidLoad];
}

- (void)viewDidUnload {    
    [self cleanScreen];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CBR Barcode Processing Arguments
- (void) processBarcode:(NSString *)barcode {
    NSString *theBarcode = barcode;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userStorageId = [userDef stringForKey:@"rmStorageId"];
    
    bool firstScan = YES;
    for (NSString *item in self.scannedIds) 
    {
        if ([item isEqualToString:theBarcode]) {
            firstScan = NO;
            break;
        }
    }
    
    if (firstScan) 
    {
      
        [self.scannedIds addObject:theBarcode];
      
        scannedLabel.text = [[NSString alloc] initWithFormat:@"Barcodes Scanned:"];
        scanButton.title = @"Save";
        scanButton.enabled = YES;
        
        // check to see if this is a good barcode
        bool badKit = NO;
        bool agingKit = NO;
        NSManagedObjectContext *moc;
        if (self.detailItem != NULL)
            moc = [self.detailItem managedObjectContext];
        else {
            moc = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        }
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        
        [fr setEntity:[NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc]];
        
        //case scanning; only valid for Kit Receive
        if ([theBarcode length] == 10 && [self.scanType isEqualToString:@"transfer"])
        {
            [fr setPredicate:[NSPredicate predicateWithFormat: @"(boxNumber = %@)", theBarcode]];
            
            NSArray *kitArray = [moc executeFetchRequest:fr error:nil];
            
            NSDate *agingDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*180];
            if ([kitArray count] == 0) 
            {
                badKit = YES;
            }
            else
            {
                badKit = NO;
                for (NSManagedObject *kit in kitArray)
                {
                    agingKit = NO;
                    badKit = NO;
                    if ([agingDate compare:[kit valueForKey:@"expirationDate"]] == NSOrderedSame || [agingDate compare:[kit valueForKey:@"expirationDate"]] == NSOrderedDescending)
                    {
                        //badKit = YES;
                        agingKit = YES;
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Kit not valid for distribution.  Return to Lab.\n%@",[kit valueForKey:@"depositId"]]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    //scannedLabel.text =  [NSString stringWithFormat:@"%@\n%@", scannedLabel.text, [kit valueForKey:@"depositId"]];
                    
                    
                    if(!badKit || agingKit)
                    {
                        bool barcodeExists = NO;
                        for (NSString *item in self.depositIds)
                        {
                            if ([item isEqualToString:[kit valueForKey:@"depositId"]])
                                barcodeExists = YES;
                        }
                        if ((!barcodeExists && !badKit) ||
                            (!barcodeExists && badKit && agingKit)) {
                            scannedLabel.text = [NSString stringWithFormat:@"%@\n%@", scannedLabel.text, [kit valueForKey:@"depositId"]];
                            [self.depositIds addObject:[kit valueForKey:@"depositId"]];
                        }
                    }

                }
                if ([self.scanType isEqualToString:@"count"])
                    self.scanMode.text = [[NSString alloc] initWithFormat:@"# Of Kits Counted: %d",[self.depositIds count]]; 
                else 
                {
                    self.scanMode.text = [[NSString alloc] initWithFormat:@"# Of Kits Transferred: %d",[self.depositIds count]];
                }
            }
        }
        else if ([theBarcode length] == 12)
        {
            [fr setPredicate:[NSPredicate predicateWithFormat: @"(depositId = %@)", theBarcode]];
            
            NSArray *kitArray = [moc executeFetchRequest:fr error:nil];
            
            NSDate *agingDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*180];
            NSString *ofcId;
            NSString *entityName = [[self.detailItem entity] name];
            if ([entityName isEqualToString:@"Offices"])
                ofcId = [[self detailItem] valueForKey:@"rowId"];
            else
                ofcId = [[self detailItem] valueForKey:@"facilityId"];
            
            for (NSManagedObject *kit in kitArray)
            {

                if ([[kit valueForKey:@"status"] isEqualToString:@"In Transit"])
                {
                    if ([self.scanType isEqualToString:@"count"])
                    {
                        badKit = YES;
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"You must first scan the kit(s) as kit received before you can count them into your inventory.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    
                    }
                    if (![[self.detailItem valueForKey:@"rowId"] isEqualToString:userStorageId])
                    {
                        badKit = YES;
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"You must first scan the kit(s) as kit received before you can distribute out.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                else if ([self.scanType isEqualToString:@"transfer"] && [[kit valueForKey:@"assignedOfficeId"] isEqualToString:ofcId])
                {
                    badKit = YES;
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Kit is already assigned to this facility.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if ([agingDate compare:[kit valueForKey:@"expirationDate"]] == NSOrderedSame || [agingDate compare:[kit valueForKey:@"expirationDate"]] == NSOrderedDescending)
                {
                    //badKit = YES;
                    agingKit = YES;
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Kit not valid for distribution.  Return to Lab.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            }
            if ([kitArray count] == 0) 
            {
                badKit = YES;
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Kit not valid for distribution.  Return to Lab.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            [fr setEntity:[NSEntityDescription entityForName:@"KitsBad" inManagedObjectContext:moc]];
            [fr setPredicate:[NSPredicate predicateWithFormat: @"(depositId = %@)", theBarcode]];
            
            kitArray = [moc executeFetchRequest:fr error:nil];
            if ([kitArray count] > 0)
            {
                badKit = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Kit not valid for distribution.  Return to Lab.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            if (badKit || agingKit)
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
/*
                UIAlertView *alert;
                if (agingKit)
                    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Kit not valid for distribution.  Return to Lab.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                else
                    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Kit not valid for distribution. Contact field ops to confirm kit status before distribution.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
 */
                SystemSoundID pmph;
                id sndpath = [[NSBundle mainBundle] 
                              pathForResource:@"ubuzzer" 
                              ofType:@"mp3" 
                              inDirectory:@"/"];
                CFURLRef baseURL = (__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:sndpath];
                AudioServicesCreateSystemSoundID (baseURL, &pmph);
                AudioServicesPlaySystemSound(pmph);
            }
            
            if(!badKit || agingKit)
            {
                bool barcodeExists = NO;
                for (NSString *item in self.depositIds) 
                {
                    scannedLabel.text =  [NSString stringWithFormat:@"%@\n%@", scannedLabel.text, item];
                    if ([item isEqualToString:theBarcode])
                        barcodeExists = YES;
                }
                if ((!barcodeExists && !badKit) ||
                    (!barcodeExists && badKit && agingKit)) {
                    scannedLabel.text = [NSString stringWithFormat:@"%@\n%@", scannedLabel.text, theBarcode];
                    [self.depositIds addObject:theBarcode];
                }
            }
            if ([self.scanType isEqualToString:@"count"]) {
                self.scanMode.text = [[NSString alloc] initWithFormat:@"# Of Kits Counted: %d",[self.depositIds count]]; 
            } else {
                self.scanMode.text = [[NSString alloc] initWithFormat:@"# Of Kits Transferred: %d",[self.depositIds count]];
            }
        }
        else{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Invalid barcode.\n%@",theBarcode]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
- (void) unexpectedKit:(NSString *) barcode inventory: (bool) inventoryflg {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];    
    NSString *userRowId = [userDef stringForKey:@"rmRowId"];
    NSString *userFirstName = [userDef stringForKey:@"rmFirstName"];
    NSString *userLastName = [userDef stringForKey:@"rmLastName"];
    NSString *userStorageId = [userDef stringForKey:@"rmStorageId"];
    
    NSManagedObjectContext *moc = [[self detailItem] managedObjectContext];
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Kits" inManagedObjectContext:moc];
    
    //[managedObject setValue:[NSString stringWithFormat:@"Active"] forKey:@"status"];
    [managedObject setValue:[NSString stringWithFormat:@"TBD"] forKey:@"product"];
    [managedObject setValue:[NSString stringWithFormat:@"%@",barcode] forKey:@"depositId"];
        
    if (self.detailItem != nil) {
        NSString *entityName = [[self.detailItem entity] name];
        if ([entityName isEqualToString:@"Offices"]) {	
            [managedObject setValue:[self.detailItem valueForKey:@"rowId"] forKey:@"assignedOfficeId"];
            if ([[self.detailItem valueForKey:@"rowId"] isEqualToString:userStorageId]) {
                [managedObject setValue:userRowId forKey:@"assignedContactId"]; 
            }
        }
        if ([entityName isEqualToString:@"Providers"]) {
            [managedObject setValue:[self.detailItem valueForKey:@"facilityId"] forKey:@"assignedOfficeId"];
            [managedObject setValue:[self.detailItem valueForKey:@"rowId"] forKey:@"assignedContactId"]; 
            [managedObject setValue:[self.detailItem valueForKey:@"firstName"] forKey:@"assignedContactFirstName"]; 
            [managedObject setValue:[self.detailItem valueForKey:@"lastName"] forKey:@"assignedContactLastName"]; 
        }
    }
    else {
        [managedObject setValue:userStorageId forKey:@"assignedOfficeId"];
        [managedObject setValue:userRowId forKey:@"assignedContactId"];
        [managedObject setValue:userFirstName forKey:@"assignedContactFirstName"]; 
        [managedObject setValue:userLastName forKey:@"assignedContactLastName"]; 
    }
    
    [self recordTransaction:managedObject transactionType:@"Transfer"];
    if (inventoryflg) {
        [self recordTransaction:managedObject transactionType:@"Inventory - Exists"];
    }
}
- (IBAction)saveScan:(id)sender {
    NSManagedObjectContext *moc = [self.detailItem managedObjectContext];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];    
    NSString *userRowId = [userDef stringForKey:@"rmRowId"];
//    NSString *userFirstName = [userDef stringForKey:@"rmFirstName"];
//    NSString *userLastName = [userDef stringForKey:@"rmLastName"];
    NSString *userStorageId = [userDef stringForKey:@"rmStorageId"];
    
    bool unexpectedKit = NO;
    bool isReceive = NO;
    
    // transfer
    if ([self.scanType isEqualToString:@"transfer"])
    {
        for (NSString *item in self.depositIds)
        {
            unexpectedKit = YES;
            [fr setEntity:[NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc]];
            [fr setPredicate:[NSPredicate predicateWithFormat: @"(depositId = %@)", item]];
        
            NSArray *kitArray = [moc executeFetchRequest:fr error:nil];
    
            for (NSManagedObject *kit in kitArray)
            {
                NSManagedObject *scannedKit = kit;
                unexpectedKit = NO;
                
                if (self.detailItem != nil) {
                    //Kit Transfer
                    NSString *entityName = [[self.detailItem entity] name];
                    //Transfer to Office
                    if ([entityName isEqualToString:@"Offices"]) {
                       
                        if ([[self.detailItem valueForKey:@"rowId"] isEqualToString:userStorageId] &&
                            [[scannedKit valueForKey:@"status"] isEqualToString:@"In Transit"])
                            isReceive = YES;
                        [scannedKit setValue:[self.detailItem valueForKey:@"rowId"] forKey:@"assignedOfficeId"];
                        /* RS 12082014 - ERP
                        [scannedKit setValue:@"" forKey:@"assignedContactId"]; //====> need to know who to assign the transferred kit to!!!
                        if ([[self.detailItem valueForKey:@"rowId"] isEqualToString:userStorageId]) {
                            [scannedKit setValue:userRowId forKey:@"assignedContactId"]; 
                        }
                        */
                    }
                     //Transfer to Provider
                    else if ([entityName isEqualToString:@"Providers"]) {
                        [scannedKit setValue:[self.detailItem valueForKey:@"facilityId"] forKey:@"assignedOfficeId"];
                        /*RS 12082014 - ERP
                        [scannedKit setValue:[self.detailItem valueForKey:@"rowId"] forKey:@"assignedContactId"]; 
                        [scannedKit setValue:[self.detailItem valueForKey:@"firstName"] forKey:@"assignedContactFirstName"]; 
                        [scannedKit setValue:[self.detailItem valueForKey:@"lastName"] forKey:@"assignedContactLastName"]; 
                        */
                    }
                    
                }
                else {
                    //Transfer to RM Dropoff Location
                    //12.04.2014 - If original status = In Transit and location = RM Dropoff location
                    if ([scannedKit valueForKey:@"assignedOfficeId"] == userStorageId &&
                        [[scannedKit valueForKey:@"status"] isEqualToString:@"In Transit"])
                        isReceive = YES;

                    [scannedKit setValue:userStorageId forKey:@"assignedOfficeId"];
                    /* RS 12082014 - ERP
                    [scannedKit setValue:userRowId forKey:@"assignedContactId"]; 
                    [scannedKit setValue:userFirstName forKey:@"assignedContactFirstName"];
                    [scannedKit setValue:userLastName forKey:@"assignedContactLastName"];
                     */
                }
                [scannedKit setValue:@"Active" forKey:@"status"];
                if (!isReceive)
                    [self recordTransaction:scannedKit transactionType:@"Transfer"];
                else
                    [self recordTransaction:scannedKit transactionType:@"Receive"];
            }
            //12.04.2014 RS - ERP: If Kit is not within the territory, do not make transaction.
            /*
            if (unexpectedKit) {
                [self unexpectedKit:item inventory:NO];
            }
            */
        }
    }
    // count 
    else if ([self.scanType isEqualToString:@"count"])
    {
        NSEntityDescription *kitEntity = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
        [fr setEntity:kitEntity];
        
        if (self.detailItem != nil) {
            NSString *entityName = [[self.detailItem entity] name];
            
            if ([entityName isEqualToString:@"Offices"]) {	
                NSPredicate *kitPredicate = [NSPredicate predicateWithFormat: @"(status != %@ && assignedOfficeId = %@)",@"Inactive/Lost",[self.detailItem valueForKey:@"rowId"]];
                [fr setPredicate:kitPredicate];
            }
            if ([entityName isEqualToString:@"Providers"]) {
                NSPredicate *kitPredicate = [NSPredicate predicateWithFormat: @"(status != %@ && assignedOfficeId = %@)",@"Inactive/Lost",[self.detailItem valueForKey:@"facilityId"]];
                [fr setPredicate:kitPredicate];
            }
        }
        else
        {
            NSPredicate *kitPredicate = [NSPredicate predicateWithFormat: @"(status != %@ && assignedContactId = %@)",@"Inactive/Lost",userRowId];
            [fr setPredicate:kitPredicate];
        }
        //NSSortDescriptor *kitSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"assignedOfficeId" ascending:YES];
        //[fr setSortDescriptors:[NSArray arrayWithObject:kitSortDescriptor]];
        
        NSArray *kitArray = [moc executeFetchRequest:fr error:nil];
        bool needsCount = NO;
        // mark lost kits first
        for (NSManagedObject *kit in kitArray) {
            BOOL isAccountedFor = NO;
            for (NSString *item in self.depositIds) {
                if ([item isEqualToString:[kit valueForKey:@"depositId"]])
                    isAccountedFor = YES;
            }
            if (!isAccountedFor) {
                if ([kit valueForKey:@"status"] != nil) {
                    [kit setValue:@"Inactive/Lost" forKey:@"status"];
                    needsCount = YES;
                }
                //else {
                    //[kit setValue:@"" forKey:@"assignedOfficeId"];
                    //[kit setValue:@"" forKey:@"assignedContactId"];
                //}
                //RS 12.11.2014 - ERP
                //[self recordTransaction:kit transactionType:@"Inventory - Lost"];
            }
        }
        // now mark kits accounted for.  If they aren't in inventory then transfer them, then mark that they exist.
        for (NSString *item in self.depositIds)
        {
            unexpectedKit = YES;
            //[fr setPredicate:[NSPredicate predicateWithFormat: @"(status != %@) && (depositId = %@)", @"Arrived At Lab", item]];
            [fr setPredicate:[NSPredicate predicateWithFormat: @"(depositId = %@)",  item]];
            
            NSArray *kitCountArray = [moc executeFetchRequest:fr error:nil];
            for (NSManagedObject *kit in kitCountArray)
            {
                unexpectedKit = NO;
                // if the id's don't match up, transfer it, then confirm it.
                NSString *sOfficeId = @"";
                NSString *sContactId = @"";
                bool needsTransfer = NO;
                if (self.detailItem != nil) {
                    NSString *entityName = [[self.detailItem entity] name];
                    if ([entityName isEqualToString:@"Offices"]) {	
                        sOfficeId = [self.detailItem valueForKey:@"rowId"];
                        if ([sOfficeId isEqualToString:userStorageId]) {
                            sContactId = userRowId;
                        }
                    }
                    if ([entityName isEqualToString:@"Providers"]) {
                        sOfficeId = [self.detailItem valueForKey:@"facilityId"];
                        sContactId = [self.detailItem valueForKey:@"rowId"];
                    }
                }
                else {
                    sOfficeId = userStorageId;
                    sContactId = userRowId;
                }

                // compare for office -- IF DIFFERENT THEN TRANSFER
                if (![[kit valueForKey:@"assignedOfficeId"] isEqualToString:sOfficeId]) {
                    needsTransfer = YES;
                }

                if (needsTransfer)
                {
                    [kit setValue:sOfficeId forKey:@"assignedOfficeId"];
                    [kit setValue:sContactId forKey:@"assignedContactId"];
                    needsCount = YES;
                    //[self recordTransaction:kit transactionType:@"Transfer"];
                }
                else {
                    
                // now confirm the kit
                    needsCount = YES;
                    //[self recordTransaction:kit transactionType:@"Inventory - Exists"];
                }
                if ([[kit valueForKey:@"status"] isEqualToString:@"Inactive/Lost"]) {
                    [kit setValue:@"Active" forKey:@"status"];
                }
                
            }
            //12.04.2014 - If Kit is not within the territory, do not make transaction.
            /*
             if (unexpectedKit) {
                [self unexpectedKit:item inventory:YES];
            }
            */
        }
        
        if ([self.depositIds count] == 0)
            needsCount = YES;
        if (needsCount)
        {
            if (self.detailItem != nil)
            {
                //Kit count for Provider office or Hospital
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
                [fr setEntity:entity];
                NSPredicate *officePredicate;
                
                if ([[[self.detailItem entity] name] isEqualToString:@"Offices"])
                    officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [[self.detailItem  valueForKey:@"rowId"] description]];
                else
                    officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [[self.detailItem  valueForKey:@"facilityId"] description]];
                
                [fr setPredicate:officePredicate];
                
                NSArray *ofcCountArray = [moc executeFetchRequest:fr error:nil];
                for (NSManagedObject *ofc in ofcCountArray)
                    [self recordTransaction:ofc transactionType:@"Count"];
            }
            else{
                //Kit count for RM Dropoff location
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
                [fr setEntity:entity];
                NSPredicate *officePredicate;
                
                officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", userStorageId];
                [fr setPredicate:officePredicate];
                
                NSArray *ofcCountArray = [moc executeFetchRequest:fr error:nil];
                for (NSManagedObject *ofc in ofcCountArray)
                    [self recordTransaction:ofc transactionType:@"Count"];
            }
        }
    }
    
    // Save the context.
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    //    abort();
    }
    [self cleanScreen];
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void)cleanScreen {
    [self setScannedLabel:nil];
    [self setScanButton:nil];
    [self setRescanButton:nil];
    [self setScanMode:nil];
    [self setLblDepositError:nil];
    [self setScannedIds:nil];
    [self setDepositIds:nil];
    [self setZbarReader:nil];
    [linea setCharging:NO error:nil];
    [linea disconnect];
    [linea removeDelegate:self];
}

- (void)recordTransaction:(NSManagedObject *)obj transactionType:(NSString *)sType {
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
    
    [newTransaction setValue:@"Kit" forKey:@"entityType"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.latitude] forKey:@"latitude"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.longitude] forKey:@"longitude"];
    [newTransaction setValue:today forKey:@"transactionDate"];
    [newTransaction setValue:sType forKey:@"transactionType"];
    
    [clm stopUpdatingLocation];
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
}

- (IBAction)reScan:(id)sender {
    [self.scannedIds removeAllObjects];
    [self initiateZBarScan];
    //[self initiateRLScan];  Can't use Red Lazer because they charge $2500 for 25,000 downloads... ZBar is free
}

#pragma mark - RedLaser SDK Arguments
- (void) initiateRLScan {
    BarcodePickerController *picker = [[BarcodePickerController alloc] init];
    [picker prepareToScan];
    
    cbrInventoryScanOverlayController *customOverlay = [[cbrInventoryScanOverlayController alloc] init];
    
    [picker setOverlay:customOverlay];
    [picker setDelegate:self];
    picker.orientation = UIImageOrientationUp;
    picker.scanCODE128 = YES;
    picker.scanCODE39 = YES;
    picker.scanDATAMATRIX = YES;
    picker.scanEAN13 = YES;
    picker.scanEAN2 = YES;
    picker.scanEAN5 = YES;
    picker.scanEAN8 = YES;
    picker.scanITF = YES;
    picker.scanQRCODE = YES;
    picker.scanSTICKY = YES;
    picker.scanUPCE = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[self presentModalViewController:picker animated:TRUE];
    [self presentViewController:picker animated:TRUE completion:Nil];
}
- (void) barcodePickerController:(BarcodePickerController*)picker
                   returnResults:(NSSet *)results {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //[self dismissModalViewControllerAnimated:TRUE];
    [self dismissViewControllerAnimated:YES completion:Nil];
	// Note that it is possible to get multiple results discovered at the same time.
	// Even if you return as soon as you see result barcodes, there could be more than one.
    NSArray *codes = [results allObjects];
    for (BarcodeResult *foundCode in codes)
	{   
        [self processBarcode:foundCode.barcodeString];
    }
}
- (IBAction)cancelScan:(id)sender {
    rescanButton.enabled = NO;
    [self cleanScreen];
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:Nil];

    
}

#pragma mark - LineaPro SDK Arguments
- (void)connectionState:(int)state {
	switch (state) {
        case CONN_DISCONNECTED: {
            break;
        }
        case CONN_CONNECTING: {
            break;
        }
        case CONN_CONNECTED: {
            scanActive=false;
            NSError *error;
            
            // this command attempts to turn the linea pro sleeve into a charger for the phone.
            SHOWERR([linea setCharging:YES error:&error]);
            SHOWERR([linea msStartScan:&error]);
            /*
             //encrypted head, you can check supported algorithms and select the one you want
             if([linea.deviceModel rangeOfString:@"AMCM"].location!=NSNotFound || [linea.deviceModel rangeOfString:@"CM"].location!=NSNotFound)
             {
             //NSArray *supported=[linea emsrGetSupportedEncryptions:&error];
             [linea emsrSetEncryption:ALG_EH_IDTECH params:nil error:nil];
             }
             */
            
            // control beep for barcode scan
            int sound[]={2000,30,730,0};
            [linea setScanBeep:YES volume:50 beepData:sound length:sizeof(sound) error: nil];
            break;
        }
        default:
            break;
	}
}
- (void)barcodeData:(NSString *)barcode type:(int)type {
    bool firstScan = YES;
    NSMutableArray *scannedList = self.scannedIds;
    for (NSString *item in scannedList) 
    {
        if ([barcode isEqualToString:item]) {
            firstScan = NO;
            break;
        }
    }
    
    if (firstScan) {
        [self.scannedIds addObject:barcode];
        [self processBarcode:barcode];
    }
    scannedList = nil;
}
- (NSString *)getLogFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"log.txt"];
}

- (void)debug:(NSString *)text {
	NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"HH:mm:ss:SSS"];
	NSString *timeString = [dateFormat stringFromDate:[NSDate date]];
	
	if([debug length]>10000)
		[debug setString:@""];
	[debug appendFormat:@"%@-%@\n",timeString,text];
    
#ifdef LOG_FILE
	[debug writeToFile:[self getLogFile]  atomically:YES];
#endif
}

bool scanActive=false;

- (IBAction)lineaPushDown:(id)sender {
	[self.scanMode setText:@""];
    
    NSError *error=nil;
    
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    
    int scanMode1;
    if([linea getScanMode:&scanMode1 error:&error] && scanMode1==MODE_MOTION_DETECT)
    {
        if(scanActive)
        {
            scanActive=false;
            SHOWERR([linea stopScan:&error]);
        }else {
            scanActive=true;
            SHOWERR([linea startScan:&error]);
        }
    }else
        SHOWERR([linea startScan:&error]);
}

- (IBAction)lineaPushUpInside:(id)sender {
    NSError *error;
    
    int scanMode1;
    
    if([linea getScanMode:&scanMode1 error:&error] && scanMode1!=MODE_MOTION_DETECT)
        SHOWERR([linea stopScan:&error]);
}
#pragma mark - ZBar SDK Arguments
- (void) initiateZBarScan {
    
    //[self.scannedIds removeAllObjects];
    
    zbarReader = [ZBarReaderViewController new];
    zbarReader.readerDelegate = self;
    //zbarReader.showsHelpOnFail = NO;
    
    [zbarReader setSupportedOrientationsMask:ZBarOrientationMask(UIDeviceOrientationPortrait)];
    [zbarReader setShowsZBarControls:NO];
    
    // SET UP OVERLAY
    UIView *overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];    
    
    // Define purple scan area
    UIView *scanArea = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 300, 80)];
    [scanArea setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.2]];
    [overlayView addSubview:scanArea];
    
    // Add arrow markers
    UIImage *down_arrow =  [UIImage imageNamed:@"white_down_arrow.png"];
    UIImage *up_arrow = [UIImage imageNamed:@"white_up_arrow.png"];
    
    UIImageView *down_arrow_view = [[UIImageView alloc] initWithFrame:CGRectMake(-60,77,440,down_arrow.size.height)];
    UIImageView *up_arrow_view = [[UIImageView alloc] initWithFrame:CGRectMake(-60,143,440,up_arrow.size.height)];

    [down_arrow_view setImage:down_arrow];
    [up_arrow_view setImage:up_arrow];
    
    [overlayView addSubview:down_arrow_view];
    [overlayView addSubview:up_arrow_view];
    
    // Define Reader scanning area based on scan area
    zbarReader.scanCrop = CGRectMake(scanArea.frame.origin.y/480, scanArea.frame.origin.x/320, scanArea.frame.size.height/480, scanArea.frame.size.width/320);
    
    // Define bottom toolbar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
    //toolBar.barStyle = UIBarStyleBlack;
    //toolBar.translucent = YES;
    [toolBar sizeToFit];
    
    // initialize buttons: cancel, rotate, flash, flexitem
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPressed)];
    UIBarButtonItem *flashButton = [[UIBarButtonItem alloc] initWithTitle:@"Light" style:UIBarButtonItemStyleBordered target:self action:@selector(flashPressed)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *items = [NSArray arrayWithObjects: cancelButton, flexItem, flexItem, flashButton, nil];
    [toolBar setItems:items animated:NO];
    
    [overlayView addSubview:toolBar];
    
    // Attach overlay to controller
    [zbarReader setCameraOverlayView:overlayView];
    
    // Disable rarely used barcodes to improve performance
    ZBarImageScanner *scanner = zbarReader.scanner;
    
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_EAN8 config:ZBAR_CFG_ENABLE to:0];
    [scanner setSymbology: ZBAR_UPCE config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_ISBN10 config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_EAN13 config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_ISBN13 config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_DATABAR config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_DATABAR_EXP config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_CODE39 config: ZBAR_CFG_ENABLE to: 0];
    [scanner setSymbology: ZBAR_QRCODE config: ZBAR_CFG_ENABLE to: 0];
    
    //[scanner setSymbology: 0 config: ZBAR_CFG_ENABLE to: 0];
    //[scanner setSymbology: ZBAR_QRCODE config: ZBAR_CFG_ENABLE to: 1];

    // present and release the controller
    //[self presentModalViewController: zbarReader animated: YES];
    [self presentViewController:zbarReader animated:YES completion:nil];
}
// delegate method
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info {
    //[reader dismissModalViewControllerAnimated: YES];
    [reader dismissViewControllerAnimated:YES completion:Nil];
    
    // play the beep noise
    SystemSoundID pmph;
    id sndpath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav" inDirectory:@"/"];
    CFURLRef baseURL = (__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:sndpath];
    AudioServicesCreateSystemSoundID (baseURL, &pmph);
    AudioServicesPlaySystemSound(pmph);

    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];

    for(ZBarSymbol *symbol in results) {
        [self processBarcode:symbol.data];
        //resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    }
}
-(IBAction)cancelPressed {
    //[zbarReader dismissModalViewControllerAnimated:YES];
    [zbarReader  dismissViewControllerAnimated:YES completion:Nil];
}
-(IBAction)flashPressed {
    if (zbarReader != nil) {
        if (zbarReader.readerView.torchMode == 0) {
            [zbarReader.readerView setTorchMode: 1];
        }
        else {
            [zbarReader.readerView setTorchMode:0];
        }
    }
}
@end
