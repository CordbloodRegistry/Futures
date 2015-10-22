//
//  FUP.h
//  fieldMobile
//
//  Created by Hai Tran on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FUP : NSObject {
	NSString *contactId;
	NSString *officeId;
	NSDate *fupDate;
    NSString *entityType;
}

@property(nonatomic, retain) NSString *contactId;
@property(nonatomic, retain) NSString *officeId;
@property(nonatomic, retain) NSDate *fupDate;
@property (nonatomic, retain) NSString * entityType;

@end
