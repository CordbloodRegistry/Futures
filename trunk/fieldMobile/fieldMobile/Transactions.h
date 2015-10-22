//
//  Transactions.h
//  fieldMobile
//
//  Created by Hai Tran on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TransactionDetails;

@interface Transactions : NSManagedObject

@property (nonatomic, retain) NSString * entityType;
@property (nonatomic, retain) NSString * entityId;
@property (nonatomic, retain) NSString * transactionType;
@property (nonatomic, retain) NSDate * transactionDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@end

@interface Transactions (CoreDataGeneratedAccessors)

@end
