//
//  cbrNoteViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrNoteViewController.h"
#import "cbrCheckInViewController.h"
#import "cbrAppDelegate.h"
#import "cbrTableViewCell.h"

@interface cbrNoteViewController ()
- (void)configureCell:(cbrTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation cbrNoteViewController

@synthesize detailItem = _detailItem;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchResultsArray = _fetchResultsArray;
@synthesize segmentedControl = _segmentedControl;

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
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    UIColor *newTintColor = [UIColor colorWithRed: 64/255.0 green:18/255.0 blue:128/255.0 alpha:1.0];
    self.segmentedControl.tintColor = newTintColor;
    
    for (int i=0; i<[self.segmentedControl.subviews count]; i++) 
    {
        if ([[self.segmentedControl.subviews objectAtIndex:i]isSelected] ) 
        {               
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.segmentedControl.subviews objectAtIndex:i] setTintColor:tintcolor];
            break;
        }
    }    
    
}

- (void)viewDidUnload
{
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

- (cbrTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"Cell";
    
    cbrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
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
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
    return self.editing;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"updateActivity"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *selectedObject = [[self fetchResultsArray] objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:selectedObject];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Actions" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *statusPredicate = [NSPredicate predicateWithFormat:@"(status = %@ and (descriptionType != %@ || descriptionType = nil))", @"Open", @"Note from RM"];
    
    // Set filter
    if (self.detailItem != nil) {
        NSString *relationshipName;
        NSString *entityName = [[self.detailItem entity] name];
        
        if ([entityName isEqualToString:@"Offices"]) {	
            relationshipName = @"officeId == %@";
        }
        if ([entityName isEqualToString:@"Providers"]) {
            relationshipName = @"contactId == %@";
        }
        
        NSPredicate *myPredicate = [NSPredicate predicateWithFormat:relationshipName, [[self detailItem] valueForKey:@"rowId"]];
        
        NSPredicate * newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:statusPredicate, myPredicate, nil]];
        
        [fetchRequest setPredicate:newPredicate];
    }
    else {
        [fetchRequest setPredicate:statusPredicate];
    }
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    self.fetchResultsArray = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.fetchedResultsController.fetchRequest error:NULL];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
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
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(cbrTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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


- (void)configureCell:(cbrTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchResultsArray objectAtIndex:indexPath.row];
    NSString *labelText = [[managedObject valueForKey:@"type"] description];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *fourDigitYearFormat = [[df dateFormat]
                                     stringByReplacingOccurrencesOfString:@"yy"
                                     withString:@"yyyy"];
    [df setDateFormat:fourDigitYearFormat];
    cell.nameLabel.text = @"";
    NSArray *providerArray;
    //NSString *detailText = [[NSString alloc] initWithFormat:@"%@", [[managedObject valueForKey:@"note"] description]];
    if ([managedObject valueForKey:@"contactId"] != nil)
    {
        NSManagedObjectContext *moc = [managedObject managedObjectContext];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        NSEntityDescription *providerEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:moc];
        [fr setEntity:providerEntity];
        NSPredicate *providerPredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [managedObject valueForKey:@"contactId"]];
        [fr setPredicate:providerPredicate];
        providerArray = [moc executeFetchRequest:fr error:nil];
        
        for (NSManagedObject *provider in providerArray) {
            cell.nameLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",[provider valueForKey:@"firstName"],[provider valueForKey:@"lastName"]];
        }
    }
    if (([managedObject valueForKey:@"officeId"] != nil) && [providerArray count] ==0)
    {
        NSManagedObjectContext *moc = [managedObject managedObjectContext];
        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        NSEntityDescription *officeEntity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:moc];
        [fr setEntity:officeEntity];
        NSPredicate *officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [managedObject valueForKey:@"officeId"]];
        [fr setPredicate:officePredicate];
        NSArray *officeArray = [moc executeFetchRequest:fr error:nil];
        
        for (NSManagedObject *office in officeArray) {
            cell.nameLabel.text = [[NSString alloc] initWithFormat:@"%@",[office valueForKey:@"name"]];
        }
    }
    
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@",labelText];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[managedObject valueForKey:@"dueDate"]]];
    if ([[[managedObject valueForKey:@"note"] description] length] > 0)
        cell.addressLabel.text = [NSString stringWithFormat:@"%@",[managedObject valueForKey:@"note"]];
    else
        cell.addressLabel.text = @"";
}

