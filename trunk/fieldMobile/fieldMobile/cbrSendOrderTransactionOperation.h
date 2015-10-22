//
//  cbrSendOrderTransactionOperation.h
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//

#import <Foundation/Foundation.h>

@interface cbrSendOrderTransactionOperation : NSOperation
{
    BOOL done;
    NSString *status;
    NSString *errorMsg;
    NSString *description;
}

@property (nonatomic) BOOL done;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *errorMsg;
@property (strong, nonatomic) NSString *description;

-(id)initWithDescription:(NSString *)desc;
@end