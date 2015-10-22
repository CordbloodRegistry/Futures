//
//  cbrLoadStatOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/11/13.
//
//

#import "cbrLoadStatOperation.h"
#import "cbrAppDelegate.h"
#import "FUP.h"

@implementation cbrLoadStatOperation
@synthesize done;
@synthesize status;
@synthesize errorMsg;
@synthesize syncNextFUP;

//- (void)mergeChanges:(NSNotification *)notification
//{
//	NSManagedObjectContext *mainContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
//    
//	// Merge changes into the main context on the main thread
//	[mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
//                                  withObject:notification
//                               waitUntilDone:YES];
//}
-(void) main
{
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    self.syncNextFUP = [[NSMutableArray alloc] init];
    NSLog(@"ENTER Load Stats");
    // Create context on background thread
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	[moc setUndoManager:nil];
	[moc setPersistentStoreCoordinator: [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator]];
	
	// Register context with the notification center
//	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//	[nc addObserver:self
//           selector:@selector(mergeChanges:)
//               name:NSManagedObjectContextDidSaveNotification
//             object:moc];
//    
    
    if(![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"])
    {
        [self loadFUP:moc];
        [self linkFUPandStats:moc];
    }
}

-(void) loadFUP:(NSManagedObjectContext *)moc
{
    NSError *error;
    NSDate *today = [NSDate date];
    int daysToAdd = 180;
    NSDate *agingDate = [today dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    //remove all FUP
    [self.syncNextFUP removeAllObjects];
    
    //Load FUP based on assets
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSArray *objects = [moc executeFetchRequest:request error:&error];
    for (NSManagedObject *item in objects)
    {
        if ([item valueForKey:@"expirationDate"] != [NSNull null]) {
            NSDate *expDate = [item valueForKey:@"expirationDate"];
            if (([agingDate compare:expDate] == NSOrderedDescending)  &&
                (![[item valueForKey:@"status"] isEqualToString:@"Inactive/Lost"]))
            {
                FUP *entry = [[FUP alloc] init];
                [entry setValue:expDate forKey:@"fupDate"];
                
                [entry setValue:[item valueForKey:@"assignedContactId"] forKey:@"contactId"];
                [entry setValue:[item valueForKey:@"assignedOfficeId"] forKey:@"officeId"];
                [entry setValue:@"Kits" forKey:@"entityType"];
                [self.syncNextFUP addObject:entry];
                //NSLog(@"asset %@ %@", [item valueForKey:@"assignedContactId"], [item valueForKey:@"assignedOfficeId"]);
            }
        }
    }
    
    //Load FUP based on activities
    entityDesc = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];
    request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    objects = [moc executeFetchRequest:request error:&error];
    for (NSManagedObject *item in objects)
    {
        if ([item valueForKey:@"status"] != [NSNull null]) {
            if ([(NSString*)[item valueForKey:@"status"] isEqualToString:@"Open"])
            {
                bool isNote  = ([item valueForKey:@"descriptionType"] != [NSNull null]);
                if (isNote) {
                    if (![[item valueForKey:@"descriptionType"] isEqualToString:@"Note from RM"]) {
                        isNote = NO;
                    }
                }
                if (!isNote)
                {
                    
                    if ([item valueForKey:@"dueDate"] != [NSNull null])
                    {
                        NSDate *dueDate = [item valueForKey:@"dueDate"];
                        FUP *entry = [[FUP alloc] init];
                        [entry setValue:dueDate forKey:@"fupDate"];
                        [entry setValue:[item valueForKey:@"contactId"] forKey:@"contactId"];
                        [entry setValue:[item valueForKey:@"officeId"] forKey:@"officeId"];
                        [entry setValue:@"Actions" forKey:@"entityType"];
                        [self.syncNextFUP addObject:entry];
                        //NSLog(@"activity %@ %@", [item valueForKey:@"contactId"], [item valueForKey:@"officeId"]);
                    }
                }
            }
        }
    }
    
    // sort follup date array so that it can be used for contacts and facilities
    [self.syncNextFUP sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"fupDate" ascending:TRUE]]];
    
}


