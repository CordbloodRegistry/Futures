//
//  cbrInventoryViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrInventoryViewController.h"
#import "cbrInventoryScanViewController.h"
#import "DeselectableUISegmentedControl.h"
#import "cbrHospitalDetailViewController.h"
#import "cbrActionOrderViewController.h"
#import "cbrTableViewCell.h"
#import "cbrAppDelegate.h"

@interface cbrInventoryViewController ()
- (void)configureCell:(cbrTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath UpdateType:(NSString *)type;
@end

@implementation cbrInventoryViewController

@synthesize scanTypeSegment = _scanTypeSegment;
@synthesize fetchResultsArray = _fetchResultsArray;
@synthesize detailItem = _detailItem;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize scanType = _scanType;

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.managedObjectContext == nil)
    {
        //self.managedObjectContext = [self.detailItem managedObjectContext];
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *rmStorageId = [userDef stringForKey:@"rmStorageId"];
    NSString *rmStorage = [userDef stringForKey:@"rmStorage"];
    
    NSString *ofcId;
    NSString *entityName = [[self.detailItem entity] name];
    bool stockKits = NO;
    if (entityName != Nil)
    {
        if ([entityName isEqualToString:@"Offices"])
            ofcId = [[self detailItem] valueForKey:@"rowId"];
        else
            ofcId = [[self detailItem] valueForKey:@"facilityId"];
            
        NSManagedObjectContext *moc = [self.detailItem managedObjectContext];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        NSEntityDescription *ofcEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
        [fr setEntity:ofcEntity];
        
        NSPredicate *ofcPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)",ofcId];
        [fr setPredicate:ofcPredicate];
        
        NSArray *ofcArray = [moc executeFetchRequest:fr error:nil];
        for (NSManagedObject *office in ofcArray)
            if ([[office valueForKey:@"stockingOffice"] isEqualToString:@"Y"])
                stockKits = YES;
    }
    //Kit Count/Transfer/Receive is only enabled if -
    // - RM has a dropoff location
    // - facility is kit stocking
    if (([rmStorage length] > 0 && [rmStorageId length] > 0) && stockKits)
    {
        self.scanTypeSegment.hidden = FALSE;
        self.scanTypeSegment.userInteractionEnabled = TRUE;
    }
    else
    {
        self.scanTypeSegment.hidden = TRUE;
        self.scanTypeSegment.userInteractionEnabled = FALSE;
    }

}

