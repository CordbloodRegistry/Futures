//
//  CBRProviderMoreInfoViewController.h
//  fieldMobile
//
//  Created by Remina Sangil on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBRProviderMoreInfoViewController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITextView *issueText;
@property (weak, nonatomic) IBOutlet UILabel *trainedFlagLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwaLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwaStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwaResetLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwaLastLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *hpnStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *hpnQualifiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *hpnSignedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *noFaxLabel;

@end
