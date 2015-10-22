//
//  cbrHomeViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
@interface cbrHomeViewController : UITableViewController <NSFetchedResultsControllerDelegate,MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
	long long expectedLength;
	long long currentLength;
    UIBackgroundTaskIdentifier syncTask;
    NSOperationQueue *operationQueue;
    Reachability* reachability;

}
@property (strong, nonatomic) id appObject;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) NSManagedObjectContext *adManagedObjectContext;
@property (strong, nonatomic) NSNumber *syncNumProviders;
@property (strong, nonatomic) NSString *authenticationToken;
@property (strong, nonatomic) NSString *errorReason;
@property (strong, nonatomic) NSMutableArray *syncNextFUP;
@property (strong, nonatomic) IBOutlet UITableViewCell *openActivitiesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *kitsCell;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *syncButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *unusableKitsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *heroCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *syncCell;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UILabel *ACDvsTotal;
@property (weak, nonatomic) IBOutlet UILabel *NewEnrollments;
@property (weak, nonatomic) IBOutlet UILabel *Educated;
@property (weak, nonatomic) IBOutlet UILabel *CTCB_Ratio;
@property (weak, nonatomic) IBOutlet UILabel *TotalOpptys;
@property (weak, nonatomic) IBOutlet UILabel *Total_Enrollments;
@property (weak, nonatomic) IBOutlet UILabel *TotalCBStorages;
@property (weak, nonatomic) IBOutlet UILabel *TotalCTStorages;
@property (weak, nonatomic) IBOutlet UILabel *LastSyncDate;
@property (nonatomic, retain) Reachability* reachability;

- (IBAction)synchronizeApp:(id)sender;
@end
