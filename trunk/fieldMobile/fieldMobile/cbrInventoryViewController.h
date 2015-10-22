//
//  cbrInventoryViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeselectableUISegmentedControl.h"

@interface cbrInventoryViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *scanType;
@property (strong, nonatomic) NSArray *fetchResultsArray;

- (IBAction)initiateScan:(id)sender;
@property (strong, nonatomic) IBOutlet DeselectableUISegmentedControl *scanTypeSegment;

@end
