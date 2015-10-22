//
//  cbrSendActivityTransactionOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//
#define WCF_TIMEOUT 900.0
#import "cbrSendActivityTransactionOperation.h"
#import "cbrAppDelegate.h"


@implementation cbrSendActivityTransactionOperation

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
    NSLog(@"Enter Push Activities");
    NSError *error;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *strAuthorization = [userDef stringForKey:@"authorization"];
    // actions
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:moc];
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    
    [fr setEntity:entity];
    
    // Set example predicate and sort orderings..
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(status = nil) and (entityType = %@)",@"Action"];
    [fr setPredicate:predicate];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"transactionDate" ascending:YES];
    [fr setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
    
    for (NSManagedObject *transaction in resultsArray)
    {
        if ([transaction valueForKey:@"actions"] != NULL)
        {
            NSManagedObject *action = [transaction valueForKey:@"actions"];
            NSMutableDictionary *newActivity = [[NSMutableDictionary alloc] init];
            
            if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Create"] ||
                ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Update"] && [action valueForKey:@"rowId"] != NULL))
            {
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Create"])
                {
                    if ([action valueForKey:@"contactId"] != NULL)
                        [newActivity setValue:[action valueForKey:@"contactId"] forKey:@"ContactRowId"];
                    if ([action valueForKey:@"note"] != NULL)
                        [newActivity setValue:[action valueForKey:@"note"] forKey:@"Description"];
                    if ([action valueForKey:@"descriptionType"] != NULL)
                        [newActivity setValue:[action valueForKey:@"descriptionType"] forKey:@"DescriptionType"];
                    if ([action valueForKey:@"officeId"] != NULL)
                        [newActivity setValue:[action valueForKey:@"officeId"] forKey:@"FacilityRowId"];
                    if ([action valueForKey:@"subType"] != NULL)
                        [newActivity setValue:[action valueForKey:@"subType"] forKey:@"SubType"];
                    if ([action valueForKey:@"type"] != NULL)
                        [newActivity setValue:[action valueForKey:@"type"] forKey:@"Type"];
                }
                else
                {
                    if ([action valueForKey:@"rowId"] != NULL)
                        [newActivity setValue:[action valueForKey:@"rowId"] forKey:@"RowId"];
                    if ([action valueForKey:@"integrationId"] != NULL)
                        [newActivity setValue:[action valueForKey:@"integrationId"] forKey:@"IntegrationId"];
                }
                if ([action valueForKey:@"status"] != NULL)
                    [newActivity setValue:[action valueForKey:@"status"] forKey:@"Status"];
                if ([action valueForKey:@"comments"] != NULL)
                    [newActivity setValue:[action valueForKey:@"comments"] forKey:@"Comments"];
                if ([action valueForKey:@"longNotes"] != NULL)
                    [newActivity setValue:[action valueForKey:@"longNotes"] forKey:@"Notes"];
                
                
                if ([action valueForKey:@"dueDate"] != NULL)
                {
                    long long dueDtLong = [[action valueForKey:@"dueDate"] timeIntervalSince1970] * 1000;
                    [newActivity setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dueDtLong] forKey:@"CompleteByDate"];
                    [newActivity setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dueDtLong] forKey:@"DueDate"];
                }
                if ([action valueForKey:@"actionDate"] != NULL)
                {
                    long long actionDtLong = [[action valueForKey:@"actionDate"] timeIntervalSince1970] * 1000;
                    [newActivity setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",actionDtLong] forKey:@"CompletedDate"];
                }
                [newActivity setValue:[transaction valueForKey:@"latitude"] forKey:@"Latitude"];
                [newActivity setValue:[transaction valueForKey:@"longitude"] forKey:@"Longitude"];
                long long dateDtLong = [[transaction valueForKey:@"transactionDate"] timeIntervalSince1970] * 1000;
                [newActivity setValue:[[NSString alloc] initWithFormat:@"/Date(%qi-0000)/",dateDtLong] forKey:@"TransactionDate"];
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newActivity options:kNilOptions error:&error];
                
                NSMutableURLRequest *request;
                if ([[transaction valueForKey:@"transactionType"] isEqualToString:@"Create"])
                {
                    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLActivityCreate"];
                    
                    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                }
                else
                {
                    NSString *className = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"cbrURLActivityUpdate"];
                    
                    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:className] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WCF_TIMEOUT];
                }
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:strAuthorization forHTTPHeaderField:@"Authorization"];
                [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody: jsonData];
                
                NSHTTPURLResponse *response = nil;
                NSData *receivedData = [NSData data];
                
                receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                //NSDictionary *dict = [response allHeaderFields];
                //NSLog(@"Status code: %d",[response statusCode]);
                //NSLog(@"Headers:\n %@",dict.description);
                //NSLog(@"Error: %@",error.description);
                
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
    NSLog(@"End Push Activities");
    

}
@end
