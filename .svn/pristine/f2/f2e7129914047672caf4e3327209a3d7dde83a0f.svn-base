//
//  cbrSendKitTransactionOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//
#define WCF_TIMEOUT 900.0
#import "cbrSendKitTransactionOperation.h"
#import "cbrAppDelegate.h"

@implementation cbrSendKitTransactionOperation
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


-(void) mainOLD
{
    NSLog(@"ENTER Push Kits");
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(status = nil) and (entityType = %@)",@"Kit"];
    [fr setPredicate:predicate];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"transactionType" ascending:YES];
    [fr setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
    
    for (NSManagedObject *transaction in resultsArray)
    {
        if ([transaction valueForKey:@"kits"] != NULL)
        {
            NSManagedObject *kit = [transaction valueForKey:@"kits"];
            NSMutableDictionary *newKit = [[NSMutableDictionary alloc] init];
            
            if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Transfer"] || [[transaction valueForKey:@"transactionType"] isEqualToString:@"Inventory - Lost"] || [[transaction valueForKey:@"transactionType"] isEqualToString:@"Inventory - Exists"]) {
                if ([kit valueForKey:@"status"] != NULL)
                    [newKit setValue:[kit valueForKey:@"status"] forKey:@"Status"];
                //if ([kit valueForKey:@"assignedOfficeId"] != NULL) {
                [newKit setValue:[kit valueForKey:@"assignedOfficeId"] forKey:@"AssignedToFacility"];
                [newKit setValue:[kit valueForKey:@"assignedOfficeId"] forKey:@"FacilityRowId"];
                //}
                //if ([kit valueForKey:@"assignedContactId"] != NULL){
                [newKit setValue:[kit valueForKey:@"assignedContactId"] forKey:@"AssignedToContact"];
                [newKit setValue:[kit valueForKey:@"assignedContactId"] forKey:@"ContactRowId"];
                [newKit setValue:[kit valueForKey:@"assignedContactFirstName"] forKey:@"AssignedToContactFirstName"];
                [newKit setValue:[kit valueForKey:@"assignedContactLastName"] forKey:@"AssignedToContactLastName"];
                
                //}
                if ([kit valueForKey:@"depositId"] != NULL)
                    [newKit setValue:[kit valueForKey:@"depositId"] forKey:@"DepositId"];
                if ([kit valueForKey:@"rowId"] != NULL)
                    [newKit setValue:[kit valueForKey:@"rowId"] forKey:@"RowId"];
                [newKit setValue:[transaction valueForKey:@"latitude"] forKey:@"Latitude"];
                [newKit setValue:[transaction valueForKey:@"longitude"] forKey:@"Longitude"];
                long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
                [newKit setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
            }
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newKit options:kNilOptions error:&error];
            NSMutableURLRequest *request;
            if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Transfer"] || [[transaction valueForKey:@"transactionType"] isEqualToString:@"Inventory - Lost"] || [[transaction valueForKey:@"transactionType"] isEqualToString:@"Inventory - Exists"]){
                NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLAssetUpdate"];
                
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
                [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody: jsonData];
                
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
        }
        else
        {
            [transaction setValue:@"invalid" forKey:@"status"];
            [moc save:nil];
        }
    }
    NSLog(@"END Push Kits");
}



-(void) main
{
    NSLog(@"ENTER Push Kits");
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(status = nil) and (entityType = %@)",@"Kit"];
    [fr setPredicate:predicate];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"transactionDate" ascending:YES];
    [fr setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
    NSData *jsonData;
    
    
    for (NSManagedObject *transaction in resultsArray)
    {
        if (([[transaction valueForKey:@"transactionType"] isEqualToString:@"Transfer"]) ||
            ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Receive"]) ||
            ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Count"]))
        {
            NSString *className;
            if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Transfer"])
                className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLTransferKit"];
            else if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Receive"])
                className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLReceiveKit"];
            else if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Count"])
                className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLCountKit"];

            if ([transaction valueForKey:@"kits"] == NULL && [transaction valueForKey:@"offices"] != NULL)
            {
                className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLCountKit"];
                
                NSFetchRequest *frOfc = [[NSFetchRequest alloc] init];
                NSManagedObject *ofc = [transaction valueForKey:@"offices"];
                NSString *ofcId = [ofc valueForKey:@"rowId"];
                
                NSEntityDescription *kitEntity = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
                [frOfc setEntity:kitEntity];
                NSPredicate *kitPredicate = [NSPredicate predicateWithFormat: @"(assignedOfficeId = %@)",ofcId];
                [frOfc setPredicate:kitPredicate];
                
                NSArray *kitArray = [moc executeFetchRequest:frOfc error:nil];
                NSMutableDictionary *newOfc = [[NSMutableDictionary alloc] init];
                NSMutableArray *countedKits = [[NSMutableArray alloc]init];
                for(NSManagedObject *kit in kitArray)
                {
                    NSMutableDictionary *newKit = [[NSMutableDictionary alloc] init];
                    [newKit setValue:[kit valueForKey:@"depositId"] forKey:@"KitSerial"];
                    if ([[kit valueForKey:@"status"] isEqualToString:@"Active"])
                        [newKit setValue:@"1" forKey:@"KitQuantity"];
                    else
                        [newKit setValue:@"0" forKey:@"KitQuantity"];
                    [countedKits addObject:newKit];
                }
                [newOfc setValue:ofcId forKey:@"FacilityId"];
                [newOfc setValue:[userDef stringForKey:@"userId"] forKey:@"UserId"];
                [newOfc setValue:countedKits forKey:@"KitList"];
                [newOfc setValue:[transaction valueForKey:@"latitude"] forKey:@"Latitude"];
                [newOfc setValue:[transaction valueForKey:@"longitude"] forKey:@"Longitude"];
                long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
                [newOfc setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
                jsonData = [NSJSONSerialization dataWithJSONObject:newOfc options:kNilOptions error:&error];
                
            }
            else if ([transaction valueForKey:@"kits"] != NULL)
            {
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Transfer"])
                    className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLTransferKit"];
                else if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Receive"])
                    className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLReceiveKit"];

                NSManagedObject *kit = [transaction valueForKey:@"kits"];
                NSMutableDictionary *newKit = [[NSMutableDictionary alloc] init];
                
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Transfer"]) {
                    [newKit setValue:[kit valueForKey:@"depositId"] forKey:@"DepositId"];
                    [newKit setValue:[kit valueForKey:@"assignedOfficeId"] forKey:@"FacilityId"];
                    [newKit setValue:[transaction valueForKey:@"latitude"] forKey:@"Latitude"];
                    [newKit setValue:[transaction valueForKey:@"longitude"] forKey:@"Longitude"];
                    long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
                    [newKit setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
                }
                else if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Receive"]) {
                    [newKit setValue:[kit valueForKey:@"depositId"] forKey:@"DepositId"];
                    [newKit setValue:[kit valueForKey:@"boxNumber"] forKey:@"BoxId"];
                    [newKit setValue:[transaction valueForKey:@"latitude"] forKey:@"Latitude"];
                    [newKit setValue:[transaction valueForKey:@"longitude"] forKey:@"Longitude"];
                    long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
                    [newKit setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
                }
                jsonData = [NSJSONSerialization dataWithJSONObject:newKit options:kNilOptions error:&error];
            }
            NSMutableURLRequest *request;
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
            [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody: jsonData];
            
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
    NSLog(@"END Push Kits");
}
@end
