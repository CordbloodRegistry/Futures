//
//  cbrHospitalFilterViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "cbrHospitalFilterViewController.h"
@class cbrHospitalFilterViewController;

@protocol cbrHospitalFilterViewControllerControllerDelegate
- (void)searchSelected:(cbrHospitalFilterViewController *)controller;
- (void)backButton:(cbrHospitalFilterViewController *)controller;
@end

@interface cbrHospitalFilterViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) id <cbrHospitalFilterViewControllerControllerDelegate> delegate;

-(IBAction)submitted:(id)sender;
-(IBAction)tintSelectedSegment:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *momentumSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *kitStockingSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mouSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *kolSegment;


@property (strong, nonatomic) NSNumber *sortSegmentIndex;
@property (strong, nonatomic) NSNumber *distanceSegmentIndex;
@property (strong, nonatomic) NSNumber *momentumSegmentIndex;
@property (strong, nonatomic) NSNumber *kitStockingSegmentIndex;
@property (strong, nonatomic) NSNumber *mouSegmentIndex;
@property (strong, nonatomic) NSNumber *kolSegmentIndex;
@property (strong, nonatomic) NSString *searchNameString;

@property (weak, nonatomic) IBOutlet UITextField *searchNameField;
- (IBAction)goBack:(id)sender;

@end
