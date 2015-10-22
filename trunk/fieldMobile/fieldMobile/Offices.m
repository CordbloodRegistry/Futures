//
//  Offices.m
//  fieldMobile
//
//  Created by Hai Tran on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Offices.h"
#import "Actions.h"
#import "Contacts.h"
#import "Kits.h"
#import "Providers.h"
#import "Territory.h"


@implementation Offices

@synthesize  title,subtitle;
- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D location;
    location.latitude = [self.latitude doubleValue];
    location.longitude = [self.longitude doubleValue];
    return location;
}
- (NSString *) title
{
    return self.name;
}
- (NSString *) subtitle
{
    //return self.rating;
    return  [[NSString alloc] initWithFormat:@"%@",self.rating];
}
@dynamic calls;
@dynamic addr;
@dynamic addr2;
@dynamic autoReceipt;
@dynamic annualBirths;
@dynamic city;
@dynamic country;
@dynamic competitor1;
@dynamic competitor2;
@dynamic distance;
@dynamic integrationId;
@dynamic kitLocation;
@dynamic kitContactId;
@dynamic kitContactFirstName;
@dynamic kitContactLastName;
@dynamic kitStockingEnd;
@dynamic kitStockingStart;
@dynamic nextFUDate;
@dynamic kitThreshold;
@dynamic latitude;
@dynamic longitude;
@dynamic mainFax;
@dynamic mainPhone;
@dynamic momentumRating;
@dynamic name;
@dynamic notes;
@dynamic numCBCollections;
@dynamic numCTCollections;
@dynamic numEnrollments;
@dynamic officeType;
@dynamic practiceId;
@dynamic rowId;
@dynamic state;
@dynamic stockingOffice;
@dynamic turn;
@dynamic url;
@dynamic zipcode;
@dynamic status;
@dynamic chargesPatient;
@dynamic amountCharged;
@dynamic inactiveReason;
@dynamic officeContacts;
@dynamic officeKits;
@dynamic officeProviders;
@dynamic officeTerritory;
@dynamic transactions;
@dynamic officeActions;
@dynamic rating;
@dynamic hospAnnualNM75K;
@dynamic kol;
@dynamic percentCashPay;
@dynamic percentMedicaid;
@dynamic lifetimeNPPBirth;
@dynamic lowapgarBirth;
@dynamic mouStartDate;
@dynamic mouEndDate;
@dynamic territory;

@end
