//
//  cbrProviderAddViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cbrOfficesChooseViewController.h"

//@class cbrProviderAddViewController;

@interface cbrProviderAddViewController : UITableViewController <UINavigationControllerDelegate,cbrOfficesChooseViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id officeItem;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *credentialField;
@property (weak, nonatomic) IBOutlet UITextField *classificationField;
@property (weak, nonatomic) IBOutlet UITextField *officePhoneField;
@property (weak, nonatomic) IBOutlet UITextField *officeFaxField;
@property (weak, nonatomic) IBOutlet UISwitch *residentField;
@property (weak, nonatomic) IBOutlet UITextField *continuum;
@property (weak, nonatomic) IBOutlet UITextField *drBirthYear;
@property (weak, nonatomic) IBOutlet UITextField *cellField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *lblOffice;
@property (weak, nonatomic) IBOutlet UITextField *officeHours;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) NSMutableArray *pickerCredentialArray;
@property (strong, nonatomic) NSMutableArray *pickerClassificationArray;
@property (strong, nonatomic) NSMutableArray *pickerYearArray;
@property (strong, nonatomic) NSMutableArray *pickerContinuumArray;
- (IBAction)addRecord:(id)sender;
@end