- (void)linkFUPandStats:(NSManagedObjectContext *)managedObject
{
    NSLog(@"ENTER linkFUPandStats");
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filenamePath = [NSString stringWithString:[filePaths objectAtIndex:0]];
    NSString *filenamePathProviderStats = [filenamePath stringByAppendingString:@"/providerStats.json"];
    NSString *filenamePathFacilityStats = [filenamePath stringByAppendingString:@"/facilityStats.json"];
    
    NSData *providerStats = [[NSData alloc] initWithContentsOfFile:filenamePathProviderStats];
    NSData *facilityStats = [[NSData alloc] initWithContentsOfFile:filenamePathFacilityStats];
    NSError *error;
    NSUInteger count = 0, LOOP_LIMIT = 200;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:providerStats options:kNilOptions error:&error];
    
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Providers" inManagedObjectContext:managedObject];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //update FUP for Providers
    NSArray *objects = [managedObject executeFetchRequest:request error:&error];
    if (error)
        NSLog(@"Error Descr %@",error.localizedDescription);
    if(!error)
    {
        //[managedObject lock];
        for (NSManagedObject *item in objects)
        {
            if ([item valueForKey:@"rowId"] != [NSNull null])
            {
                //NSLog(@"Provider %d- %@ %@ %@", count,  [item valueForKey:@"rowId"], [item valueForKey:@"firstName"], [item valueForKey:@"lastName"]);
                // load nextFUDate
                NSArray *fupArray = [self.syncNextFUP filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contactId <> NULL AND contactId = %@",[item valueForKey:@"rowId"]]];
                if ([fupArray count] > 0)
                {
                    [item setValue:[[fupArray objectAtIndex:0] valueForKey:@"fupDate"] forKey:@"nextFUDate"];
                }
                else if ([item valueForKey:@"FacilityId"] != [NSNull null])
                {
                    NSArray *fupArray = [self.syncNextFUP filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"officeId = %@ and entityType = %@",[item valueForKey:@"facilityId"], @"Kits"]];
                    if ([fupArray count] > 0)
                    {
                        [item setValue:[[fupArray objectAtIndex:0] valueForKey:@"fupDate"] forKey:@"nextFUDate"];
                    }
                    else
                    {
                        [item setValue:nil forKey:@"nextFUDate"];
                    }
                }
                

                NSArray* providers = [json objectForKey:@"ProviderStatList"];
                providers = [providers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"RowId = %@", [item valueForKey:@"rowId"]]];
                if ([providers count] > 0)
                {
                    NSEnumerator *enumerator = [providers objectEnumerator];
                    NSDictionary *provider = (NSDictionary*)[enumerator nextObject];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                    NSDate *dateFromString = [[NSDate alloc] init];
                    
                    if ([provider valueForKey:@"PWALastLogin"] != [NSNull null])
                    {
                        dateFromString = [dateFormatter dateFromString:[[NSString alloc] initWithFormat:@"%@",[provider valueForKey:@"PWALastLogin"]]];
                        [item setValue:dateFromString forKey:@"pwaLastLoginDate"];
                    }
                    if ([provider valueForKey:@"Turn"] != [NSNull null])
                        [item setValue:[NSNumber numberWithFloat:[[provider valueForKey:@"Turn"] floatValue]] forKey:@"turn"];
                    
                    if ([provider valueForKey:@"ACD_Oppty_Pct"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"ACD_Oppty_Pct"] intValue]] forKey:@"aCDvsTotal"];
     
                    if ([provider valueForKey:@"CB_CT_Ratio"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"CB_CT_Ratio"] intValue]] forKey:@"cTCB_Ratio"];
                    
                    if ([provider valueForKey:@"Educated_Pct"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"Educated_Pct"] intValue]] forKey:@"educated_pct"];
                    
                    if ([provider valueForKey:@"Educated"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"Educated"] intValue]] forKey:@"educated"];
                    
                    if ([provider valueForKey:@"New_Enroll_Pct"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"New_Enroll_Pct"] intValue]] forKey:@"newEnrollments"];
                    
                    if ([provider valueForKey:@"Total_CB"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"Total_CB"] intValue]] forKey:@"totalCBStorages"];
                    
                    if ([provider valueForKey:@"Total_CT"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"Total_CT"] intValue]] forKey:@"totalCTStorages"];
                    
                    if ([provider valueForKey:@"Total_Enroll"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"Total_Enroll"] intValue]] forKey:@"total_Enrollments"];
                    
                    if ([provider valueForKey:@"Total_Optys"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"Total_Optys"] intValue]] forKey:@"totalOpptys"];
                    
                    if ([provider valueForKey:@"Penetration_Rate"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"Penetration_Rate"] intValue]] forKey:@"penetrationRate"];
                    if ([provider valueForKey:@"Calls"] != [NSNull null])
                        [item setValue:[NSNumber numberWithInt:[[provider valueForKey:@"Calls"] intValue]] forKey:@"calls"];
                  
                }
                
                
            }
            // SAVE IN BATCHES
            count++;
            if (count % LOOP_LIMIT == 0) {
                [managedObject save:&error];
                if (error)
                    NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
                //[managedObject reset];
                if (error)
                    NSLog(@"Error Descr %@",error.localizedDescription);
            }
        }
        // Save any remaining records
        if (count != 0) {
            error = nil;
            [managedObject save:&error];
            if (error)
                NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
            //[managedObject reset];
        }
    }
    NSLog(@"ENTER linkFUPandStats Hospitals");
    //Update FUP for Hospitals
    count = 0;
    entityDesc = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:managedObject];
    request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    json = [NSJSONSerialization JSONObjectWithData:facilityStats options:kNilOptions error:&error];
    
    objects = [managedObject executeFetchRequest:request error:&error];
    if (error)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
        NSLog(@"Error Descr %@",error.localizedDescription);
    }
    if(!error)
    {
        for (NSManagedObject *item in objects)
        {
            if ([item valueForKey:@"rowId"] != [NSNull null]) {
                // load nextFUDate
                //NSLog(@"Facility %d -  %@ %@",  count, [item valueForKey:@"rowId"], [item valueForKey:@"name"]);
                //if ([[item valueForKey:@"rowId"] isEqualToString:@"1-75-5"])
                //{
                //    NSLog(@"HERE");
               // }
                NSArray *fupArray = [self.syncNextFUP filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"officeId <> NULL AND officeId = %@",[item valueForKey:@"rowId"]]];
                if ([fupArray count] > 0) {
                    [item setValue:[[fupArray objectAtIndex:0] valueForKey:@"fupDate"] forKey:@"nextFUDate"];
                }
                else{
                    [item setValue:nil forKey:@"nextFUDate"];
                }
                
                NSArray* facilityStats = [json objectForKey:@"FacilityStatList"];
                facilityStats = [facilityStats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"RowId = %@", [item valueForKey:@"rowId"]]];
                if ([facilityStats count] > 0)
                {
                    NSEnumerator *enumerator = [facilityStats objectEnumerator];
                    NSDictionary *facStat = (NSDictionary*)[enumerator nextObject];
                    
                    if ([facStat valueForKey:@"Turn"] != [NSNull null])
                        [item setValue:[NSNumber numberWithFloat:[[facStat valueForKey:@"Turn"] floatValue]] forKey:@"turn"];
                    
                    if ([facStat valueForKey:@"Enrollments"] != [NSNull null])
                        [item setValue:[NSNumber numberWithFloat:[[facStat valueForKey:@"Enrollments"] floatValue]] forKey:@"numEnrollments"];
                    if ([facStat valueForKey:@"Calls"] != [NSNull null])
                        [item setValue:[NSNumber numberWithFloat:[[facStat valueForKey:@"Calls"] floatValue]] forKey:@"calls"];
                    
                }
            }
            // SAVE IN BATCHES
            count++;
            if (count % LOOP_LIMIT == 0) {
                [managedObject save:&error];
                if (error)
                    NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
                //[managedObject reset];
                if (error)
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
                    NSLog(@"Error Descr %@",error.localizedDescription);
                }
            }
        }
        // Save any remaining records
        if (count != 0) {
            error = nil;
            [managedObject save:&error];
            if (error)
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
                NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
            }
            //[managedObject reset];
        }
        //[managedObject unlock];
    }
    NSLog(@"end Load Stats");
    
}

