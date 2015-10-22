//
//  cbrSendOrderTransactionOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//
#define WCF_TIMEOUT 900.0
#import "cbrSendOrderTransactionOperation.h"
#import "cbrAppDelegate.h"

@implementation cbrSendOrderTransactionOperation
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
    NSLog(@"ENTER Push Order");
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
    NSString *rmId = [userDef stringForKey:@"rmRowId"];
    NSString *rmFirstName = [userDef stringForKey:@"rmFirstName"];
    NSString *rmLastName = [userDef stringForKey:@"rmLastName"];
    NSString *rmStorageId = [userDef stringForKey:@"rmStorageId"];
    NSString *rmStorageFacility = [userDef stringForKey:@"rmStorage"];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:[NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:moc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(status = nil) and (entityType = %@)",@"Order"];
    [fr setPredicate:predicate];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"transactionDate" ascending:YES];
    [fr setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
    
    for (NSManagedObject *transaction in resultsArray)
    {
        if ([transaction valueForKey:@"orders"] != NULL)
        {
            NSManagedObject *order = [transaction valueForKey:@"orders"];
            NSMutableDictionary *newOrder = [[NSMutableDictionary alloc] init];
            
            //if ([order valueForKey:@"rowId"] != NULL)
            //    [newOrder setValue:[order valueForKey:@"rowId"] forKey:@"rowId"];
            [newOrder setValue:rmStorageId forKey:@"FacilityId"];
            [newOrder setValue:rmStorageFacility forKey:@"FacilityName"];
            [newOrder setValue:rmId forKey:@"ContactRowId"];
            [newOrder setValue:rmFirstName forKey:@"ContactFirstName"];
            [newOrder setValue:rmLastName forKey:@"ContactLastName"];
            [newOrder setValue:[order valueForKey:@"quantityRequested"] forKey:@"Quantity"];
            [newOrder setValue:[transaction valueForKey:@"latitude"] forKey:@"Latitude"];
            [newOrder setValue:[transaction valueForKey:@"longitude"] forKey:@"Longitude"];
            long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
            [newOrder setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
            
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newOrder options:kNilOptions error:&error];
            NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLOrderKits"];
            
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
    }
    NSLog(@"END Push Order");
}

@end
