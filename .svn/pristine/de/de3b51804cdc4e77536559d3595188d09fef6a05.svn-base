//
//  cbrNoteViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cbrTableViewCell.h"

@interface cbrNoteViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchResultsArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)clickSegmentControl:(id)sender;
-(void)tintSelectedSegment:(id)sender;
@end
