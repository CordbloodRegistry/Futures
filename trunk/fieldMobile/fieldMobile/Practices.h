//
//  Practices.h
//  fieldMobile
//
//  Created by Hai Tran on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Practices : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * practiceType;
@property (nonatomic, retain) NSString * primaryOfficeId;
@property (nonatomic, retain) NSString * rowId;
@property (nonatomic, retain) NSManagedObject *practiceProviders;
@property (nonatomic, retain) NSManagedObject *practiceTerritory;

@end
