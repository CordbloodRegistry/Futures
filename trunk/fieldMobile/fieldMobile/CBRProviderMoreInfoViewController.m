//
//  CBRProviderMoreInfoViewController.m
//  fieldMobile
//
//  Created by Remina Sangil on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBRProviderMoreInfoViewController.h"

@interface CBRProviderMoreInfoViewController ()
- (void)configureView;
@end

@implementation CBRProviderMoreInfoViewController
@synthesize detailItem = _detailItem;
@synthesize issueText = _issueText;
@synthesize trainedFlagLabel = _trainedFlagLabel;
@synthesize trainedDateLabel = _trainedDateLabel;
@synthesize pwaLoginLabel = _pwaLoginLabel;
@synthesize pwaStatusLabel = _pwaStatusLabel;
@synthesize pwaResetLabel = _pwaResetLabel;
@synthesize pwaLastLoginLabel = _pwaLastLoginLabel;
@synthesize hpnStatusLabel = _hpnStatusLabel;
@synthesize hpnQualifiedLabel = _hpnQualifiedLabel;
@synthesize hpnSignedDateLabel = _hpnSignedDateLabel;
@synthesize noEmailLabel = _noEmailLabel;
@synthesize noFaxLabel = _noFaxLabel;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
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

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *strDate = @"";
        
        
        self.issueText.text = [[self.detailItem  valueForKey:@"issues"] description];
        self.trainedFlagLabel.text = [[self.detailItem  valueForKey:@"kitTrainFlag"] description];
        
        strDate = @"";
        strDate = [dateFormatter stringFromDate:[self.detailItem valueForKey:@"kitTrainDate"]];
        self.trainedDateLabel.text = strDate;
        
        self.pwaStatusLabel.text = [[self.detailItem  valueForKey:@"pwaActiveFlag"] description];
        self.pwaLoginLabel.text = [[self.detailItem  valueForKey:@"pwaLogin"] description];
        self.pwaResetLabel.text = [[self.detailItem  valueForKey:@"pwaResetPwdFlag"] description];
        
        strDate = @"";
        strDate = [dateFormatter stringFromDate:[self.detailItem valueForKey:@"pwaLastLoginDate"]];
        self.pwaLastLoginLabel.text = strDate;

        self.hpnStatusLabel.text = [[self.detailItem  valueForKey:@"hpnActiveFlag"] description];
        self.hpnQualifiedLabel.text = [[self.detailItem  valueForKey:@"hpnQualifiedFlag"] description];
        strDate = @"";
        strDate = [dateFormatter stringFromDate:[self.detailItem valueForKey:@"hpnSignedDate"]];
        self.hpnSignedDateLabel.text = strDate;

        self.noEmailLabel.text = [[self.detailItem  valueForKey:@"noEmail"] description];
        self.noFaxLabel.text = [[self.detailItem  valueForKey:@"noFax"] description];
        
    }
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
    [self setIssueText:nil];
    [self setTrainedFlagLabel:nil];
    [self setTrainedDateLabel:nil];
    [self setPwaLoginLabel:nil];
    [self setPwaStatusLabel:nil];
    [self setPwaResetLabel:nil];
    [self setPwaLastLoginLabel:nil];
    [self setHpnStatusLabel:nil];
    [self setHpnQualifiedLabel:nil];
    [self setHpnSignedDateLabel:nil];
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
    
    if ([[segue identifier] isEqualToString:@"editProvider"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
}

@end
