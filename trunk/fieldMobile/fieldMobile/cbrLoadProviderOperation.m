//
//  cbrLoadProviderOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//

#import "cbrLoadProviderOperation.h"
#import "cbrAppDelegate.h"


@implementation cbrLoadProviderOperation
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
    NSString *filename = [filenamePath stringByAppendingString:@"/providers.json"];
    
    NSLog(@"ENTER Load Provider");
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
    //parse out the json data
    NSError* error;
    NSDictionary *json;
    NSArray* providers;
    if ([responseData length] > 0)
    {
        json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        providers = [json objectForKey:@"ProviderList"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    
    //self.syncNumProviders = [NSNumber numberWithInt:[providers count]];
    
    // create new provider records
    NSEnumerator *enumerator = [providers objectEnumerator];
    NSDictionary *item = nil;
    NSManagedObject *managedObject = nil;
    
    NSUInteger count = 0, LOOP_LIMIT = 100;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *fullSyncFlag = [userDef stringForKey:@"rmFullSync"];

    if (error)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Error" forKey:@"Status"];
        NSLog(@"Error Descr %@",error.localizedDescription);
    }
    if((!error) && (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Status"] isEqualToString:@"Error"]))
    {
        //[moc lock];
        while (item = (NSDictionary*)[enumerator nextObject]) {
            
            //if doing a partial sync, find and delete existing record before adding new values
            if ([fullSyncFlag isEqualToString:@"N"])
            {
                NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Providers" inManagedObjectContext:moc];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entityDesc];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(rowId = %@ and facilityId = %@)", [item objectForKey:@"RowId"], [item objectForKey:@"FacilityId"]];
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
            
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Providers" inManagedObjectContext:moc];
            
            [managedObject setValue:@"N" forKey:@"pwaActiveFlag"];
            [managedObject setValue:@"N" forKey:@"hpnActiveFlag"];
            [managedObject setValue:@"N" forKey:@"hpnQualifiedFlag"];
            [managedObject setValue:@"N" forKey:@"sendPWAInvitation"];
            [managedObject setValue:@"N" forKey:@"pwaResetPwdFlag"];
            
            if ([item objectForKey:@"RowId"] != [NSNull null])
            {
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"RowId"]] forKey:@"rowId"];
                
                // load nextFUDate
                //            NSArray *fupArray = [self.syncNextFUP filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contactId = %@",[item objectForKey:@"RowId"]]];
                //            if ([fupArray count] > 0) {
                //                [managedObject setValue:[[fupArray objectAtIndex:0] valueForKey:@"fupDate"] forKey:@"nextFUDate"];
                //            }
                //            else if ([item objectForKey:@"FacilityId"] != [NSNull null])
                //            {
                //                NSArray *fupArray = [self.syncNextFUP filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"officeId = %@ and entityType = %@",[item objectForKey:@"FacilityId"], @"Kits"]];
                //                if ([fupArray count] > 0) {
                //                    [managedObject setValue:[[fupArray objectAtIndex:0] valueForKey:@"fupDate"] forKey:@"nextFUDate"];
                //                }
                //
                //            }
            }
            
            if ([item objectForKey:@"ProviderId"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"ProviderId"]] forKey:@"personUID"];
            if ([item objectForKey:@"FirstName"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"FirstName"]] forKey:@"firstName"];
            if ([item objectForKey:@"LastName"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"LastName"]] forKey:@"lastName"];
            if ([item objectForKey:@"ProviderStatus"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"ProviderStatus"]] forKey:@"status"];
            if ([item objectForKey:@"PF_Status"] != [NSNull null])
            {
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PF_Status"]] forKey:@"pfStatus"];
            }
            [managedObject setValue:@"" forKey:@"inactiveReason"];
            if ([item objectForKey:@"InactiveReason"] != [NSNull null]  && [item objectForKey:@"InactiveReason"] != NULL)
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"InactiveReason"]] forKey:@"inactiveReason"];
            else
                [managedObject setValue:@"" forKey:@"inactiveReason"];
            if ([item objectForKey:@"ProviderCredential"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"ProviderCredential"]] forKey:@"credential"];
            if ([item objectForKey:@"ProviderClassification"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"ProviderClassification"]] forKey:@"category"];
            dateFromString = [dateFormatter dateFromString:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"CertificationDate"]]];
            if ([item objectForKey:@"CertificationDate"] != [NSNull null])
                [managedObject setValue:dateFromString forKey:@"certificationDate"];
            
            if ([item objectForKey:@"DedicatedEducator"] != [NSNull null] && [item objectForKey:@"DedicatedEducator"] != NULL)
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"DedicatedEducator"]] forKey:@"dedicatedEducator"];
            [managedObject setValue:@"" forKey:@"emailPrimary"];
            if ([item objectForKey:@"EmailAddress"] != [NSNull null]  && [item objectForKey:@"EmailAddress"] != NULL)
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"EmailAddress"]] forKey:@"emailPrimary"];
            else
                [managedObject setValue:@"" forKey:@"emailPrimary"];
            if ([item objectForKey:@"EmailSecondary"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"EmailSecondary"]] forKey:@"emailSecondary"];
            if ([item objectForKey:@"EnrollCountCB"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"EnrollCountCB"] intValue]] forKey:@"enrollCountCB"];
            if ([item objectForKey:@"EnrollCountCT"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"EnrollCountCT"] intValue]] forKey:@"enrollCountCT"];
            if ([item objectForKey:@"MonthlyBirths"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"MonthlyBirths"] intValue]] forKey:@"monthlyBirth"];
            if ([item objectForKey:@"IntegrationId"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"IntegrationId"]] forKey:@"integrationId"];
            
            if ([item objectForKey:@"NewKitTrainedFlag"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"NewKitTrainedFlag"]] forKey:@"kitTrainFlag"];
            
            dateFromString = [dateFormatter dateFromString:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"NewKitTrainedDate"]]];
            if ([item objectForKey:@"NewKitTrainedDate"] != [NSNull null])
                [managedObject setValue:dateFromString forKey:@"kitTrainDate"];
            
            
            if ([item objectForKey:@"LabTourAttendee"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"LabTourAttendee"]] forKey:@"labTourAttendee"];
            
            dateFromString = [dateFormatter dateFromString:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"LastEnrollDt"]]];
            if ([item objectForKey:@"LastEnrollDt"] != [NSNull null])
                [managedObject setValue:dateFromString forKey:@"lastEnrollDt"];
            
            if ([item objectForKey:@"MomentumRating"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"MomentumRating"]] forKey:@"momentumRating"];
            
            
            if ([item objectForKey:@"DoNotEmail"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"DoNotEmail"]] forKey:@"noEmail"];
            
            
            if ([item objectForKey:@"DoNotFax"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"DoNotFax"]] forKey:@"noFax"];
            
            if ([item objectForKey:@"NoMail"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"NoMail"]] forKey:@"noMail"];
            
            if ([item objectForKey:@"ProviderIssue"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"ProviderIssue"]] forKey:@"issues"];
            if ([item objectForKey:@"Notes"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"Notes"]] forKey:@"notes"];
            if ([item objectForKey:@"PrimaryOfficeId"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PrimaryOfficeId"]] forKey:@"primaryOfficeId"];
            
            if ([item objectForKey:@"PastInviteSent"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PastInviteSent"]] forKey:@"pwaInvitationSent"];
            if ([item objectForKey:@"SendPWAInvitation"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"SendPWAInvitation"]] forKey:@"sendPWAInvitation"];
            if ([item objectForKey:@"PWALogin"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PWALogin"]] forKey:@"pwaLogin"];
            
            if ([item objectForKey:@"PwaLoginVerified"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PwaLoginVerified"]] forKey:@"pwaLoginVerified"];
            
            if ([item objectForKey:@"PWAActiveFlag"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PWAActiveFlag"]] forKey:@"pwaActiveFlag"];
            /*
             //always show reset password as off
             if ([item objectForKey:@"PWAResetPasswordFlag"] != [NSNull null])
             [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PWAResetPasswordFlag"]] forKey:@"pwaResetPwdFlag"];
             */
            dateFromString = [dateFormatter dateFromString:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PWALastLogin"]]];
            if ([item objectForKey:@"PWALastLogin"] != [NSNull null])
                [managedObject setValue:dateFromString forKey:@"pwaLastLoginDate"];
            
            
            
            if ([item objectForKey:@"HPNAgreementActiveFlag"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"HPNAgreementActiveFlag"]] forKey:@"hpnActiveFlag"];
            if ([item objectForKey:@"HPNQualifiedFlag"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"HPNQualifiedFlag"]] forKey:@"hpnQualifiedFlag"];
            
            dateFromString = [dateFormatter dateFromString:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"HPNAgreementSignedDate"]]];
            if ([item objectForKey:@"HPNAgreementSignedDate"] != [NSNull null])
                [managedObject setValue:dateFromString forKey:@"hpnSignedDate"];
            
            if ([item objectForKey:@"KitStockingFlag"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"KitStockingFlag"]] forKey:@"stockingDoc"];
            
            if ([item objectForKey:@"WorksAtStockingHospital"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"WorksAtStockingHospital"]] forKey:@"worksAtStockingHospital"];
            
            if ([item objectForKey:@"Latitude"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"Latitude"] floatValue]] forKey:@"latitude"];
            if ([item objectForKey:@"Longitude"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"Longitude"] floatValue]] forKey:@"longitude"];
            
            
            if ([item objectForKey:@"PFPhone"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PFPhone"]] forKey:@"pfPhone"];
            if ([item objectForKey:@"PFFax"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PFFax"]] forKey:@"pfFax"];
            
            
            if ([item objectForKey:@"Address1"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"Address1"]] forKey:@"facilityAddr"];
            if ([item objectForKey:@"Address2"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"Address2"]] forKey:@"facilityAddr2"];
            if ([item objectForKey:@"City"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"City"]] forKey:@"facilityCity"];
            if ([item objectForKey:@"FacilityName"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"FacilityName"]] forKey:@"facilityName"];
            if ([item objectForKey:@"State"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"State"]] forKey:@"facilityState"];
            if ([item objectForKey:@"Zipcode"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"Zipcode"]] forKey:@"facilityZipcode"];
            if ([item objectForKey:@"FacilityId"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"FacilityId"]] forKey:@"facilityId"];
            if ([item objectForKey:@"FacilityMainPhone"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"FacilityMainPhone"]] forKey:@"facilityPhone"];
            if ([item objectForKey:@"FacilityMainFax"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"FacilityMainFax"]] forKey:@"facilityFax"];
            
            if ([item objectForKey:@"CordBloodCollections"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"CordBloodCollections"] floatValue]] forKey:@"numCBCollections"];
            if ([item objectForKey:@"CordTissueCollections"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"CordTissueCollections"] floatValue]] forKey:@"numCTCollections"];
            if ([item objectForKey:@"Enrollments"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"Enrollments"] floatValue]] forKey:@"numEnrollments"];
            if ([item objectForKey:@"AvgQualityScore"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"AvgQualityScore"] floatValue]] forKey:@"avgQualityScore"];
            if ([item objectForKey:@"Turn"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"Turn"] floatValue]] forKey:@"turn"];
            
            if ([item objectForKey:@"DrBirthYear"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithFloat:[[item objectForKey:@"DrBirthYear"] floatValue]] forKey:@"birthYear"];
            if ([item objectForKey:@"DrRating"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"DrRating"]] forKey:@"rating"];
            else
                [managedObject setValue:@"" forKey:@"rating"];
            if ([item objectForKey:@"SalesContinuum"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"SalesContinuum"]] forKey:@"salesContinuum"];
            if ([item objectForKey:@"KeyAccountMarker"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"KeyAccountMarker"]] forKey:@"keyAccountMarker"];
            if ([item objectForKey:@"ProviderType"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"ProviderType"]] forKey:@"providerType"];
            if ([item objectForKey:@"PFOfficeHours"] != [NSNull null])
                [managedObject setValue:[[NSString alloc] initWithFormat:@"%@",[item objectForKey:@"PFOfficeHours"]] forKey:@"pfOfficeHours"];
            
            //Sales Metrics Data
            
            
            if ([item objectForKey:@"ACD_Oppty_Pct"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"ACD_Oppty_Pct"] intValue]] forKey:@"aCDvsTotal"];
            
            if ([item objectForKey:@"CB_CT_Ratio"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"CB_CT_Ratio"] intValue]] forKey:@"cTCB_Ratio"];
            
            if ([item objectForKey:@"Educated_Pct"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"Educated_Pct"] intValue]] forKey:@"educated_pct"];
            
            if ([item objectForKey:@"Educated"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"Educated"] intValue]] forKey:@"educated"];
            
            if ([item objectForKey:@"New_Enroll_Pct"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"New_Enroll_Pct"] intValue]] forKey:@"newEnrollments"];
            
            if ([item objectForKey:@"Total_CB"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"Total_CB"] intValue]] forKey:@"totalCBStorages"];
            
            if ([item objectForKey:@"Total_CT"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"Total_CT"] intValue]] forKey:@"totalCTStorages"];
            
            if ([item objectForKey:@"Total_Enroll"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"Total_Enroll"] intValue]] forKey:@"total_Enrollments"];
            
            if ([item objectForKey:@"Total_Optys"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"Total_Optys"] intValue]] forKey:@"totalOpptys"];
            
            if ([item objectForKey:@"Penetration_Rate"] != [NSNull null])
                [managedObject setValue:[NSNumber numberWithInt:[[item objectForKey:@"Penetration_Rate"] intValue]] forKey:@"penetrationRate"];
            
            // SAVE IN BATCHES
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
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Providers" inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"rowId = nil OR (rowId != nil AND pfStatus != %@)", @"Active"];
        [request setPredicate:predicate];
        
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
        //[moc unlock];
    }
    NSLog(@"end Load Provider");
}
@end
