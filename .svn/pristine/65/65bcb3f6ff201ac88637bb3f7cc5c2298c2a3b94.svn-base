//
//  Offices.h
//  fieldMobile
//
//  Created by Hai Tran on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actions, Contacts, Kits, Providers, Territory;

@interface Offices : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString * addr;
@property (nonatomic, retain) NSString * addr2;
@property (nonatomic, retain) NSNumber * annualBirths;
@property (nonatomic, retain) NSString * autoReceipt;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * competitor1;
@property (nonatomic, retain) NSString * competitor2;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * integrationId;
@property (nonatomic, retain) NSString * inactiveReason;
@property (nonatomic, retain) NSString * kitLocation;
@property (nonatomic, retain) NSString * kitContactId;
@property (nonatomic, retain) NSString * kitContactFirstName;
@property (nonatomic, retain) NSString * kitContactLastName;

@property (nonatomic, retain) NSDate * kitStockingEnd;
@property (nonatomic, retain) NSDate * kitStockingStart;
@property (nonatomic, retain) NSDate * nextFUDate;
@property (nonatomic, retain) NSNumber * kitThreshold;
@property (nonatomic, retain) NSDecimalNumber * latitude;
@property (nonatomic, retain) NSDecimalNumber * longitude;
@property (nonatomic, retain) NSString * mainFax;
@property (nonatomic, retain) NSString * mainPhone;
@property (nonatomic, retain) NSString * momentumRating;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDecimalNumber * amountCharged;
@property (nonatomic, retain) NSString * chargesPatient;
@property (nonatomic, retain) NSDecimalNumber * numCBCollections;
@property (nonatomic, retain) NSDecimalNumber * numCTCollections;
@property (nonatomic, retain) NSDecimalNumber * numEnrollments;
@property (nonatomic, retain) NSString * officeType;
@property (nonatomic, retain) NSString * practiceId;
@property (nonatomic, retain) NSString * rowId;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * stockingOffice;
@property (nonatomic, retain) NSString * territory;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDecimalNumber * turn;
@property (nonatomic, retain) NSSet *officeContacts;
@property (nonatomic, retain) NSSet *officeKits;
@property (nonatomic, retain) NSSet *officeProviders;
@property (nonatomic, retain) Territory *officeTerritory;
@property (nonatomic, retain) NSSet *transactions;
@property (nonatomic, retain) NSSet *officeActions;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSDecimalNumber * hospAnnualNM75K;
@property (nonatomic, retain) NSString * kol;
@property (nonatomic, retain) NSDecimalNumber * percentCashPay;
@property (nonatomic, retain) NSDecimalNumber * percentMedicaid;
@property (nonatomic, retain) NSDecimalNumber * lifetimeNPPBirth;
@property (nonatomic, retain) NSDecimalNumber * lowapgarBirth;
@property (nonatomic, retain) NSDate * mouStartDate;
@property (nonatomic, retain) NSDate * mouEndDate;
@property (nonatomic, retain) NSNumber *  calls;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;

@end

@interface Offices (CoreDataGeneratedAccessors)

- (void)addOfficeContactsObject:(Contacts *)value;
- (void)removeOfficeContactsObject:(Contacts *)value;
- (void)addOfficeContacts:(NSSet *)values;
- (void)removeOfficeContacts:(NSSet *)values;

- (void)addOfficeKitsObject:(Kits *)value;
- (void)removeOfficeKitsObject:(Kits *)value;
- (void)addOfficeKits:(NSSet *)values;
- (void)removeOfficeKits:(NSSet *)values;

- (void)addOfficeProvidersObject:(Providers *)value;
- (void)removeOfficeProvidersObject:(Providers *)value;
- (void)addOfficeProviders:(NSSet *)values;
- (void)removeOfficeProviders:(NSSet *)values;

- (void)addTransactionsObject:(NSManagedObject *)value;
- (void)removeTransactionsObject:(NSManagedObject *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

- (void)addOfficeActionsObject:(Actions *)value;
- (void)removeOfficeActionsObject:(Actions *)value;
- (void)addOfficeActions:(NSSet *)values;
- (void)removeOfficeActions:(NSSet *)values;

@end
