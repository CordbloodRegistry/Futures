//
//  cbrCheckInViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cbrCheckInViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate,NSFetchedResultsControllerDelegate> {
    NSDate *dueDt;
    UIView *pickerView;
    UIDatePicker *theDatePicker;
    UITextField *checkInNextDate;
    NSArray *activities;
    NSArray *sortedActivities;
    
        IBOutlet UILabel *detailLabel0;
        IBOutlet UILabel *detailLabel1;
        IBOutlet UILabel *detailLabel2;
        UIView* customView;

}
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *dueDt;
@property NSInteger intClaim;
@property NSInteger intSubClaim;
@property (strong, nonatomic) UIView *pickerView;
@property (strong, nonatomic) UIDatePicker *theDatePicker;
@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (strong, nonatomic) NSMutableArray *pickerType;
@property (strong, nonatomic) NSMutableArray *pickerParentClaim;
@property (strong, nonatomic) NSMutableArray *pickerClaim;

@property (strong, nonatomic) NSMutableArray *arrayClaims;

@property (weak, nonatomic) IBOutlet UITextField *callType;
@property (weak, nonatomic) IBOutlet UITextField *claimUsed;
@property (weak, nonatomic) IBOutlet UITextField *checkInNextDate;
- (IBAction)saveCheckIn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *checkInNextType;


@end
