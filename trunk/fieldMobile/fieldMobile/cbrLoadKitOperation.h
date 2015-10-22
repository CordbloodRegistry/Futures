//
//  cbrLoadKitOperation.h
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//

#import <Foundation/Foundation.h>

@interface cbrLoadKitOperation : NSOperation
{
    BOOL done;
    NSString *status;
    NSString *errorMsg;
}

@property (nonatomic) BOOL done;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *errorMsg;
@end