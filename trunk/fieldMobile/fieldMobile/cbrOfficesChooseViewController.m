//
//  cbrOfficesChooseViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "cbrAppDelegate.h"
#import "cbrOfficesChooseViewController.h"
#import "cbrOfficesAddViewController.h"
#import "Offices.h"

@interface cbrOfficesChooseViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)buildArray;
@end

@implementation cbrOfficesChooseViewController
@synthesize delegate;
@synthesize nOfficeItem = _nOfficeItem;
@synthesize searchBar = _searchBar;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bSearchIsOn = _bSearchIsOn;
@synthesize allTableData = _allTableData;
@synthesize filteredTableData = _filteredTableData;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.managedObjectContext == nil) 
	{
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    self.bSearchIsOn = NO;
    self.searchBar.delegate = self;
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    [self buildArray];
    [self.tableView reloadData];
}
- (void)buildArray
{
    if(self.searchBar.text.length == 0)
    {
        self.bSearchIsOn = NO;
    }
    else
    {
        self.bSearchIsOn = YES;
        self.filteredTableData = [[NSMutableArray alloc] init];
        
        for (Offices* office in self.allTableData)
        {
            NSRange nameRange = [office.name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            NSRange addressRange = [office.addr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || addressRange.location != NSNotFound)
            {
                [self.filteredTableData addObject:office];
            }
        }
    }
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;    
    [self buildArray];

    if(self.bSearchIsOn) {
        rowCount = self.filteredTableData.count;
    }
    else {
        self.allTableData = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.fetchedResultsController.fetchRequest error:NULL];
        rowCount = self.allTableData.count;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
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
    // Return NO if you do not want the item to be re-orderable.
    return NO;
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *normalPredicate = [NSPredicate predicateWithFormat:@"(officeType = %@)", @"Office"];
    [fetchRequest setPredicate:normalPredicate];
    
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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

/* design the look/feel of the record in the table */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject;
    //managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(self.bSearchIsOn)
        managedObject = [self.filteredTableData objectAtIndex:indexPath.row];
    else
        managedObject = [self.allTableData objectAtIndex:indexPath.row];
    
    NSString *labelText = [[managedObject valueForKey:@"name"] description];
    
    NSString *detailText = [[NSString alloc] initWithFormat:@"%@ %@, %@, %@ %@", [[managedObject valueForKey:@"addr"] description], [[managedObject valueForKey:@"addr2"] description], [[managedObject valueForKey:@"city"] description], [[managedObject valueForKey:@"state"] description], [[managedObject valueForKey:@"zipcode"] description]]; 
     
    cell.textLabel.text = labelText;
    cell.detailTextLabel.text=detailText;
}

/* this is the goods for navigation */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject;
    
    if(self.bSearchIsOn)
        managedObject = [self.filteredTableData objectAtIndex:indexPath.row];
    else
        managedObject = [self.allTableData objectAtIndex:indexPath.row];
    
    self.nOfficeItem = managedObject;
    [self.delegate recordSelected:self];
}

/* segue to add a new office */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addOffice"]) { 
        UINavigationController *navigationController = segue.destinationViewController;
        cbrOfficesAddViewController *addController = (cbrOfficesAddViewController *)navigationController.parentViewController;
        addController.managedObjectContext = self.managedObjectContext;
    }
}

@end
