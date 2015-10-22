//
//  cbrSendContactTransactionOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//


#define WCF_TIMEOUT 900.0
#import "cbrSendContactTransactionOperation.h"
#import "cbrAppDelegate.h"

@implementation cbrSendContactTransactionOperation
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
    NSLog(@"ENTER Push Contacts");
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(status = nil) and (entityType = %@)",@"Contact"];
    [fr setPredicate:predicate];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"transactionDate" ascending:YES];
    [fr setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
    
    for (NSManagedObject *transaction in resultsArray)
    {
        if ([transaction valueForKey:@"contacts"] != NULL)
        {
            NSManagedObject *contact = [transaction valueForKey:@"contacts"];
            NSMutableDictionary *newContact = [[NSMutableDictionary alloc] init];
            if (([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"] && ([contact valueForKey:@"rowId"] != NULL)) ||
                ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Create"]))
            {
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"])
                {
                    if ([contact valueForKey:@"rowId"] != NULL)
                        [newContact setValue:[contact valueForKey:@"rowId"] forKey:@"RowId"];
                    if ([contact valueForKey:@"intersectId"] != NULL)
                        [newContact setValue:[contact valueForKey:@"intersectId"] forKey:@"Intersect"];
                }
                
                if ([contact valueForKey:@"firstName"] != NULL)
                    [newContact setValue:[contact valueForKey:@"firstName"] forKey:@"FirstName"];
                if ([contact valueForKey:@"lastName"] != NULL)
                    [newContact setValue:[contact valueForKey:@"lastName"] forKey:@"LastName"];
                if ([contact valueForKey:@"momentumRating"] != NULL)
                    [newContact setValue:[contact valueForKey:@"momentumRating"] forKey:@"MomentumRating"];
                if ([contact valueForKey:@"role"] != NULL)
                    [newContact setValue:[contact valueForKey:@"role"] forKey:@"Role"];
                if ([contact valueForKey:@"status"] != NULL)
                    [newContact setValue:[contact valueForKey:@"status"] forKey:@"Status"];
                if ([contact valueForKey:@"officeId"] != NULL)
                    [newContact setValue:[contact valueForKey:@"officeId"] forKey:@"FacilityRowId"];
                if ([contact valueForKey:@"email"] != NULL)
                    [newContact setValue:[contact valueForKey:@"email"] forKey:@"EmailAddress"];
                if ([contact valueForKey:@"kitStockingFlag"] != NULL)
                    [newContact setValue:[contact valueForKey:@"kitStockingFlag"] forKey:@"KitStockingFlag"];
                if ([contact valueForKey:@"officeHours"] != NULL)
                    [newContact setValue:[contact valueForKey:@"officeHours"] forKey:@"PFOfficeHours"];
                if ([contact valueForKey:@"kol"] != NULL)
                    [newContact setValue:[contact valueForKey:@"kol"] forKey:@"KOLFlag"];
                if ([contact valueForKey:@"continuum"] != NULL)
                    [newContact setValue:[contact valueForKey:@"continuum"] forKey:@"ContactContinuum"];
                if ([contact valueForKey:@"contactOffice"] != NULL)
                {
                    NSManagedObject *office = [contact valueForKey:@"contactOffice"];
                    [newContact setValue:[office valueForKey:@"officeType"] forKey:@"FacilityType"];
                }
                [newContact setValue:[transaction valueForKey:@"latitude"] forKey:@"Latitude"];
                [newContact setValue:[transaction valueForKey:@"longitude"] forKey:@"Longitude"];
                long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
                [newContact setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
                
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newContact options:kNilOptions error:&error];
                NSMutableURLRequest *request;
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"]){
                    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLFacilityContactUpdate"];
                    
                    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                }
                else {
                    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLFacilityContactCreate"];
                    
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
    NSLog(@"END Push Contacts");
}

@end
