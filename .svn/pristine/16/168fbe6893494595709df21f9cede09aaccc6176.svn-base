//
//  Contacts.h
//  fieldMobile
//
//  Created by Hai Tran on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Offices, Providers, Territory;

@interface Contacts : NSManagedObject

@property (nonatomic, retain) NSString * continuum;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * kol;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * officeHours;
@property (nonatomic, retain) NSString * officeId;
@property (nonatomic, retain) NSString * momentumRating;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSString * rowId;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * intersectId;
@property (nonatomic, retain) NSString * kitStockingFlag;
@property (nonatomic, retain) Offices *contactOffice;
@property (nonatomic, retain) Providers *contactProvider;
@property (nonatomic, retain) Territory *contactTerritory;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Contacts (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(NSManagedObject *)value;
- (void)removeTransactionsObject:(NSManagedObject *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
