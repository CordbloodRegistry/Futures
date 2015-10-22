//
//  cbrLoadStatOperation.h
//  fieldMobile
//
//  Created by Remina Sangil on 6/11/13.
//
//

#import <Foundation/Foundation.h>

@interface cbrLoadStatOperation : NSOperation
{
    BOOL done;
    NSString *status;
    NSString *errorMsg;
}

@property (nonatomic) BOOL done;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *errorMsg;
@property (strong, nonatomic) NSMutableArray *syncNextFUP;

@end