#pragma mark - Custom

- (void)sortMyResults
{
    NSArray *recordSet = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.fetchedResultsController.fetchRequest error:NULL];
    
    NSString *choice;    
    if (self.segmentedControl.selectedSegmentIndex != -1)
        choice = [self.segmentedControl titleForSegmentAtIndex: self.segmentedControl.selectedSegmentIndex];
    
    if ([choice isEqualToString:@"Type"]) {
        self.fetchResultsArray = 
        [recordSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) 
         {        
             NSString *actionType = [[a valueForKey:@"type"] description];
             NSString *otherActionType = [[b valueForKey:@"type"] description];
             return [actionType compare:otherActionType options:NSCaseInsensitiveSearch];
         }];
    }
    else if ([choice isEqualToString:@"Due Date"]) {
        self.fetchResultsArray = 
        [recordSet sortedArrayUsingComparator:^(id a, id b) 
         {        
             NSDate *actionDate = [a valueForKey:@"dueDate"];
             NSDate *otherActionDate = [b valueForKey:@"dueDate"];
             return [actionDate compare:otherActionDate];               
         }];
    }
    else if ([choice isEqualToString:@"Contact"]) {
        self.fetchResultsArray = 
        [recordSet sortedArrayUsingComparator:^(id a, id b) 
         {   
             NSString *docA = @"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
             NSString *docB = @"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
             
             // ensure kit stocking contact is added to facility prior
             NSManagedObjectContext *moc = self.managedObjectContext;
             
             NSFetchRequest *fr = [[NSFetchRequest alloc] init];
             [fr setEntity:[NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:moc]];
             NSArray *contactArray;
             
             if ([a valueForKey:@"contactId"] != NULL)
             {
                 [fr setPredicate:[NSPredicate predicateWithFormat: @"(rowId = %@)", [a valueForKey:@"contactId"]]];
                 contactArray = [moc executeFetchRequest:fr error:nil];
                 
                 if ([contactArray count] >= 1) {
                     docA = [[contactArray objectAtIndex:0] valueForKey:@"firstName"];
                 }
             }
             if ([b valueForKey:@"contactId"] != NULL)
             {
                 [fr setPredicate:[NSPredicate predicateWithFormat: @"(rowId = %@)", [b valueForKey:@"contactId"]]];
                 contactArray = [moc executeFetchRequest:fr error:nil];
                 
                 if ([contactArray count] >= 1) {
                     docB = [[contactArray objectAtIndex:0] valueForKey:@"firstName"];
                 }
             }
             return [docA compare:docB options:NSCaseInsensitiveSearch];               
         }];        
    }
    else {
        self.fetchResultsArray = recordSet;
    }
}
- (IBAction)clickSegmentControl:(id)sender
{
    [self tintSelectedSegment:sender];
    [self sortMyResults];
    [self.tableView reloadData];
}
-(void)tintSelectedSegment:(UISegmentedControl *)sender
{    
    /*sender.segmentedControlStyle = UISegmentedControlStyleBar;
    
    UIColor *newTintColor = [UIColor colorWithRed: 134/255.0 green:125/255.0 blue:193/255.0 alpha:1.0];
    sender.tintColor = newTintColor;
    */
    UIColor *newTintColor = [UIColor colorWithRed: 64/255.0 green:18/255.0 blue:128/255.0 alpha:1.0];
    for (int i=[sender.subviews count]-1; i>=0; i--)
    {
        
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
            //break;
        }
        else
        {
            [[sender.subviews objectAtIndex:i] setTintColor:newTintColor];
            //break;
        }
    }
}


@end
