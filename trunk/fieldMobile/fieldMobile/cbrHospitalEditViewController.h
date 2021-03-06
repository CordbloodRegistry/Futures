//
//  cbrHospitalEditViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface cbrHospitalEditViewController : UITableViewController <UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) id preDetailItem;

- (IBAction)saveChanges:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *addrField;
@property (weak, nonatomic) IBOutlet UITextField *addr2Field;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *faxField;

@property (weak, nonatomic) IBOutlet UILabel *annualBirthLabel;
@property (weak, nonatomic) IBOutlet UITextField *annualBirthsField;
@property (weak, nonatomic) IBOutlet UITextField *percentMedicaidField;
@property (weak, nonatomic) IBOutlet UITextField *kitLocationField;
@property (weak, nonatomic) IBOutlet UITextField *kitContactField;
@property (weak, nonatomic) IBOutlet UITextField *kitThresholdField;

@property (weak, nonatomic) IBOutlet UITextField *amountChargedField;
@property (weak, nonatomic) IBOutlet UISwitch *chargesPatientSwitch;

@property (weak, nonatomic) IBOutlet UITextField *competitor2Field;
@property (weak, nonatomic) IBOutlet UITextField *competitor1Field;
@property (weak, nonatomic) IBOutlet UISwitch *kitStockingField;
@property (weak, nonatomic) IBOutlet UISwitch *activeStatus;
@property (weak, nonatomic) IBOutlet UITextField *reasonField;

@property (strong, nonatomic) NSMutableArray *pickerReasonArray;
@property (strong, nonatomic) NSMutableArray *pickerComp1Array;
@property (strong, nonatomic) NSMutableArray *pickerComp2Array;
@property (strong, nonatomic) NSMutableArray *pickerCashPay;
@property (strong, nonatomic) NSMutableArray *pickerMedicaid;
@property (strong, nonatomic) NSMutableArray *pickerContactArray;
@property (strong, nonatomic) NSMutableArray *pickerConIdArray;
@property (strong, nonatomic) NSString *kitConIdField;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

- (IBAction)kitStockingFieldChange:(id)sender;

@end
