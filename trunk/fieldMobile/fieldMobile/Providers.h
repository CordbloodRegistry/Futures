//
//  Providers.h
//  fieldMobile
//
//  Created by Remina Sangil on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actions, Contacts, Kits, Offices, Practices, Territory;

@interface Providers : NSManagedObject

@property (nonatomic, retain) NSNumber * birthYear;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * certificationDate;
@property (nonatomic, retain) NSString * credential;
@property (nonatomic, retain) NSString * dedicatedEducator;
@property (nonatomic, retain) NSString * emailPrimary;
@property (nonatomic, retain) NSString * emailSecondary;
@property (nonatomic, retain) NSNumber * enrollCountCB;
@property (nonatomic, retain) NSNumber * enrollCountCT;
@property (nonatomic, retain) NSString * facilityAddr;
@property (nonatomic, retain) NSString * facilityAddr2;
@property (nonatomic, retain) NSString * facilityCity;
@property (nonatomic, retain) NSString * facilityFax;
@property (nonatomic, retain) NSString * facilityId;
@property (nonatomic, retain) NSString * facilityIntegrationId;
@property (nonatomic, retain) NSString * facilityName;
@property (nonatomic, retain) NSString * facilityType;
@property (nonatomic, retain) NSString * facilityPhone;
@property (nonatomic, retain) NSString * facilityState;
@property (nonatomic, retain) NSString * facilityZipcode;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * inactiveReason;
@property (nonatomic, retain) NSString * integrationId;
@property (nonatomic, retain) NSString * keyAccountMarker;
@property (nonatomic, retain) NSDate * kitTrainDate;
@property (nonatomic, retain) NSString * kitTrainFlag;
@property (nonatomic, retain) NSDate * nextFUDate;
@property (nonatomic, retain) NSString * labTourAttendee;
@property (nonatomic, retain) NSDate * lastEnrollDt;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDecimalNumber * latitude;
@property (nonatomic, retain) NSDecimalNumber * longitude;
@property (nonatomic, retain) NSString * momentumRating;
@property (nonatomic, retain) NSString * noEmail;
@property (nonatomic, retain) NSString * noFax;
@property (nonatomic, retain) NSString * noMail;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDecimalNumber * numCBCollections;
@property (nonatomic, retain) NSDecimalNumber * numCTCollections;
@property (nonatomic, retain) NSDecimalNumber * numEnrollments;
@property (nonatomic, retain) NSDecimalNumber * avgQualityScore;
@property (nonatomic, retain) NSString * personUID;
@property (nonatomic, retain) NSString * pfFax;
@property (nonatomic, retain) NSString * pfOfficeHours;
@property (nonatomic, retain) NSString * pfPhone;
@property (nonatomic, retain) NSString * primaryOfficeId;
@property (nonatomic, retain) NSString * pwaInvitationSent;
@property (nonatomic, retain) NSString * pwaLogin;
@property (nonatomic, retain) NSString * pwaLoginVerified;
@property (nonatomic, retain) NSString * sendPWAInvitation;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSString * rowId;
@property (nonatomic, retain) NSString * stockingDoc;
@property (nonatomic, retain) NSString * worksAtStockingHospital;
@property (nonatomic, retain) NSString * pwaActiveFlag;
@property (nonatomic, retain) NSDate * pwaLastLoginDate;
@property (nonatomic, retain) NSString * hpnActiveFlag;
@property (nonatomic, retain) NSString * hpnQualifiedFlag;
@property (nonatomic, retain) NSDate * hpnSignedDate;
@property (nonatomic, retain) NSString * pwaResetPwdFlag;
@property (nonatomic, retain) NSNumber * monthlyBirth;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * issues;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * pfStatus;
@property (nonatomic, retain) NSDecimalNumber * turn;
@property (nonatomic, retain) NSSet *provActions;
@property (nonatomic, retain) NSSet *provContacts;
@property (nonatomic, retain) NSSet *provKits;
@property (nonatomic, retain) NSSet *provOffices;
@property (nonatomic, retain) NSSet *provOpportunities;
@property (nonatomic, retain) Practices *provPractice;
@property (nonatomic, retain) Territory *provTerritory;
@property (nonatomic, retain) NSString * salesContinuum;
@property (nonatomic, retain) NSString * providerType;
@property (nonatomic, retain) NSSet *transactions;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, retain) NSNumber *  aCDvsTotal;
@property (nonatomic, retain) NSNumber *  nwEnrollments;
@property (nonatomic, retain) NSNumber *  educated;
@property (nonatomic, retain) NSNumber *  educated_pct;
@property (nonatomic, retain) NSNumber *  cTCB_Ratio;
@property (nonatomic, retain) NSNumber *  totalOpptys;
@property (nonatomic, retain) NSNumber *  total_Enrollments;
@property (nonatomic, retain) NSNumber *  totalCBStorages;
@property (nonatomic, retain) NSNumber *  totalCTStorages;
@property (nonatomic, retain) NSNumber *  penetrationRate;
@property (nonatomic, retain) NSNumber *  calls;

@end

@interface Providers (CoreDataGeneratedAccessors)

- (void)addProvActionsObject:(Actions *)value;
- (void)removeProvActionsObject:(Actions *)value;
- (void)addProvActions:(NSSet *)values;
- (void)removeProvActions:(NSSet *)values;

- (void)addProvContactsObject:(Contacts *)value;
- (void)removeProvContactsObject:(Contacts *)value;
- (void)addProvContacts:(NSSet *)values;
- (void)removeProvContacts:(NSSet *)values;

- (void)addProvKitsObject:(Kits *)value;
- (void)removeProvKitsObject:(Kits *)value;
- (void)addProvKits:(NSSet *)values;
- (void)removeProvKits:(NSSet *)values;

- (void)addProvOfficesObject:(Offices *)value;
- (void)removeProvOfficesObject:(Offices *)value;
- (void)addProvOffices:(NSSet *)values;
- (void)removeProvOffices:(NSSet *)values;

- (void)addProvOpportunitiesObject:(NSManagedObject *)value;
- (void)removeProvOpportunitiesObject:(NSManagedObject *)value;
- (void)addProvOpportunities:(NSSet *)values;
- (void)removeProvOpportunities:(NSSet *)values;

- (void)addTransactionsObject:(NSManagedObject *)value;
- (void)removeTransactionsObject:(NSManagedObject *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
