//
//  cbrLoadActivityOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//

#import "cbrLoadActivityOperation.h"
#import "cbrAppDelegate.h"

@implementation cbrLoadActivityOperation
@synthesize done;
@synthesize status;
@synthesize errorMsg;


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
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filenamePath = [NSString stringWithString:[filePaths objectAtIndex:0]];
    NSString *filename = [filenamePath stringByAppendingString:@"/activities.json"];
    
    NSLog(@"ENTER Load Activity");
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
    
    
    NSData *responseData = [[NSData alloc] initWithContentsOfFile:filename];
    NSError* error;
    NSDictionary* json;
    NSArray* activities;
    if ([responseData length] > 0)
    {
        json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        activities = [json objectForKey:@"ActivityList"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
    }
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
    
    NSUInteger count = 0, LOOP_LIMIT = 100;
    // create new records
    NSManagedObject *managedObject = nil;
    
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    if (error)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
        NSLog(@"Error Descr %@",error.localizedDescription);
    }
    //@autoreleasepool
    if((!error) && (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"]))
    {
        //[moc lock];
        for (NSDictionary *item in activities) {
            
            //if doing a partial sync, find and delete existing record before adding new values
            if ([fullSyncFlag isEqualToString:@"N"])
            {
                NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entityDesc];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [item objectForKey:@"RowId"]];
                [request setPredicate:predicate];
                
                //NSManagedObject *matches = nil;
                NSArray *objects = [moc executeFetchRequest:request error:&error];
                for (NSManagedObject *match in objects)
                {
                    [moc deleteObject:match];
                }
                [moc save:&error];
                if (error)
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
                    NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
                }
            }
            
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Actions" inManagedObjectContext:moc];
            [managedObject setValue:@"" forKey:@"contactId"];
            [managedObject setValue:@"" forKey:@"officeId"];
            
            if ([item objectForKey:@"CompletedDate"] != [NSNull null]) {
                NSString *inputString = [item objectForKey:@"CompletedDate"];
                NSDate *compDate =[[NSDate dateWithTimeIntervalSince1970:[[inputString substringWithRange:NSMakeRange(6, 10)] intValue]] dateByAddingTimeInterval:offset];
                [managedObject setValue:compDate forKey:@"actionDate"];
            }
            if ([item objectForKey:@"DueDate"] != [NSNull null]) {
                NSString *inputdueString = [item objectForKey:@"DueDate"];
                NSDate *dueDate =[[NSDate dateWithTimeIntervalSince1970:[[inputdueString substringWithRange:NSMakeRange(6, 10)] intValue]] dateByAddingTimeInterval:offset];
                [managedObject setValue:dueDate forKey:@"dueDate"];
            }
            if ([item objectForKey:@"IntegrationId"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"IntegrationId"] forKey:@"integrationId"];
            if ([item objectForKey:@"Comments"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"Comments"] forKey:@"comments"];
            if ([item objectForKey:@"Notes"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"Notes"] forKey:@"longNotes"];
            if ([item objectForKey:@"SubType"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"SubType"] forKey:@"subType"];
            if ([item objectForKey:@"DescriptionType"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"DescriptionType"] forKey:@"descriptionType"];
            if ([item objectForKey:@"ContactRowId"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"ContactRowId"] forKey:@"contactId"];
            if ([item objectForKey:@"Description"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"Description"] forKey:@"note"];
            if ([item objectForKey:@"FacilityRowId"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"FacilityRowId"] forKey:@"officeId"];
            if ([item objectForKey:@"RowId"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"RowId"] forKey:@"rowId"];
            if ([item objectForKey:@"Status"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"Status"] forKey:@"status"];
            if ([item objectForKey:@"Type"] != [NSNull null])
                [managedObject setValue:[item objectForKey:@"Type"] forKey:@"type"];
            
            count++;
            if (count % LOOP_LIMIT == 0) {
                [moc save:&error];
                if (error)
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
                    NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
                }
                //[moc reset];
            }
            
        }
    
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"integrationId = nil"];
        [request setPredicate:predicate];
        
        //remove records added before the last sync
        count = 0;
        NSArray *objects = [moc executeFetchRequest:request error:&error];
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
        
        
        //remove all activities with status = Done and not Call Note
        request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        predicate = [NSPredicate predicateWithFormat:@"(status = %@ and descriptionType != %@ )", @"Done", @"Note from RM"];
        [request setPredicate:predicate];
        
        objects = [moc executeFetchRequest:request error:&error];
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
        if (error)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
            NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
        }
        //[moc unlock];
    }
    NSLog(@"end Load Activity");
    
}
@end
