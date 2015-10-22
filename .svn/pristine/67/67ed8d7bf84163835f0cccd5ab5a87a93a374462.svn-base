//
//  cbrSendHospitalTransactionOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//
#define WCF_TIMEOUT 900.0
#import "cbrSendHospitalTransactionOperation.h"
#import "cbrAppDelegate.h"

@implementation cbrSendHospitalTransactionOperation
@synthesize done;
@synthesize status;
@synthesize errorMsg;
@synthesize description;


-(id)initWithDescription:(NSString *)desc
{
    if ((self = [super init]))
    {
        description = desc;
    }
    return self;
}


- (void)mergeChanges:(NSNotification *)notification
{
	NSManagedObjectContext *mainContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
	// Merge changes into the main context on the main thread
	[mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                  withObject:notification
                               waitUntilDone:YES];
}

-(void) main
{
    NSLog(@"ENTER Push Hospitals");
    // Create context on background thread
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	[moc setUndoManager:nil];
	[moc setPersistentStoreCoordinator: [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator]];
	
	// Register context with the notification center
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
           selector:@selector(mergeChanges:)
               name:NSManagedObjectContextDidSaveNotification
             object:moc];
    
    //Send pending transactions
    NSError *error;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *strAuthorization = [userDef stringForKey:@"authorization"];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:[NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:moc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(status = nil) and (entityType = %@)",@"Facility"];
    [fr setPredicate:predicate];
    
    //NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"transactionType" ascending:YES];
    //[fr setSortDescriptors:[NSArray arrayWithObject:sd]];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"transactionDate" ascending:YES];
    [fr setSortDescriptors:[NSArray arrayWithObject:sd]];

    
    
    NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
    
    for (NSManagedObject *transaction in resultsArray)
    {
        if ([transaction valueForKey:@"offices"] != NULL)
        {
            NSManagedObject *office = [transaction valueForKey:@"offices"];
            NSMutableDictionary *newOffice = [[NSMutableDictionary alloc] init];
            
            if (([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"] && ([office valueForKey:@"rowId"] != NULL)) ||
                ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Create"]))
            {
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"]) {
                    if ([office valueForKey:@"rowId"] != NULL)
                        [newOffice setValue:[office valueForKey:@"rowId"] forKey:@"Id"];
                    if ([office valueForKey:@"integrationId"] != NULL)
                        [newOffice setValue:[office valueForKey:@"integrationId"] forKey:@"IntegrationId"];
                }
                if ([office valueForKey:@"officeType"] != NULL)
                    [newOffice setValue:[office valueForKey:@"officeType"] forKey:@"FacilityType"];
                if ([office valueForKey:@"name"] != NULL)
                    [newOffice setValue:[office valueForKey:@"name"] forKey:@"Name"];
                if ([office valueForKey:@"addr"] != NULL)
                    [newOffice setValue:[office valueForKey:@"addr"] forKey:@"Address1"];
                if ([office valueForKey:@"addr2"] != NULL)
                    [newOffice setValue:[office valueForKey:@"addr2"] forKey:@"Address2"];
                if ([office valueForKey:@"city"] != NULL)
                    [newOffice setValue:[office valueForKey:@"city"] forKey:@"City"];
                if ([office valueForKey:@"state"] != NULL)
                    [newOffice setValue:[office valueForKey:@"state"] forKey:@"State"];
                if ([office valueForKey:@"zipcode"] != NULL)
                    [newOffice setValue:[office valueForKey:@"zipcode"] forKey:@"PostalCode"];
                if ([office valueForKey:@"mainPhone"] != NULL)
                    [newOffice setValue:[office valueForKey:@"mainPhone"] forKey:@"MainPhone"];
                if ([office valueForKey:@"mainFax"] != NULL)
                    [newOffice setValue:[office valueForKey:@"mainFax"] forKey:@"MainFax"];
                if ([office valueForKey:@"annualBirths"] != NULL)
                    [newOffice setValue:[NSNumber numberWithInt:[[office valueForKey:@"annualBirths"] intValue]] forKey:@"AnnualBirths"];
                if ([office valueForKey:@"PercentCashPay"] != NULL)
                    [newOffice setValue:[NSNumber numberWithInt:[[office valueForKey:@"percentCashPay"] intValue]] forKey:@"PercentCashPay"];
                if ([office valueForKey:@"PercentMedicaid"] != NULL)
                    [newOffice setValue:[NSNumber numberWithInt:[[office valueForKey:@"percentMedicaid"] intValue]] forKey:@"PercentMedicaid"];
                if ([office valueForKey:@"notes"] != NULL)
                    [newOffice setValue:[office valueForKey:@"notes"] forKey:@"FacilityIssue"];
                if ([[[office valueForKey:@"kitContactId"] description] length] > 0)
                    [newOffice setValue:[office valueForKey:@"kitContactId"] forKey:@"KitContactId"];
                else
                    [newOffice setValue:@"" forKey:@"KitContactId"];
                
                if ([[[office valueForKey:@"kitContactFirstName"] description] length] > 0)
                    [newOffice setValue:[office valueForKey:@"kitContactFirstName"] forKey:@"KitContactFirstName"];
                else
                    [newOffice setValue:@"" forKey:@"KitContactFirstName"];

                if ([[[office valueForKey:@"kitContactLastName"] description] length] > 0)
                    [newOffice setValue:[office valueForKey:@"kitContactLastName"] forKey:@"KitContactLastName"];
                else
                    [newOffice setValue:@"" forKey:@"KitContactLastName"];

                if ([office valueForKey:@"territory"] != NULL)
                    [newOffice setValue:[office valueForKey:@"territory"] forKey:@"Territory"];
                if ([office valueForKey:@"country"] != NULL)
                    [newOffice setValue:[office valueForKey:@"country"] forKey:@"Country"];
                if ([office valueForKey:@"autoReceipt"] != NULL)
                    [newOffice setValue:[office valueForKey:@"autoReceipt"] forKey:@"AutoReceipt"];
                /*
                if ([office valueForKey:@"kitStockingStart"] != NULL)
                {
                    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
                    [timeFormatter setDateFormat:@"MM/dd/yyyy"];
                    //[timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    NSString *newTime = [timeFormatter stringFromDate:[[NSDate alloc]init] ];
                    [newOffice setValue:newTime forKey:@"KitStockingStart"];
                }
                */
                
                if ([office valueForKey:@"kitLocation"] != NULL)
                    [newOffice setValue:[office valueForKey:@"kitLocation"] forKey:@"KitStockingLocation"];
                if ([office valueForKey:@"kitThreshold"] != NULL)
                    [newOffice setValue:[NSNumber numberWithInt:[[office valueForKey:@"kitThreshold"] intValue]] forKey:@"KitThreshold"];
                if ([office valueForKey:@"chargesPatient"] != NULL)
                    [newOffice setValue:[office valueForKey:@"chargesPatient"] forKey:@"ChargesPatient"];
                if ([office valueForKey:@"amountCharged"] != NULL)
                    [newOffice setValue:[NSNumber numberWithInt:[[office valueForKey:@"amountCharged"] intValue]] forKey:@"AmountCharged"];
                if ([office valueForKey:@"competitor1"] != NULL)
                    [newOffice setValue:[office valueForKey:@"competitor1"] forKey:@"Competitor1"];
                if ([office valueForKey:@"competitor2"] != NULL)
                    [newOffice setValue:[office valueForKey:@"competitor2"] forKey:@"Competitor2"];
                if ([office valueForKey:@"inactiveReason"] != NULL)
                    [newOffice setValue:[office valueForKey:@"inactiveReason"] forKey:@"InactivateReason"];
                if ([office valueForKey:@"stockingOffice"] != NULL)
                    [newOffice setValue:[office valueForKey:@"stockingOffice"] forKey:@"KitStockingFlag"];
                if ([office valueForKey:@"kol"] != NULL)
                    [newOffice setValue:[office valueForKey:@"kol"] forKey:@"KeyAccountMarker"];

                [newOffice setValue:[transaction valueForKey:@"latitude"] forKey:@"SyncLatitude"];
                [newOffice setValue:[transaction valueForKey:@"longitude"] forKey:@"SyncLongitude"];
                long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
                [newOffice setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newOffice options:kNilOptions error:&error];
                
                NSMutableURLRequest *request;
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"]){
                    if ([[office valueForKey:@"status"] isEqualToString:@"Active"])
                    {
                        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLFacilityUpdate"];
                        
                        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                    }
                    else {
                        NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLFacilityDelete"];
                        
                        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                    }
                }
                else {
                    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLFacilityCreate"];
                    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                }
                
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
                [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody: jsonData];
                NSLog(@"%@", request);
                NSData *receivedData = [NSData data];
                NSHTTPURLResponse *response = nil;
                receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                // if its a success update the transaction record
                if ([error userInfo] == nil || [response statusCode] == 200)
                {
                    [transaction setValue:@"success" forKey:@"status"];
                    [moc save:nil];
                }
                else
                {
                    self.status = @"error";
                    self.errorMsg = [[NSString alloc] initWithFormat:@"%@",[error localizedDescription]];
                    [userDef setValue:@"Error" forKey:@"Status"];
                    //self.authenticationToken = @"error";
                    //self.errorReason = [[NSString alloc] initWithFormat:@"%@",[error localizedDescription]];
                }
            }
            else
            {
                [transaction setValue:@"invalid" forKey:@"status"];
                [moc save:nil];
            }
        }
        else
        {
            [transaction setValue:@"invalid" forKey:@"status"];
            [moc save:nil];
        }
        
    }
    NSLog(@"END Push Hospitals");
}
@end
