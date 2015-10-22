//
//  cbrProviderDetailViewController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cbrProviderDetailViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *providerIDLabel;

@property (strong, nonatomic) NSManagedObject *myObject;

@property (weak, nonatomic) IBOutlet UILabel *facilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *momentumLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *continuumLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *officeHoursLabel;

@property (weak, nonatomic) IBOutlet UIImageView *momentumImage;

@property (weak, nonatomic) IBOutlet UILabel *numBirthLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UILabel *avgQualityScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *numOfCalls;
@property (strong, nonatomic) IBOutlet UITableViewCell *openActivitiesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *kitsCell;

@property (weak, nonatomic) IBOutlet UILabel *ACDvsTotal;
@property (weak, nonatomic) IBOutlet UILabel *NewEnrollments;
@property (weak, nonatomic) IBOutlet UILabel *Educated;
@property (weak, nonatomic) IBOutlet UILabel *CTCB_Ratio;
@property (weak, nonatomic) IBOutlet UILabel *TotalOpptys;
@property (weak, nonatomic) IBOutlet UILabel *Total_Enrollments;
@property (weak, nonatomic) IBOutlet UILabel *TotalCBStorages;
@property (weak, nonatomic) IBOutlet UILabel *TotalCTStorages;
@property (weak, nonatomic) IBOutlet UILabel *PenetrationRate;



- (IBAction)callPhone:(id)sender;
- (IBAction)mapDirections:(id)sender;

@end
