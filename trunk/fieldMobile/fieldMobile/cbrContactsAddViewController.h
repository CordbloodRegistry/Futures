//
//  cbrContactsAddViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cbrContactsAddViewController : UIViewController
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *role;
- (IBAction)cancelRecord:(id)sender;
- (IBAction)saveRecord:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *status;

@end
