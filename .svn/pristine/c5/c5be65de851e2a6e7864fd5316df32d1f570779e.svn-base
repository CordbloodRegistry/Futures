//
//  cbrTransactionViewController.m
//  fieldMobile
//
//  Created by Remina Sangil on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrTransactionViewController.h"
#import "cbrAppDelegate.h"

@interface cbrTransactionViewController ()
- (void)configureCell:(cbrTableViewCheckbox *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation cbrTransactionViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize detailItem = _detailItem;


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

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.managedObjectContext == nil) 
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fetchedResultsController = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    //return [self.managedObjectContext 
}

- (cbrTableViewCheckbox *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    cbrTableViewCheckbox *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[cbrTableViewCheckbox alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    } 
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the managed object for the given index path
        //NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        // Save the context.
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }  
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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


#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *statusPredicate = [NSPredicate predicateWithFormat: @"(status = nil)"];
    [fetchRequest setPredicate:statusPredicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"transactionDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
} 

- (void)configureCell:(cbrTableViewCheckbox *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *labelText;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    //NSString *fourDigitYearFormat = [[df dateFormat]
    //                                 stringByReplacingOccurrencesOfString:@"yy"
    //                                 withString:@"yyyy"];
    //[df setDateFormat:fourDigitYearFormat];
    
    NSString *dateText = [[NSString alloc] initWithFormat:@"%@", [df stringFromDate:[managedObject valueForKey:@"transactionDate"]]]; 
    
    //ACTION TASKS
    if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Action"] 
        && [[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Update"])
    {
        
        cell.descText.text = @"Comments = N/A";

        if ([managedObject valueForKey:@"actions"] != NULL)
        {
            NSManagedObject *action = [managedObject valueForKey:@"actions"];
            
            if ([action valueForKey:@"comments"] != NULL)
                cell.descText.text = [[NSString alloc] initWithFormat:@"Activity Id: %@\nType: %@\nDesc: %@\nComments: %@", [[action valueForKey:@"integrationId"] description],[[action valueForKey:@"type"] description], [[action valueForKey:@"note"] description], [[action valueForKey:@"comments"] description]];
            if ([[[action valueForKey:@"status"] description] isEqualToString:@"Done"])
                labelText = @"Close Activity";
            else labelText = @"Save Activity Comment";
        }
    }
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Action"] && [[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Create"])
    {
        cell.descText.text = @"Comments = N/A";
        
        if ([managedObject valueForKey:@"actions"] != NULL)
        {
            NSManagedObject *action = [managedObject valueForKey:@"actions"];
            
            if ([[[action valueForKey:@"status"] description] isEqualToString:@"Done"])
            {
                labelText = @"Call Note";
                cell.descText.text = [[NSString alloc] initWithFormat:@"Type: %@\nClaim: %@\nComments: %@", [[action valueForKey:@"type"] description], [[action valueForKey:@"note"] description], [[action valueForKey:@"longNotes"] description]];
            }
            else {
                labelText = @"Create Follow-up Activity";
                cell.descText.text = [[NSString alloc] initWithFormat:@"Type: %@\nDesc: %@", [[action valueForKey:@"type"] description], [[action valueForKey:@"note"] description]];  
            }
        }
    }
    //KITS TASKS
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Kit"])
    {
        NSManagedObject *kit = [managedObject valueForKey:@"kits"];
        NSManagedObject *ofc = [managedObject valueForKey:@"offices"];
        if (kit != nil)
        {
            if ([[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Transfer"])
                labelText = @"Kit Transfer";
            else if ([[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Receive"])
                labelText = @"Kit Receive";
                
            cell.descText.text = [[NSString alloc] initWithFormat:@"Barcode: %@", [[kit valueForKey:@"depositId"] description]];
        }
        else
        {
            labelText = @"Kit Count";
            cell.descText.text = [[NSString alloc] initWithFormat:@"Facility: %@", [[ofc valueForKey:@"rowId"] description]];
        }
        
    }
    //ORDER TASK
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Order"])
    {
        NSManagedObject *order = [managedObject valueForKey:@"orders"];
        labelText = @"Order Kits";
        cell.descText.text = [[NSString alloc] initWithFormat:@"Quantity: %@", [[order valueForKey:@"quantityRequested"] description]];
        
    }
    //CONTACTS TASKS
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Contact"] && [[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Update"])
    {
        NSManagedObject *contacts = [managedObject valueForKey:@"contacts"];
        if ([[[contacts valueForKey:@"status"] description] isEqualToString:@"Inactive"])
        {
            if ([[[contacts valueForKey:@"role"] description] isEqualToString:@"Provider"])
                labelText = @"Remove Provider Facility Intersect";
            else
                labelText = @"Delete Facility Contact";
            cell.descText.text = [[NSString alloc] initWithFormat:@"First Name: %@\nLast Name: %@\nRole: %@", [[contacts valueForKey:@"firstName"] description], [[contacts valueForKey:@"lastName"] description],[[contacts valueForKey:@"role"] description]];
        }
        else {
            labelText = @"Update Facility Contact";
            if ([[[contacts valueForKey:@"email"] description ] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"First Name: %@\nLast Name: %@\nRole: %@\nEmail: %@", [[contacts valueForKey:@"firstName"] description], [[contacts valueForKey:@"lastName"] description], [[contacts valueForKey:@"role"] description], [[contacts valueForKey:@"email"] description]];
            else
                cell.descText.text = [[NSString alloc] initWithFormat:@"First Name: %@\nLast Name: %@\nRole: %@", [[contacts valueForKey:@"firstName"] description], [[contacts valueForKey:@"lastName"] description], [[contacts valueForKey:@"role"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nOffice: %@", cell.descText.text, [[contacts valueForKey:@"officeId"] description]];
            if ([[[contacts valueForKey:@"officeHours"]  description] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nOffice Hours: %@", cell.descText.text, [[contacts valueForKey:@"officeHours"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nContinuum: %@", cell.descText.text, [[contacts valueForKey:@"continuum"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nKOL: %@", cell.descText.text, [[contacts valueForKey:@"kol"] description]];
        }
    }
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Contact"] && [[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Create"])
    {
        NSManagedObject *contacts = [managedObject valueForKey:@"contacts"];
        labelText = @"Add Facility Contact";
        if ([[contacts valueForKey:@"email"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"First Name: %@\nLast Name: %@\nRole: %@\nEmail: %@", [[contacts valueForKey:@"firstName"] description], [[contacts valueForKey:@"lastName"] description], [[contacts valueForKey:@"role"] description], [[contacts valueForKey:@"email"] description]];
        else
            cell.descText.text = [[NSString alloc] initWithFormat:@"First Name: %@\nLast Name: %@\nRole: %@\nEmail:", [[contacts valueForKey:@"firstName"] description], [[contacts valueForKey:@"lastName"] description], [[contacts valueForKey:@"role"] description]];
        cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nOffice: %@", cell.descText.text, [[contacts valueForKey:@"officeId"] description]];
        cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nContinuum: %@", cell.descText.text, [[contacts valueForKey:@"continuum"] description]];
        cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nKOL: %@", cell.descText.text, [[contacts valueForKey:@"kol"] description]];
        
        
    }
    //PROVIDER TASKS
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Provider"] && [[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Update"])
    {
        NSManagedObject *provider = [managedObject valueForKey:@"providers"];
        if ([[[provider valueForKey:@"status"] description] isEqualToString:@"Inactive"])
        {
            labelText = @"Inactivate Provider";
            cell.descText.text = [[NSString alloc] initWithFormat:@"First Name: %@\nLast Name: %@\nReason: %@", [[provider valueForKey:@"firstName"] description], [[provider valueForKey:@"lastName"] description], [[provider valueForKey:@"inactiveReason"] description]];
        }
        else 
        {
            labelText = @"Update Provider";
            cell.descText.text = [[NSString alloc] initWithFormat:@"First Name: %@\nLast Name: %@", [[provider valueForKey:@"firstName"] description], [[provider valueForKey:@"lastName"] description]];
            if ([[provider valueForKey:@"emailPrimary"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nEmail: %@", cell.descText.text, [[provider valueForKey:@"emailPrimary"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nMonthly Births: %@", cell.descText.text, [[provider valueForKey:@"monthlyBirth"] description]];
            if ([[provider valueForKey:@"issues"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nIssues: %@", cell.descText.text, [[provider valueForKey:@"issues"] description]];
            if ([[provider valueForKey:@"pwaLogin"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nPWA Login: %@", cell.descText.text, [[provider valueForKey:@"pwaLogin"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nNo Email: %@", cell.descText.text, [[provider valueForKey:@"noEmail"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nNo Fax: %@", cell.descText.text, [[provider valueForKey:@"noFax"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nSend PWA Invitation: %@", cell.descText.text, [[provider valueForKey:@"sendPWAInvitation"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nReset PWA Password: %@", cell.descText.text, [[provider valueForKey:@"pwaResetPwdFlag"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nDr Birth Year: %@", cell.descText.text, [[provider valueForKey:@"birthYear"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nKey Account: %@", cell.descText.text, [[provider valueForKey:@"keyAccountMarker"] description]];
            if ([[[provider valueForKey:@"salesContinuum"] description] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nContinuum: %@", cell.descText.text, [[provider valueForKey:@"salesContinuum"] description]];
            if ([[[provider valueForKey:@"pfOfficeHours"] description] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nOffice Hours: %@", cell.descText.text, [[provider valueForKey:@"pfOfficeHours"] description]];
        }
    }    
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Provider"] && [[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Create"])
    {
        NSManagedObject *provider = [managedObject valueForKey:@"providers"];
        labelText = @"Add Provider";
        cell.descText.text = [[NSString alloc] initWithFormat:@"First Name: %@\nLast Name: %@", [[provider valueForKey:@"firstName"] description], [[provider valueForKey:@"lastName"] description]];
        if ([[provider valueForKey:@"emailPrimary"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nEmail: %@", cell.descText.text, [[provider valueForKey:@"emailPrimary"] description]];
        cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nClassification: %@", cell.descText.text, [[provider valueForKey:@"category"] description]];
        cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nCredential: %@", cell.descText.text, [[provider valueForKey:@"credential"] description]];
        cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nDr Birth Year: %@", cell.descText.text, [[provider valueForKey:@"birthYear"] description]];
        if ([[[provider valueForKey:@"salesContinuum"] description] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nContinuum: %@", cell.descText.text, [[provider valueForKey:@"salesContinuum"] description]];
        if ([[[provider valueForKey:@"providerType"] description] isEqualToString:@"Resident"])
             cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nResident: Y", cell.descText.text];
        if ([[[provider valueForKey:@"pfOfficeHours"] description] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nOffice Hours: %@", cell.descText.text, [[provider valueForKey:@"pfOfficeHours"] description]];
    }
    //FACILITY TASKS
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Facility"] && [[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Update"])
    {
        NSManagedObject *office = [managedObject valueForKey:@"offices"];
        if ([[[office valueForKey:@"status"] description] isEqualToString:@"Inactive"])
        {
            labelText = @"Inactivate Facility";
            cell.descText.text = [[NSString alloc] initWithFormat:@"Name: %@\nType: %@\nReason: %@", [[office valueForKey:@"name"] description], [[office valueForKey:@"officeType"] description], [[office valueForKey:@"inactiveReason"] description]];
        }
        else {
            labelText = @"Update Facility";
            cell.descText.text = [[NSString alloc] initWithFormat:@"Name: %@\nType: %@", [[office valueForKey:@"name"] description], [[office valueForKey:@"officeType"] description]];
            if ([[office valueForKey:@"mainPhone"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nPhone: %@", cell.descText.text, [[office valueForKey:@"mainPhone"] description]];
            if ([[office valueForKey:@"mainFax"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nFax: %@", cell.descText.text, [[office valueForKey:@"mainFax"] description]];
            if ([[office valueForKey:@"notes"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nIssues: %@", cell.descText.text, [[office valueForKey:@"notes"] description]];
            if ([[office valueForKey:@"competitor1"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nCompetitor 1: %@", cell.descText.text, [[office valueForKey:@"competitor1"] description]];
            if ([[office valueForKey:@"competitor2"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nCompetitor 2: %@", cell.descText.text, [[office valueForKey:@"competitor2"] description]];
            if ([[[office valueForKey:@"officeType"] description] isEqualToString:@"Hospital"])
            {
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nAnnual Births: %@", cell.descText.text, [[office valueForKey:@"annualBirths"] description]];
            }
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nStocking Office: %@", cell.descText.text, [[office valueForKey:@"stockingOffice"] description]];
            if ([[office valueForKey:@"kitLocation"] length] > 0)
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nKit Location: %@", cell.descText.text, [[office valueForKey:@"kitLocation"] description]];
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nKit Re-Order: %@", cell.descText.text, [[office valueForKey:@"kitThreshold"] description]];
            if ([[[office valueForKey:@"officeType"] description] isEqualToString:@"Office"])
            {
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nCharges Patient: %@", cell.descText.text, [[office valueForKey:@"chargesPatient"] description]];
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nAmount Charged: %@", cell.descText.text, [[office valueForKey:@"amountCharged"] description]];
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\n%% Cash pay: %@", cell.descText.text, [[office valueForKey:@"percentCashPay"] description]];
                cell.descText.text = [[NSString alloc] initWithFormat:@"%@\n%% Medicaid: %@", cell.descText.text, [[office valueForKey:@"percentMedicaid"] description]];
                
                
            }
        }
    }
    else if ([[[managedObject valueForKey:@"entityType"] description] isEqualToString:@"Facility"] && [[[managedObject valueForKey:@"transactionType"] description] isEqualToString:@"Create"])
    {
        NSManagedObject *office = [managedObject valueForKey:@"offices"];
        labelText = @"Add Facility";
        cell.descText.text = [[NSString alloc] initWithFormat:@"Name: %@\nType: %@", [[office valueForKey:@"name"] description], [[office valueForKey:@"officeType"] description]];
        if ([[office valueForKey:@"addr"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nAddr: %@", cell.descText.text, [[office valueForKey:@"addr"] description]];
        if ([[office valueForKey:@"addr2"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nAddr 2: %@", cell.descText.text, [[office valueForKey:@"addr2"] description]];
        if ([[office valueForKey:@"city"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nCity: %@", cell.descText.text, [[office valueForKey:@"city"] description]];
        if ([[office valueForKey:@"state"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nState: %@", cell.descText.text, [[office valueForKey:@"state"] description]];
        if ([[office valueForKey:@"zipcode"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nZipcode: %@", cell.descText.text, [[office valueForKey:@"zipcode"] description]];
        if ([[office valueForKey:@"mainPhone"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nPhone: %@", cell.descText.text, [[office valueForKey:@"mainPhone"] description]];
        if ([[office valueForKey:@"mainFax"] length] > 0)
            cell.descText.text = [[NSString alloc] initWithFormat:@"%@\nFax: %@", cell.descText.text, [[office valueForKey:@"mainFax"] description]];
        
        
    }
    //DEFAULT
    else {
        labelText = [[NSString alloc] initWithFormat:@"%@ - %@", [[managedObject valueForKey:@"entityType"] description], [[managedObject valueForKey:@"transactionType"] description]];
        cell.descText.text = @"";
    }
    cell.nameLabel.text = labelText;
    cell.dateLabel.text=dateText;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
            
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];

    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [userDef setValue:@"Y" forKey:@"rmFullSync"];
            [userDef synchronize];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(cbrTableViewCheckbox *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
