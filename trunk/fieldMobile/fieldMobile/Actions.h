//
//  Actions.h
//  fieldMobile
//
//  Created by Hai Tran on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Offices, Providers, Territory;

@interface Actions : NSManagedObject

@property (nonatomic, retain) NSDate * actionDate;
@property (nonatomic, retain) NSString * contactId;
@property (nonatomic, retain) NSDecimalNumber * latitude;
@property (nonatomic, retain) NSDecimalNumber * longitude;
@property (nonatomic, retain) NSString * nextAction;
@property (nonatomic, retain) NSDate * nextActionDate;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * officeId;
@property (nonatomic, retain) NSString * rowId;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * integrationId;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSString * longNotes;
@property (nonatomic, retain) NSString * subType;
@property (nonatomic, retain) NSString * descriptionType;
@property (nonatomic, retain) Providers *actionProvider;
@property (nonatomic, retain) Territory *actionTerritory;
@property (nonatomic, retain) NSSet *transactions;
@property (nonatomic, retain) Offices *actionOffice;
@end

@interface Actions (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(NSManagedObject *)value;
- (void)removeTransactionsObject:(NSManagedObject *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;
@end
