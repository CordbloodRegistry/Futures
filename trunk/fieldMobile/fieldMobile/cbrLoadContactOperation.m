//
//  cbrLoadContactOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//

#import "cbrLoadContactOperation.h"
#import "cbrAppDelegate.h"


@implementation cbrLoadContactOperation
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
    NSString *filename = [filenamePath stringByAppendingString:@"/contacts.json"];
    
    NSLog(@"ENTER Load Contact");
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
    NSError *error;
    NSDictionary* json;
    NSArray *contacts;
    //parse out the json data
    if ([responseData length] > 0)
    {
        json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        contacts = [json objectForKey:@"ContactList"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
    }
    if (error)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
        NSLog(@"Error Descr %@",error.localizedDescription);
    }

    // create new records
    NSManagedObject *managedObject;
    
    NSUInteger count = 0, LOOP_LIMIT = 100;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];

    if((!error) && (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"]))
    {
        //[moc lock];
        //delete current contacts first before loading
        if ([fullSyncFlag isEqualToString:@"N"])
        {
            NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:moc];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            //NSManagedObject *matches = nil;
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
            [moc save:&error];
            if (error)
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
                NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
            }
        }
        
        count = 0;
        //@autoreleasepool
        {
            for (NSDictionary *item in contacts) {
                
                //if doing a partial sync, find and delete existing record before adding new values
                //            if ([fullSyncFlag isEqualToString:@"N"])
                //            {
                //                NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:moc];
                //                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                //                [request setEntity:entityDesc];
                //
                //                NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(rowId = %@ and officeId = %@)", [item objectForKey:@"RowId"], [item objectForKey:@"FacilityRowId"]];
                //                [request setPredicate:predicate];
                //
                //                //NSManagedObject *matches = nil;
                //                NSArray *objects = [moc executeFetchRequest:request error:&error];
                //                for (NSManagedObject *match in objects)
                //                {
                //                    [moc deleteObject:match];
                //                }
                //                [moc save:&error];
                //            }
                
                if ([item objectForKey:@"Status"] != [NSNull null] && [[item objectForKey:@"Status"] isEqualToString:@"Active"])
                {
                    managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:moc];
                    
                    if ([item objectForKey:@"FirstName"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"FirstName"]] forKey:@"firstName"];
                    if ([item objectForKey:@"LastName"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"LastName"]] forKey:@"lastName"];
                    if ([item objectForKey:@"FacilityRowId"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"FacilityRowId"]] forKey:@"officeId"];
                    if ([item objectForKey:@"MomentumRating"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"MomentumRating"]] forKey:@"momentumRating"];
                    if ([item objectForKey:@"Role"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Role"]] forKey:@"role"];
                    if ([item objectForKey:@"RowId"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"RowId"]] forKey:@"rowId"];
                    if ([item objectForKey:@"Status"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Status"]] forKey:@"status"];
                    if ([item objectForKey:@"KitStockingFlag"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"KitStockingFlag"]] forKey:@"kitStockingFlag"];
                    if ([item objectForKey:@"Intersect"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Intersect"]] forKey:@"intersectId"];
                    if ([item objectForKey:@"EmailAddress"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"EmailAddress"]] forKey:@"email"];
                    if ([item objectForKey:@"ContactContinuum"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"ContactContinuum"]] forKey:@"continuum"];
                    if ([item objectForKey:@"KOLFlag"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"KOLFlag"]] forKey:@"kol"];
                    else
                        [managedObject setValue:@"N" forKey:@"kol"];
                    if ([item objectForKey:@"PFOfficeHours"] != [NSNull null])
                        [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"PFOfficeHours"]] forKey:@"officeHours"];
                    
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
            }
        }
        
        [moc save:&error];
        if (error)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
            NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
        }
        //[moc unlock];
    }
    NSLog(@"end Load Contact");
}
@end
