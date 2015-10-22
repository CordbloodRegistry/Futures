//
//  cbrHomeSettingsViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cbrHomeSettingsViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id appObject;
@property (strong, nonatomic) id storageFacility;

@property (strong, nonatomic) IBOutlet UISwitch *autoSyncFlg;
@property (strong, nonatomic) IBOutlet UITextField *autoSyncFreq;
@property (strong, nonatomic) IBOutlet UITextField *storageFacilityName;
@property (strong, nonatomic) IBOutlet UITextField *storageFacilityAddr;
@property (strong, nonatomic) IBOutlet UITextField *storageFacilityCity;
@property (strong, nonatomic) IBOutlet UILabel *trademark;

- (IBAction)saveSettings:(id)sender;
- (IBAction)resetUI:(id)sender;
- (IBAction)loginChange:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginObject;

@end
