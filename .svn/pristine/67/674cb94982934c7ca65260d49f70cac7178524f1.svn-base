//
//  cbrHospitalMoreInfoViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrHospitalMoreInfoViewController.h"

@interface cbrHospitalMoreInfoViewController ()
- (void)configureView;
@end

@implementation cbrHospitalMoreInfoViewController

@synthesize detailItem = _detailItem;
@synthesize detailFacilityIssue = _detailFacilityIssue;
@synthesize detailKitStockingFlg = _detailKitStockingFlg;
@synthesize detailKitStockingLocation = _detailKitStockingLocation;
@synthesize detailReorderThreshold = _detailReorderThreshold;
@synthesize detailLastKitCount = _detailLastKitCount;
@synthesize detailCurrentInventory = _detailCurrentInventory;
@synthesize detailMOU = _detailMOU;
@synthesize detailNPP = _detailNPP;
@synthesize detailLAP = _detailLAP;
@synthesize cellLocation = _cellLocation;
@synthesize cellReOrderThreshold = _cellReOrderThreshold;
@synthesize cellKitCountDate = _cellKitCountDate;
@synthesize cellCurrentInventory = _cellCurrentInventory;
@synthesize cellSeeKit = _cellSeeKit;
@synthesize detailChargesPatient = _detailChargesPatient;
@synthesize detailChargedAmount = _detailChargedAmount;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailFacilityIssue.text = [[self.detailItem  valueForKey:@"notes"] description];
        self.detailKitStockingFlg.text = [[NSString alloc] initWithFormat:@"Kit Stocking: %@", [[self.detailItem valueForKey:@"stockingOffice"] description]];
        self.detailKitStockingLocation.text = [[NSString alloc] initWithFormat:@"Kit Location: %@", [[self.detailItem valueForKey:@"kitLocation"] description]];

        
        self.detailKitContact.text = [[NSString alloc] initWithFormat:@"Kit Contact: %@ %@", [[self.detailItem valueForKey:@"kitContactFirstName"] description],[[self.detailItem valueForKey:@"kitContactLastName"] description]];
        //pull name based on kitContactId if available
        if ([[[self.detailItem valueForKey:@"kitContactId"] description] length] > 0)
        {
            
            NSManagedObjectContext *context = [self.detailItem managedObjectContext];
            NSEntityDescription *conEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:context];
            NSFetchRequest *fr = [[NSFetchRequest alloc] init];
            [fr setEntity:conEntity];
            
            // Set example predicate and sort orderings..
            NSPredicate *conPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [self.detailItem valueForKey:@"kitContactId"]];
            [fr setPredicate:conPredicate];
            
            NSArray *conArray = [context executeFetchRequest:fr error:nil];
            
            for (NSManagedObject *contact in conArray)
            {
                self.detailKitContact.text = [[NSString alloc] initWithFormat:@"Kit Contact: %@ %@", [[contact valueForKey:@"firstName"] description],[[contact valueForKey:@"lastName"] description]];
            }
        }
        self.detailReorderThreshold.text = [[NSString alloc] initWithFormat:@"Kit Re-Order Threshold: %@", [[self.detailItem valueForKey:@"kitThreshold"] description]];
        self.detailLastKitCount.text = [[NSString alloc] initWithFormat:@"Last Kit Count On: %@", @"coming soon."];
        self.detailCurrentInventory.text = [[NSString alloc] initWithFormat:@"Current Inventory: %@", @"coming soon."];
        
        if ([self.detailItem  valueForKey:@"mouStartDate"] != Nil && [self.detailItem  valueForKey:@"mouEndDate"] == Nil)
        {
            NSDate *inputString = [self.detailItem  valueForKey:@"mouStartDate"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:inputString]];
            self.detailMOU.text = [[NSString alloc] initWithFormat:@"MOU Agreed On: %@", textDate];
        }
        else
            self.detailMOU.text = [[NSString alloc] initWithFormat:@"MOU Agreed On: %@", @"No agreement In Place"];
        self.detailNPP.text = [[NSString alloc] initWithFormat:@"Lifetime NPP: %@", @"coming soon."];
        self.detailLAP.text = [[NSString alloc] initWithFormat:@"Low Apgar: %@", @"coming soon."];
        //self.detailECBBP.text = [[NSString alloc] initWithFormat:@"Emergency Protocol: %@", @"coming soon."];
        self.detailChargesPatient.text = [[NSString alloc] initWithFormat:@"Charges Patient: %@", [[self.detailItem valueForKey:@"chargesPatient"] description]];
        self.detailChargedAmount.text = [[NSString alloc] initWithFormat:@"Amount Charged: $%@", [[self.detailItem valueForKey:@"amountCharged"] description]];

        NSManagedObjectContext *moc = [[self detailItem] managedObjectContext];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        [fr setEntity:[NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc]];
        [fr setPredicate:[NSPredicate predicateWithFormat: @"(assignedOfficeId = %@ AND status != %@)",[self.detailItem valueForKey:@"rowId"], @"Inactive/Lost"]];
        NSArray *kits = [moc executeFetchRequest:fr error:nil];
//        for (NSManagedObject *item in kits)
//        {
//            NSLog(@"%@",[item valueForKey:@"depositId"]);
//        }
        int kitCount = [kits count];
        self.detailCurrentInventory.text = [[NSString alloc] initWithFormat:@"Current Inventory: %d",kitCount];
     }
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //[self configureView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
}
- (void)viewDidUnload
{
    [self setDetailFacilityIssue:nil];
    [self setDetailMOU:nil];
    [self setDetailKitStockingFlg:nil];
    [self setDetailKitStockingLocation:nil];
    [self setDetailReorderThreshold:nil];
    [self setDetailLastKitCount:nil];
    [self setDetailCurrentInventory:nil];
    [self setDetailNPP:nil];
    [self setDetailLAP:nil];
    [self setDetailMOU:nil];
    [self setCellLocation:nil];
    [self setCellReOrderThreshold:nil];
    [self setCellKitCountDate:nil];
    [self setCellCurrentInventory:nil];
    [self setCellSeeKit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editOffice"] | [[segue identifier] isEqualToString:@"seeKits"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"])
        return 5;
    else
        return 3;   //Hide from NPP and MOU for Office
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"] && section == 2)
    {
        //Hide Additional Info for Hospital
        return 0;
    }
    else
    {
        switch (section) {
            case 0:     //Comments
                return 1;
                break;
                
            case 1:     //Kit Stocking Info
                return 6;
                break;
                
            case 2:     //Additional Info
                return 2;
                break;

            case 3:     //MOU
                return 1;
                break;
            case 4:     //NPP
                return 2;
                break;
            default:
                return 0;
        }
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //hides Additional Information for Hospital
    if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"] && section == 2)
        return [[UIView alloc] initWithFrame:CGRectZero];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //hides Additional Information for Hospital
    if ([[self.detailItem valueForKey:@"officeType"] isEqualToString:@"Hospital"] && section == 2)
        return 1;
    return 32;
}
@end
