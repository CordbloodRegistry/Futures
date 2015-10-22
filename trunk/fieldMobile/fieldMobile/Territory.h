//
//  Territory.h
//  fieldMobile
//
//  Created by Hai Tran on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actions, Contacts, Offices, Practices, Providers;

@interface Territory : NSManagedObject

@property (nonatomic, retain) NSString * territoryName;
@property (nonatomic, retain) Actions *terrActions;
@property (nonatomic, retain) Offices *terrOffices;
@property (nonatomic, retain) Practices *terrPractices;
@property (nonatomic, retain) NSManagedObject *terrKitTransactions;
@property (nonatomic, retain) Providers *terrProviders;
@property (nonatomic, retain) Contacts *terrContacts;
@property (nonatomic, retain) NSManagedObject *terrKits;

@end