#pragma mark - Uncaught Exception Handler
static NSString *GetBugReport()
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dir = [paths objectAtIndex:0];
	return [dir stringByAppendingPathComponent:@"bug.txt"];
}

static void UncaughtExceptionHandler(NSException *exception)
{
	
	NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:4096];
	
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userName = [[userDef stringForKey:@"userId"] uppercaseString];
    
	NSBundle *bundle = [NSBundle mainBundle];
	[buffer appendFormat:@"%@ version %@<BR><BR>",
     [bundle objectForInfoDictionaryKey:@"CFBundleName"],
     [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
	[buffer appendString:@"Uncaught Exception<BR>"];
	[buffer appendFormat:@"Username: %@<BR>",userName];
	[buffer appendFormat:@"Exception Name: %@<BR>",[exception name]];
	[buffer appendFormat:@"Exception Reason: %@<BR>",[exception reason]];
	[buffer appendString:@"Stack trace:<BR><BR>"];
	//for (int i = 0; i < frameCount; ++i) {
	//	[buffer appendFormat:@"%4d - %s<BR>",i,symbols[i]];
	//}
	[buffer appendFormat:@"<BR><BR>%@", [exception description]];
	[buffer appendFormat:@"<BR><BR>%@", [exception callStackReturnAddresses]];
	[buffer appendFormat:@"<BR><BR>%@", [exception callStackSymbols]];
	/*
	 *	Get the error file to write this to
	 */
	
	NSError *err;
	[buffer writeToFile:GetBugReport() atomically:YES encoding:NSUTF8StringEncoding error:&err];
	NSLog(@"Error %@",buffer);
}


@end
