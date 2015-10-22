//
//  cbrOfficesChooseViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cbrOfficesAddViewController.h"

@class cbrOfficesChooseViewController;

@protocol cbrOfficesChooseViewControllerDelegate
- (void)recordSelected:(cbrOfficesChooseViewController *)controller;
@end

@interface cbrOfficesChooseViewController : UITableViewController <NSFetchedResultsControllerDelegate,UISearchBarDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id <cbrOfficesChooseViewControllerDelegate> delegate;

@property (strong, nonatomic) id nOfficeItem;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (assign, nonatomic) BOOL bSearchIsOn;
@property (strong, nonatomic) NSArray* allTableData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;

@end
