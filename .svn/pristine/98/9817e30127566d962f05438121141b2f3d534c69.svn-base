//
//  cbrLoadHospitalOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//

#import "cbrLoadHospitalOperation.h"
#import "cbrAppDelegate.h"


@implementation cbrLoadHospitalOperation
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
    NSString *filename = [filenamePath stringByAppendingString:@"/facilities.json"];
    
    NSLog(@"ENTER Load Hospital");
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
    NSArray* hospitals;
    
    if ([responseData length] > 0)
    {
        json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        hospitals = [json objectForKey:@"FacilityList"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
    }
    // create new records
    NSManagedObject *managedObject;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];
    
    NSUInteger count = 0, LOOP_LIMIT = 100;
    if (error)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
        NSLog(@"Error Descr %@",error.localizedDescription);
    }
    //@autoreleasepool
    if((!error) && (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"]))
    {
        //[moc lock];
        for (NSDictionary *item in hospitals)
        {
            
            
            //if doing a partial sync, find and delete existing record before adding new values
            if ([fullSyncFlag isEqualToString:@"N"])
            {
                NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entityDesc];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [item objectForKey:@"Id"]];
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
            
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Offices" inManagedObjectContext:moc];
            
            if ([item objectForKey:@"FacilityType"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"FacilityType"]] forKey:@"officeType"];
            if ([item objectForKey:@"Id"] != [NSNull null]) {
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Id"]] forKey:@"rowId"];
                // load nextFUDate
                //                NSArray *fupArray = [self.syncNextFUP filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"officeId = %@",[item objectForKey:@"Id"]]];
                //                if ([fupArray count] > 0) {
                //                    [managedObject setValue:[[fupArray objectAtIndex:0] valueForKey:@"fupDate"] forKey:@"nextFUDate"];
                //                }
            }
            if ([item objectForKey:@"IntegrationId"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"IntegrationId"]] forKey:@"integrationId"];
            if ([item objectForKey:@"Name"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Name"]] forKey:@"name"];
            
            if ([item objectForKey:@"Address1"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Address1"]] forKey:@"addr"];
            if ([item objectForKey:@"Address2"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Address2"]] forKey:@"addr2"];
            if ([item objectForKey:@"City"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"City"]] forKey:@"city"];
            if ([item objectForKey:@"State"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"State"]] forKey:@"state"];
            if ([item objectForKey:@"PostalCode"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"PostalCode"]] forKey:@"zipcode"];
            if ([item objectForKey:@"MainPhone"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"MainPhone"]] forKey:@"mainPhone"];
            if ([item objectForKey:@"MainFax"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"MainFax"]] forKey:@"mainFax"];
            
            if ([item objectForKey:@"Latitude"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"Latitude"] floatValue]] forKey:@"latitude"];
            if ([item objectForKey:@"Longitude"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"Longitude"] floatValue]] forKey:@"longitude"];
            
            [managedObject setValue:@"" forKey:@"momentumRating"];
            if ([item objectForKey:@"MomentumRating"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"MomentumRating"]] forKey:@"momentumRating"];
            [managedObject setValue:0 forKey:@"annualBirths"];
            if ([item objectForKey:@"AnnualBirths"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"AnnualBirths"] intValue]] forKey:@"annualBirths"];
            if ([item objectForKey:@"Competitor1"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Competitor1"]] forKey:@"competitor1"];
            if ([item objectForKey:@"Competitor2"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Competitor2"]] forKey:@"competitor2"];
            if ([item objectForKey:@"FacilityIssue"] != [NSNull null])
                
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"FacilityIssue"]] forKey:@"notes"];
            if ([item objectForKey:@"KitStockingFlag"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"KitStockingFlag"]] forKey:@"stockingOffice"];
            if ([item objectForKey:@"KitStockingStart"] != [NSNull null])
            {
                NSString *inputString = [item objectForKey:@"KitStockingStart"];
                NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
                NSDate *kitDate =[[NSDate dateWithTimeIntervalSince1970:[[inputString substringWithRange:NSMakeRange(6, 10)] intValue]] dateByAddingTimeInterval:offset];
                [managedObject setValue:kitDate forKey:@"kitStockingStart"];
            }
            [managedObject setValue:@"" forKey:@"kitLocation"];
            if ([item objectForKey:@"KitStockingLocation"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"KitStockingLocation"]] forKey:@"kitLocation"];
            if ([item objectForKey:@"KitThreshold"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"KitThreshold"] intValue]] forKey:@"kitThreshold"];
            
            [managedObject setValue:@"" forKey:@"kitContactId"];
            if ([item objectForKey:@"KitContactId"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"KitContactId"]] forKey:@"kitContactId"];
            [managedObject setValue:@"" forKey:@"kitContactFirstName"];
            if ([item objectForKey:@"KitContactFirstName"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"KitContactFirstName"]] forKey:@"kitContactFirstName"];
            [managedObject setValue:@"" forKey:@"kitContactLastName"];
            if ([item objectForKey:@"KitContactLastName"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"KitContactLastName"]] forKey:@"kitContactLastName"];

            [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Country"]] forKey:@"country"];
            [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"AutoReceipt"]] forKey:@"autoReceipt"];
            [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Territory"]] forKey:@"territory"];
            
            [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"Status"]]  forKey:@"status"];
            [managedObject setValue:@"" forKey:@"inactiveReason"];
            if ([item objectForKey:@"InactivateReason"] != [NSNull null] && [item objectForKey:@"InactivateReason"] != NULL)
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"InactivateReason"]] forKey:@"inactiveReason"];
            
            //[managedObject setValue:0 forKey:@"amountCharged"];
            if ([item objectForKey:@"AmountCharged"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"AmountCharged"] floatValue]] forKey:@"amountCharged"];
            [managedObject setValue:@"N" forKey:@"chargesPatient"];
            if ([item objectForKey:@"ChargesPatient"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"ChargesPatient"]] forKey:@"chargesPatient"];
            
            if ([item objectForKey:@"CordBloodCollections"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"CordBloodCollections"] floatValue]] forKey:@"numCBCollections"];
            if ([item objectForKey:@"CordTissueCollections"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"CordTissueCollections"] floatValue]] forKey:@"numCTCollections"];
            if ([item objectForKey:@"Enrollments"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"Enrollments"] floatValue]] forKey:@"numEnrollments"];
            if ([item objectForKey:@"Turn"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"Turn"] floatValue]] forKey:@"turn"];
            [managedObject setValue:0 forKey:@"rating"];
            /*
            if ([item objectForKey:@"HospitalRank"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"HospitalRank"]] forKey:@"rating"];
            else
                [managedObject setValue:@"0" forKey:@"rating"];*/
            if ([item objectForKey:@"HospitalRank"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInteger:[[item objectForKey:@"HospitalRank"] integerValue]] forKey:@"rating"];
            else
                [managedObject setValue:Nil forKey:@"rating"];
            if ([item objectForKey:@"HospAnnualNM75K"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"HospAnnualNM75K"] floatValue]] forKey:@"hospAnnualNM75K"];
            else
                [managedObject setValue:Nil forKey:@"hospAnnualNM75K"];
            if ([item objectForKey:@"KeyAccountMarker"] != [NSNull null])
                [managedObject setValue:[NSString stringWithFormat:@"%@",[item objectForKey:@"KeyAccountMarker"]] forKey:@"kol"];
            if ([item objectForKey:@"PercentCashPay"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"PercentCashPay"] floatValue]] forKey:@"percentCashPay"];
            else
                    [managedObject setValue:Nil forKey:@"percentCashPay"];
            if ([item objectForKey:@"PercentMedicaid"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"PercentMedicaid"] floatValue]] forKey:@"percentMedicaid"];
            else
                [managedObject setValue:Nil forKey:@"percentMedicaid"];
            if ([item objectForKey:@"LifetimeNPPBirth"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"LifetimeNPPBirth"] floatValue]] forKey:@"lifetimeNPPBirth"];
            if ([item objectForKey:@"LifetimeNPPBirth"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"LifetimeNPPBirth"] floatValue]] forKey:@"lifetimeNPPBirth"];
            if ([item objectForKey:@"MOUStartDate"] != [NSNull null])
            {
                NSString *inputString = [item objectForKey:@"MOUStartDate"];
                NSDate *kitDate =[NSDate dateWithTimeIntervalSince1970:[[inputString substringWithRange:NSMakeRange(6, 10)] intValue]];
                [managedObject setValue:kitDate forKey:@"mouStartDate"];
                
            }
            if ([item objectForKey:@"MOUEndDate"] != [NSNull null])
            {
                NSString *inputString = [item objectForKey:@"MOUEndDate"];
                //NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
                //NSDate *kitDate =[[NSDate dateWithTimeIntervalSince1970:[[inputString substringWithRange:NSMakeRange(6, 10)] intValue]] dateByAddingTimeInterval:offset];
                NSDate *kitDate =[NSDate dateWithTimeIntervalSince1970:[[inputString substringWithRange:NSMakeRange(6, 10)] intValue]];
                [managedObject setValue:kitDate forKey:@"mouEndDate"];
            }
            //NSLog(@"%.2f",[[item objectForKey:@"Turn"] doubleValue]);
            // SAVE DATA IN BATCHES
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
        [moc save:&error];
        if (error)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
            NSLog(@"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
        }
        
        count = 0;
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        //NSPredicate *predicate = [NSPredicate predicateWithFormat: @"rowId = nil"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"rowId = nil OR (rowId != nil AND status != %@)", @"Active"];
        [request setPredicate:predicate];
        
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
        //[moc lock];
        NSLog(@"end Load Hospital");
    }
}

@end
