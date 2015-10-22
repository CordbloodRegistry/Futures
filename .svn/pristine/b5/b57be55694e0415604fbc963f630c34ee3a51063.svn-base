//
//  cbrContactsViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrContactsViewController.h"
#import "cbrListTableViewCell.h"
#import "cbrAppDelegate.h"

@interface cbrContactsViewController ()
- (void)configureCell:(cbrListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)recordTransaction:(NSManagedObject *) obj;
@end

@implementation cbrContactsViewController

@synthesize detailItem = _detailItem;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

- (cbrListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    static NSString *CellIdentifier = @"Cell";
    
    cbrListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
    return self.editing;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self inactivateContact:[self.fetchedResultsController objectAtIndexPath:indexPath]];

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

-(void) inactivateContact:(NSManagedObject *)obj
{
    NSManagedObjectContext *context = [obj managedObjectContext];
    if ([[[obj entity] name] isEqualToString:@"Contacts"])
    {
        NSLog(@"%@ %@",[obj valueForKey:@"status"], [obj valueForKey:@"officeId"]);
        [obj setValue:@"Inactive" forKey:@"status"];
        if ([obj valueForKey:@"officeId"] != NULL)
        {
            NSEntityDescription *officeEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:context];
            NSFetchRequest *fr = [[NSFetchRequest alloc] init];
            [fr setEntity:officeEntity];
            
            // Set example predicate and sort orderings..
            NSPredicate *actionPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [obj valueForKey:@"officeId"]];
            [fr setPredicate:actionPredicate];
            
            NSSortDescriptor *SortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
            [fr setSortDescriptors:[NSArray arrayWithObject:SortDescriptor]];
            
            NSArray *officeArray = [context executeFetchRequest:fr error:nil];
            
            for (NSManagedObject *office in officeArray)
            {
                [obj setValue:office forKey:@"contactOffice"];
            }
        }

        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self recordTransaction:obj];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addContact"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
    if ([[segue identifier] isEqualToString:@"editContact"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:selectedObject];
    }
    if ([[segue identifier] isEqualToString:@"createContact"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Set filter
    if (self.detailItem != nil)
    {
        NSPredicate *myPredicate;
        if ([[[self detailItem] valueForKey:@"officeType"] isEqualToString:@"Hospital"])
        {
            myPredicate = [NSPredicate predicateWithFormat:@"(officeId = %@) AND (role <> 'Provider' OR role = null)", [[self detailItem] valueForKey:@"rowId"]];
    
        }
        else
        {
            myPredicate = [NSPredicate predicateWithFormat:@"officeId = %@", [[self detailItem] valueForKey:@"rowId"]];
        }
        [fetchRequest setPredicate:myPredicate];
    }
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"role" ascending:YES];
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
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(cbrListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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


- (void)configureCell:(cbrListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *labelText = [[NSString alloc] initWithFormat:@"%@ %@", [[managedObject valueForKey:@"firstName"] description], [[managedObject valueForKey:@"lastName"] description]];
    NSString *detailText = [[managedObject valueForKey:@"role"] description]; 
    NSString *momentumText = [[managedObject valueForKey:@"momentumRating"] description]; 
    
    cell.leftLabel.text = labelText;
    cell.rightLabel.text = detailText;
    if ([detailText isEqualToString:@"Provider"])
    {
        cell.middleLabel.text = momentumText;
        cell.middleLabel.hidden = false;
        cell.favoriteButton.hidden = true;
    }
    else 
    {
        cell.middleLabel.text = @"";
        cell.middleLabel.hidden = true;
        cell.favoriteButton.hidden = false;
    }
    cell.favoriteButton.tag = indexPath.row;
    if ([[[managedObject  valueForKey:@"kol"] description] isEqualToString:@"Y"])
        cell.favoriteButton.selected = TRUE;
    else
        cell.favoriteButton.selected = FALSE;

    
    
}
- (void)recordTransaction:(NSManagedObject *)obj
{
    NSManagedObjectContext *context = [self.detailItem managedObjectContext];
    NSManagedObject *newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:context];
    
    NSDate *today = [NSDate date];
    
    //current location
    CLLocationManager *clm = [[CLLocationManager alloc] init];
    
    //self.locationManager.delegate = self;
    clm.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    // Set a movement threshold for new events.
    clm.distanceFilter = 500;
    
    [clm startUpdatingLocation];
    
    CLLocation *myLocation = [clm location];
    
    [newTransaction setValue:@"Contact" forKey:@"entityType"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.latitude] forKey:@"latitude"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.longitude] forKey:@"longitude"];
    [newTransaction setValue:today forKey:@"transactionDate"];
    [newTransaction setValue:@"Update" forKey:@"transactionType"];
    
    
    [clm stopUpdatingLocation];
    
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    
    [context save:nil];
}


-(IBAction)tapFavoriteButton:(UIButton*)button
{
    NSManagedObject *managedObject;
    NSIndexPath *path = [NSIndexPath indexPathForRow:button.tag inSection:0];
    managedObject = [self.fetchedResultsController objectAtIndexPath:path];
    if (button.selected)
        [managedObject setValue:@"N" forKey:@"kol"];
    else
        [managedObject setValue:@"Y" forKey:@"kol"];
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:[NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:self.managedObjectContext]];
    //intersectId
    //NSPredicate *officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@ and officeId = %@)", [[managedObject  valueForKey:@"rowId"] description], [[managedObject  valueForKey:@"officeId"] description]];
    NSPredicate *officePredicate = [NSPredicate predicateWithFormat: @"(intersectId = %@)", [[managedObject  valueForKey:@"intersectId"] description]];
    [fr setPredicate:officePredicate];
    NSArray *provArray = [moc executeFetchRequest:fr error:nil];
    [[provArray objectAtIndex:0] setValue:[managedObject valueForKey:@"kol"] forKey:@"kol"];
    
    [self recordTransaction:[provArray objectAtIndex:0]];
    
    if (![[managedObject managedObjectContext] save:nil]) {
        NSLog(@"Unresolved error %@, %@", nil, nil);
        abort();
    }

}


@end
