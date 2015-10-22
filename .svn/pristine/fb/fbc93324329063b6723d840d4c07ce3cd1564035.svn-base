//
//  cbrLoadKitOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//

#import "cbrLoadKitOperation.h"
#import "cbrAppDelegate.h"

@implementation cbrLoadKitOperation
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
    NSString *filename = [filenamePath stringByAppendingString:@"/kits.json"];
    
    NSLog(@"ENTER Load Kits");
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
    NSArray *kits;
    
    //parse out the json data
    if ([responseData length])
    {
        json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        kits = [json objectForKey:@"AssetList"];
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
    //    NSDate *today = [NSDate date];
    //    int daysToAdd = 180;
    //    NSDate *agingDate = [today dateByAddingTimeInterval:60*60*24*daysToAdd];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
    
    if((!error) && (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"]))
    {
        //[moc lock];
        //delete current assets first before loading
        if ([fullSyncFlag isEqualToString:@"N"])
        {
            NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc];
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
            for (NSDictionary *item in kits) {
                
                managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Kits" inManagedObjectContext:moc];
                
                if ([item objectForKey:@"DepositId"] != [NSNull null])
                    [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"DepositId"]] forKey:@"depositId"];
                if ([item objectForKey:@"BoxId"] != [NSNull null])
                    [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"BoxId"]] forKey:@"boxNumber"];
                if ([item objectForKey:@"RowId"] != [NSNull null])
                    [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"RowId"]] forKey:@"rowId"];
                if ([item objectForKey:@"ExpirationDate"] != [NSNull null]) {
                    NSString *inputString = [item objectForKey:@"ExpirationDate"];
                    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
                    NSDate *expDate =[[NSDate dateWithTimeIntervalSince1970:[[inputString substringWithRange:NSMakeRange(6, 10)] intValue]] dateByAddingTimeInterval:offset];
                    [managedObject setValue:expDate forKey:@"expirationDate"];
                    
                }
                if ([item objectForKey:@"AssignedToContact"] != [NSNull null])
                    [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"AssignedToContact"]] forKey:@"assignedContactId"];
                if ([item objectForKey:@"AssignedToFacility"] != [NSNull null])
                    [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"AssignedToFacility"]] forKey:@"assignedOfficeId"];
                if ([item objectForKey:@"Status"] != [NSNull null])
                    [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Status"]] forKey:@"status"];
                if ([item objectForKey:@"Product"] != [NSNull null])
                    [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Product"]] forKey:@"product"];
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
        // Save any remaining records
        if (count != 0) {
            [moc save:&error];
            if (error)
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
                NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
            }
            //[moc reset];
        }
        //[moc unlock];
    }
    NSLog(@"end Load Kits");
}
@end
