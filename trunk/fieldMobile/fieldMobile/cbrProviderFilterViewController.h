//
//  cbrProviderFilterViewController.h
//  fieldMobile
//
//  Created by Remina Sangil on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class cbrProviderFilterViewController;

@protocol cbrProviderFilterViewControllerControllerDelegate
- (void)searchSelected:(cbrProviderFilterViewController *)controller;
- (void)backButton:(cbrProviderFilterViewController *)controller;
@end

@interface cbrProviderFilterViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) id <cbrProviderFilterViewControllerControllerDelegate> delegate;

-(IBAction)submitted:(id)sender;
-(IBAction)backButton:(id)sender;
-(IBAction)tintSelectedSegment:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *momentumSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *kitStockingSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mouSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *kolSegment;
@property (weak, nonatomic) IBOutlet UITextField *searchFirstNameField;
@property (weak, nonatomic) IBOutlet UITextField *searchLastNameField;
@property (weak, nonatomic) IBOutlet UITextField *searchFacilityField;


@property (strong, nonatomic) NSNumber *sortSegmentIndex;
@property (strong, nonatomic) NSNumber *distanceSegmentIndex;
@property (strong, nonatomic) NSNumber *momentumSegmentIndex;
@property (strong, nonatomic) NSNumber *kitStockingSegmentIndex;
@property (strong, nonatomic) NSNumber *mouSegmentIndex;
@property (strong, nonatomic) NSNumber *kolSegmentIndex;
@property (strong, nonatomic) NSString *searchFirstNameString;
@property (strong, nonatomic) NSString *searchLastNameString;
@property (strong, nonatomic) NSString *searchFacilityString;



@end