- (void)viewDidUnload
{
    [self setScanTypeSegment:nil];
    [self setScanTypeSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    static NSString *CellIdentifier = @"Cell";
    
    cbrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [self configureCell:cell atIndexPath:indexPath UpdateType:@"new"];
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } 
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    // NEED TO TEST THIS ONE OUT.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
    return self.editing;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"scanKits"]) {
        cbrInventoryScanViewController *scanController = (cbrInventoryScanViewController *)[segue destinationViewController];
        scanController.scanType = self.scanType;
        scanController.detailItem = self.detailItem;
    }
    if ([[segue identifier] isEqualToString:@"orderKits"])
    {
        cbrActionOrderViewController *orderController = (cbrActionOrderViewController *)[segue destinationViewController];
        orderController.detailItem = self.detailItem;
    }
    if ([[segue identifier] isEqualToString:@"seeOffice"]) {
        cbrHospitalDetailViewController *officeView = (cbrHospitalDetailViewController *)[segue destinationViewController];
        NSManagedObjectContext *moc = self.managedObjectContext;
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        [fr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc]];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(rowId = %@)",[[self.fetchResultsArray objectAtIndex:indexPath.row] valueForKey:@"assignedOfficeId"]];
        [fr setPredicate:predicate];
        
        NSArray *resultsArray = [moc executeFetchRequest:fr error:nil];
        if ([resultsArray count]>0)
        {
            officeView.detailItem = [resultsArray objectAtIndex:0];
        }
    }
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Kits" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set filter
    
    NSPredicate *statusPredicate = [NSPredicate predicateWithFormat:@"(status != %@ || status == nil)", @"Inactive/Lost"];
    
    // Set filter
    if (self.detailItem != nil) {
        NSString *relationshipName;
        NSString *entityName = [[self.detailItem entity] name];
        NSPredicate *myPredicate;
        if ([entityName isEqualToString:@"Offices"]) {	
            relationshipName = @"assignedOfficeId == %@";
            myPredicate = [NSPredicate predicateWithFormat:relationshipName, [[self detailItem] valueForKey:@"rowId"]];
            
            if ([[[self detailItem] valueForKey:@"officeType"] isEqualToString:@"RM Dropoff Location"])
            {
                NSFetchRequest *fr = [[NSFetchRequest alloc] init];
                [fr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:self.managedObjectContext]];
                [fr setPredicate:[NSPredicate predicateWithFormat:@"officeType =%@",@"RM Dropoff Location"]];
                NSArray *rmOfficeArray = [self.managedObjectContext executeFetchRequest:fr error:nil];
                relationshipName = @"";
                for (NSManagedObject *item in rmOfficeArray)
                {
                    if ([relationshipName isEqualToString:@""]) {
                        relationshipName = [NSString stringWithFormat:@"assignedOfficeId == '%@'",[item valueForKey:@"rowId"]];
                    }
                    else {
                        relationshipName = [NSString stringWithFormat:@"%@ || assignedOfficeId == '%@'",relationshipName, [item valueForKey:@"rowId"]];
                    }
                }
                myPredicate = [NSPredicate predicateWithFormat:relationshipName];
            }
            
        }
        if ([entityName isEqualToString:@"Providers"]) {
            relationshipName = @"assignedOfficeId == %@";
            myPredicate = [NSPredicate predicateWithFormat:relationshipName, [[self detailItem] valueForKey:@"facilityId"]];
            /*if (![[[self detailItem] valueForKey:@"stockingDoc"] isEqualToString:@"Y"])
            {
                
            //relationshipName = @"assignedContactId == %@";
                myPredicate = [NSPredicate predicateWithFormat:relationshipName, @"zzzzz"];
            }*/
        }
        
        NSPredicate * newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:statusPredicate, myPredicate, nil]];
        
        //[fetchRequest setPredicate:myPredicate];      
        [fetchRequest setPredicate:newPredicate];   
    }
    else {
        NSDate *today = [NSDate date];
        int daysToAdd = 180;  
        NSDate *agingDate = [today dateByAddingTimeInterval:60*60*24*daysToAdd];

        NSPredicate *myPredicate = [NSPredicate predicateWithFormat: @"(expirationDate == NULL || expirationDate <= %@)",agingDate];
        
        NSPredicate * newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:statusPredicate, myPredicate, nil]];
        
        [fetchRequest setPredicate:newPredicate];   
        //[fetchRequest setPredicate:myPredicate];   
    }
    /*
    else {
        NSString *rmRowId = @"1-31-490";    // need to automate this piece
        NSString *relationshipName = @"assignedContactId == %@";
        NSPredicate *myPredicate = [NSPredicate predicateWithFormat:relationshipName, rmRowId];
        NSPredicate * newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:statusPredicate, myPredicate, nil]];
        
        [fetchRequest setPredicate:newPredicate];
    }
*/
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"expirationDate" ascending:YES], nil]];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [self sortMyResults];
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

