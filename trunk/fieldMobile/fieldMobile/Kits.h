//
//  Kits.h
//  fieldMobile
//
//  Created by Hai Tran on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Offices, Providers, Territory;

@interface Kits : NSManagedObject

@property (nonatomic, retain) NSString * assignedContactId;
@property (nonatomic, retain) NSString * assignedContactFirstName;
@property (nonatomic, retain) NSString * assignedContactLastName;
@property (nonatomic, retain) NSString * assignedOfficeId;
@property (nonatomic, retain) NSString * boxNumber;
@property (nonatomic, retain) NSString * depositId;
@property (nonatomic, retain) NSDate * expirationDate;
@property (nonatomic, retain) NSString * kitType;
@property (nonatomic, retain) NSString * rowId;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * product;
@property (nonatomic, retain) NSNumber * qualityScore;
@property (nonatomic, retain) Offices *kitOffice;
@property (nonatomic, retain) Providers *kitProviders;
@property (nonatomic, retain) Territory *kitTerritory;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Kits (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(NSManagedObject *)value;
- (void)removeTransactionsObject:(NSManagedObject *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
