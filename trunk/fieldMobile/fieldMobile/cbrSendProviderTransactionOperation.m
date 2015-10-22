//
//  cbrSendProviderTransactionOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/6/13.
//
//
#define WCF_TIMEOUT 900.0

#import "cbrSendProviderTransactionOperation.h"
#import "cbrAppDelegate.h"

@implementation cbrSendProviderTransactionOperation
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
    NSLog(@"ENTER Push Providers");
    
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(status = nil) and (entityType = %@)",@"Provider"];
    [fr setPredicate:predicate];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"transactionDate" ascending:YES];
    [fr setSortDescriptors:[NSArray arrayWithObject:sd]];
    NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
    
    for (NSManagedObject *transaction in resultsArray)
    {
        if ([transaction valueForKey:@"providers"] != NULL)
        {
            NSManagedObject *provider = [transaction valueForKey:@"providers"];
            NSMutableDictionary *newProvider = [[NSMutableDictionary alloc] init];
            
            if (([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"] && ([provider valueForKey:@"rowId"] != NULL)) ||
                ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Create"]))
            {
                
                
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"])
                {
                    if ([provider valueForKey:@"rowId"] != NULL)
                        [newProvider setValue:[provider valueForKey:@"rowId"] forKey:@"RowId"];
                }
                
                if ([provider valueForKey:@"facilityId"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"facilityId"] forKey:@"FacilityId"];
                if ([provider valueForKey:@"personUID"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"personUID"] forKey:@"ProviderId"];
                if ([provider valueForKey:@"firstName"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"firstName"] forKey:@"FirstName"];
                if ([provider valueForKey:@"lastName"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"lastName"] forKey:@"LastName"];
                if ([provider valueForKey:@"emailPrimary"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"emailPrimary"] forKey:@"EmailAddress"];
                if ([provider valueForKey:@"category"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"category"] forKey:@"ProviderClassification"];
                if ([provider valueForKey:@"credential"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"credential"] forKey:@"ProviderCredential"];
                if ([provider valueForKey:@"momentumRating"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"momentumRating"] forKey:@"MomentumRating"];
                if ([provider valueForKey:@"status"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"status"] forKey:@"ProviderStatus"];
                if ([provider valueForKey:@"monthlyBirth"] != NULL)
                    [newProvider setValue:[NSNumber numberWithInt:[[provider valueForKey:@"monthlyBirth"] intValue]] forKey:@"MonthlyBirths"];
                
                if ([provider valueForKey:@"keyAccountMarker"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"keyAccountMarker"] forKey:@"KeyAccountMarker"];
                if ([[[provider valueForKey:@"birthYear"] description] length] > 0 && [[provider valueForKey:@"birthYear"] intValue] > 0)
                    [newProvider setValue:[NSNumber numberWithInt:[[provider valueForKey:@"birthYear"] intValue]] forKey:@"DrBirthYear"];
                if ([provider valueForKey:@"salesContinuum"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"salesContinuum"] forKey:@"SalesContinuum"];
                if ([provider valueForKey:@"providerType"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"providerType"] forKey:@"ProviderType"];
                if ([provider valueForKey:@"pfOfficeHours"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"pfOfficeHours"] forKey:@"PFOfficeHours"];

                
                if ([provider valueForKey:@"pwaLogin"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"pwaLogin"] forKey:@"PWALogin"];
                if ([provider valueForKey:@"sendPWAInvitation"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"sendPWAInvitation"] forKey:@"SendPWAInvitation"];
                if ([provider valueForKey:@"pwaResetPwdFlag"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"pwaResetPwdFlag"] forKey:@"PWAResetPasswordFlag"];
                if ([provider valueForKey:@"noEmail"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"noEmail"] forKey:@"DoNotEmail"];
                if ([provider valueForKey:@"noFax"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"noFax"] forKey:@"DoNotFax"];
                if ([provider valueForKey:@"issues"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"issues"] forKey:@"ProviderIssue"];
                if ([provider valueForKey:@"notes"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"notes"] forKey:@"Notes"];
                if ([provider valueForKey:@"stockingDoc"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"stockingDoc"] forKey:@"KitStockingFlag"];
                if ([provider valueForKey:@"worksAtStockingHospital"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"worksAtStockingHospital"] forKey:@"WorksAtStockingHospital"];
                if ([provider valueForKey:@"inactiveReason"] != NULL)
                    [newProvider setValue:[provider valueForKey:@"inactiveReason"] forKey:@"InactivateReason"];
                if ([provider valueForKey:@"facilityId"] != NULL)
                    [newProvider setValue:[NSString stringWithFormat:@"%@", [provider valueForKey:@"facilityId"]] forKey:@"FacilityId"];
                if ([provider valueForKey:@"facilityIntegrationId"] != NULL)
                    [newProvider setValue:[NSString stringWithFormat:@"%@", [provider valueForKey:@"facilityIntegrationId"]] forKey:@"FacilityIntegrationId"];
                [newProvider setValue:[transaction valueForKey:@"latitude"] forKey:@"SyncLatitude"];
                [newProvider setValue:[transaction valueForKey:@"longitude"] forKey:@"SyncLongitude"];
                long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
                [newProvider setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
                
                
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newProvider options:kNilOptions error:&error];
                NSMutableURLRequest *request;
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"]){
                    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLProviderUpdate"];
                    
                    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                }
                else {
                    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLProviderCreate"];
                    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                }
                
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
    
   // [moc reset];
    	
	// Flag execution complete
    self.done = TRUE;
    NSLog(@"END Push Providers");

}
@end