- (void)sortMyResults;
{
    //added to sort the list of facilities by distance.
    NSArray *recordSet = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.fetchedResultsController.fetchRequest error:NULL];
	if (self.detailItem != nil)
    {
        self.fetchResultsArray = recordSet;
    }
    else {
        // sort by distance, then show results
        self.fetchResultsArray = [recordSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *name = @"ZZZZZ";
            NSString *otherName = @"ZZZZZ";
            NSManagedObjectContext *moc = [self managedObjectContext];
            
            NSString *assignedOfficeIda = [a valueForKey:@"assignedOfficeId"];            
            if ([assignedOfficeIda length] > 0 && (assignedOfficeIda != Nil))
            {
                NSFetchRequest *fr = [[NSFetchRequest alloc] init];
                [fr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc]];
                [fr setPredicate:[NSPredicate predicateWithFormat: @"(rowId = %@)", assignedOfficeIda]];
                NSArray *officeArraya = [moc executeFetchRequest:fr error:nil];
                for (NSManagedObject *officea in officeArraya) {
                    name = [NSString stringWithFormat:@"%@",[officea valueForKey:@"name"]];
                }
            }
            NSString *assignedOfficeIdb = [b valueForKey:@"assignedOfficeId"];
            if ([assignedOfficeIdb length] > 0 && (assignedOfficeIdb != Nil))
            {
                NSFetchRequest *fr = [[NSFetchRequest alloc] init];
                [fr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc]];
                [fr setPredicate:[NSPredicate predicateWithFormat: @"(rowId = %@)", assignedOfficeIdb]];
                NSArray *officeArrayb = [moc executeFetchRequest:fr error:nil];
                for (NSManagedObject *officeb in officeArrayb) {
                    otherName = [NSString stringWithFormat:@"%@",[officeb valueForKey:@"name"]];
                }
            }
            
            return [name compare:otherName options:NSCaseInsensitiveSearch];
        }];
    }
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self sortMyResults];
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
    //UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:            
            if (self.fetchResultsArray.count > indexPath.row)
                [self configureCell:(cbrTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath UpdateType:@"update"];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
    [self.tableView endUpdates];
}

- (void)configureCell:(cbrTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath UpdateType:(NSString *)type {
    NSManagedObject *managedObject;
    
    //if ([type isEqualToString:@"update"])
   //     managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //else
        managedObject = [self.fetchResultsArray objectAtIndex:indexPath.row];
    
    NSString *sProductName = [managedObject valueForKey:@"product"];
    if ([sProductName length] > 50)
        sProductName = [sProductName substringWithRange:NSMakeRange(0,50)];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *fourDigitYearFormat = [[df dateFormat]
                                     stringByReplacingOccurrencesOfString:@"yy"
                                     withString:@"yyyy"];
    [df setDateFormat:fourDigitYearFormat];
    
    NSString *labelText = [[NSString alloc] initWithFormat:@"%@",sProductName];
    
    NSString *detailText = [[NSString alloc] initWithFormat:@"%@", [df stringFromDate:[managedObject valueForKey:@"expirationDate"]]];
    
    if ([sProductName rangeOfString:@"CBCT Dual Kit"].location == NSNotFound) {
        [cell.momentumImage setImage:[UIImage imageNamed: @"cbr old kit.png"]];
    }
    else {
        [cell.momentumImage setImage:[UIImage imageNamed: @"cbr current kit.png"]];
    }

    NSString *assignedOfficeId = [managedObject valueForKey:@"assignedOfficeId"];
    if ([assignedOfficeId length] > 0 && (assignedOfficeId != Nil))
    {
        NSManagedObjectContext *moc = [managedObject managedObjectContext];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        NSEntityDescription *officeEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
        [fr setEntity:officeEntity];
        NSPredicate *officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", assignedOfficeId];
        [fr setPredicate:officePredicate];
        NSArray *officeArray = [moc executeFetchRequest:fr error:nil];
        
        for (NSManagedObject *office in officeArray) {
            //cell.nameLabel.text = [[NSString alloc] initWithFormat:@"%@, %@",[office valueForKey:@"name"],[office valueForKey:@"city"]];
            cell.nameLabel.text = [[NSString alloc] initWithFormat:@"%@",[office valueForKey:@"name"]];
        }
        
    }
    cell.addressLabel.text = labelText;
    cell.distanceLabel.text = [managedObject valueForKey:@"depositId"];
    cell.subtitleLabel.text=detailText;
}

- (IBAction)initiateScan:(id)sender {
    int segmentindex = self.scanTypeSegment.selectedSegmentIndex;
    
    switch(segmentindex)
    {
        case 0:
            self.scanType = @"transfer";
            break;
        case 1:
            self.scanType = @"count";
            break;
        case 2:
            self.scanType = @"order";
            break;
        default:
            break;
    }
            
    self.scanTypeSegment.selectedSegmentIndex = -1;
    if ([self.scanType isEqualToString:@"order"])
        [self performSegueWithIdentifier:@"orderKits" sender:self];
    else
        [self performSegueWithIdentifier:@"scanKits" sender:self];
}
@end
