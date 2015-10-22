//
//  cbrHospitalViewController.m
//  fieldDevice
//
//  Created by Hai Tran on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "cbrHospitalViewController.h"
#import "cbrAppDelegate.h"
#import "cbrMapViewAnnotation.h"
#import "cbrHospitalDetailViewController.h"
#import "cbrHospitalAddViewController.h"
#import "cbrHospitalFilterViewController.h"
#import "Offices.h"
#import "cbrTableViewCell.h"

@interface cbrHospitalViewController ()
- (void)configureCell:(cbrTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath UpdateType:(NSString *)type;
- (NSString *)buildPredicate;
- (void)sortMyResults;
- (void)configureMapView;
@end

@implementation cbrHospitalViewController

@synthesize fetchResultsArray = _fetchResultsArray;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize myLocation = _myLocation;
@synthesize sortSegmentIndex = _sortSegmentIndex;
@synthesize distanceSegmentIndex = _distanceSegmentIndex;
@synthesize momentumSegmentIndex = _momentumSegmentIndex;
@synthesize kitStockingSegmentIndex = _kitStockingSegmentIndex;
@synthesize mouSegmentIndex = _mouSegmentIndex;
@synthesize kolSegmentIndex = _kolSegmentIndex;
@synthesize segmentedControl = _segmentedControl;
@synthesize toggleButton = _toggleButton;
@synthesize searchNameString = _searchNameString;
@synthesize mapView, tableView;
@synthesize myObject = _myObject;
@synthesize firstTime = _firstTime;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.myLocation == nil)
    {
        self.myLocation = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] locationManager];
    }
    
    // set up views and override default uitableview view class behavior
    if (!tableView && [self.view isKindOfClass:[UITableView class]]) {
        tableView = (UITableView *)self.view;
    }
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    if (!mapView) 
        mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
    self.mapView.frame = self.view.bounds;
    [self.view addSubview:self.mapView];
    
    self.mapView.hidden = YES;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    // end set up
    
    if (self.managedObjectContext == nil) 
	{
        self.managedObjectContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
}
- (void)viewDidUnload {
    [self setToggleButton:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated {
    
    if (self.sortSegmentIndex == nil){
        self.sortSegmentIndex = [NSNumber numberWithInt:-1];
    }
    if (self.distanceSegmentIndex == nil){
        self.distanceSegmentIndex = [NSNumber numberWithInt:-1];
    }
    if (self.momentumSegmentIndex == nil) {
        self.momentumSegmentIndex = [NSNumber numberWithInt:-1];
    }
    if (self.kitStockingSegmentIndex == nil) {
        self.kitStockingSegmentIndex = [NSNumber numberWithInt:-1];
    }
    if (self.mouSegmentIndex == nil) {
        self.mouSegmentIndex = [NSNumber numberWithInt:-1];
    }
    if (self.kolSegmentIndex == nil) {
        self.kolSegmentIndex = [NSNumber numberWithInt:-1];
    }
    if (self.searchNameString == nil) {
        self.searchNameString = @"";
    }
    
    [super viewWillAppear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"hospitalDetail"]) {
        if (self.mapView.isHidden)  {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            self.myObject = [self.fetchResultsArray objectAtIndex:indexPath.row];
        }
        
        [[segue destinationViewController] setDetailItem:self.myObject];
    }
    else if ([[segue identifier] isEqualToString:@"addHospital"]) { 
        [[segue destinationViewController] setDetailItem:self.managedObjectContext];
    }
    else if ([[segue identifier] isEqualToString:@"seeMap"]){
        [[segue destinationViewController] setDetailItem:self.fetchResultsArray];
    }
    else if ([[segue identifier] isEqualToString:@"setFilter"]){
        cbrHospitalFilterViewController *filterController = (cbrHospitalFilterViewController *)[segue destinationViewController];
        filterController.distanceSegmentIndex = self.distanceSegmentIndex;
        filterController.momentumSegmentIndex = self.momentumSegmentIndex;
        filterController.kitStockingSegmentIndex = self.kitStockingSegmentIndex;
        filterController.mouSegmentIndex = self.mouSegmentIndex;
        filterController.kolSegmentIndex = self.kolSegmentIndex;
        filterController.sortSegmentIndex = self.sortSegmentIndex;
        filterController.searchNameString = self.searchNameString;
        filterController.delegate = self;
    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (cbrTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    static NSString *CellIdentifier = @"Cell";
    
    cbrTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath UpdateType:@"new"];
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } 
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {	
    return self.editing;
}

#pragma mark - FilterViewcontroller functions
- (void)backButton:(cbrHospitalFilterViewController *)controller {
    [self.tableView reloadData];
    
    if (!self.mapView.isHidden){
        [self configureMapView];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
    
}
- (void)searchSelected:(cbrHospitalFilterViewController *)controller {
    self.sortSegmentIndex = [NSNumber numberWithInt:controller.sortSegment.selectedSegmentIndex];
    self.distanceSegmentIndex = [NSNumber numberWithInt:controller.distanceSegment.selectedSegmentIndex];
    self.momentumSegmentIndex = [NSNumber numberWithInt:controller.momentumSegment.selectedSegmentIndex];
    self.kitStockingSegmentIndex = [NSNumber numberWithInt:controller.kitStockingSegment.selectedSegmentIndex];
    self.mouSegmentIndex = [NSNumber numberWithInt:controller.mouSegment.selectedSegmentIndex];
    self.kolSegmentIndex = [NSNumber numberWithInt:controller.kolSegment.selectedSegmentIndex];
    self.searchNameString = controller.searchNameField.text;
    
    NSError *error = nil;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Offices" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *theRequest = [[NSFetchRequest alloc] init];
    [theRequest setEntity:entityDescription];
    
    NSString *predicateString = [self buildPredicate];

    // Edit the predicate as appropriate
    NSPredicate *predicateClosed = [NSPredicate predicateWithFormat:predicateString];
    [theRequest setPredicate:predicateClosed];

    if (self.mouSegmentIndex.integerValue == 1)
    {
        NSPredicate *overDuePredicate = [NSPredicate predicateWithFormat:@"(nextFUDate <= %@)",[NSDate date]];
        
        NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicateClosed, overDuePredicate, nil]];
        [theRequest setPredicate:newPredicate];
    }
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [theRequest setSortDescriptors:sortDescriptors];
    
    // re-initialize the FRC
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:theRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
            
    if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    self.fetchedResultsController = nil;
    [self sortMyResults];
    
    [self.tableView reloadData];
    
    if (!self.mapView.isHidden){
        [self configureMapView];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
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
    
    NSString *predicateString = [self buildPredicate];
    
    // Set filter
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:myPredicate];
    
    if (self.mouSegmentIndex.integerValue == 1)
    {
        NSPredicate *overDuePredicate = [NSPredicate predicateWithFormat:@"(nextFUDate <= %@)",[NSDate date]];
        
        NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:myPredicate, overDuePredicate, nil]];
        [fetchRequest setPredicate:newPredicate];
    }
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
  
    [self sortMyResults];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
        
    return __fetchedResultsController;
}    
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self sortMyResults];
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
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
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *myTableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(cbrTableViewCell *)[myTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath UpdateType:@"update"];
            break;
            
        case NSFetchedResultsChangeMove:
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
    [self.tableView endUpdates];
    //self.fetchResultsArray = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.fetchedResultsController.fetchRequest error:NULL];
    //[self sortMyResults];
}
- (void)configureCell:(cbrTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath UpdateType:(NSString *)type {
    NSManagedObject *managedObject;
    
    //if ([type isEqualToString:@"update"])
    //    managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //else
        managedObject = [self.fetchResultsArray objectAtIndex:indexPath.row];
    
    CLLocation *aLoc = [[CLLocation alloc] initWithLatitude:[[[managedObject valueForKey:@"latitude"] description] floatValue] longitude:[[[managedObject valueForKey:@"longitude"] description] floatValue]];
    
    int distance = [self.myLocation.location distanceFromLocation:aLoc];
    NSNumber *miles = [NSNumber numberWithDouble:((double)distance) / 1609.344];
    NSString *detailText = [[NSString alloc] initWithFormat:@"%.2f mi",[miles doubleValue]];

    cell.distanceLabel.text = detailText;
    cell.nameLabel.text = [[managedObject valueForKey:@"name"] description];
    
    NSString *addr = [NSString stringWithFormat:@"%@",[managedObject valueForKey:@"addr"]];
    if ([managedObject valueForKey:@"addr2"] != nil)
        addr = [NSString stringWithFormat:@"%@, %@",addr, [managedObject valueForKey:@"addr2"]];
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:[NSEntityDescription entityForName:@"Kits" inManagedObjectContext:moc]];
    [fr setPredicate:[NSPredicate predicateWithFormat: @"(assignedOfficeId = %@) && (status != %@ || status == nil)",[managedObject valueForKey:@"rowId"],@"Inactive/Lost"]];
    
    NSArray *kits = [moc executeFetchRequest:fr error:nil];
    
    int kitCount = [kits count];
    
    cell.addressLabel.text = [[NSString alloc] initWithFormat:@"%@, %@", addr, [managedObject valueForKey:@"city"]];

    cell.numberCollections.text = [NSString stringWithFormat:@"%@ enrs | %@ vel | %@ kits",[managedObject valueForKey:@"numEnrollments"],[managedObject valueForKey:@"turn"],[NSNumber numberWithInt:kitCount]];

    int momentum = [[managedObject valueForKey:@"rating"] intValue];
    if (momentum > 0 && momentum <= 100) {
        [cell.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_1.png"]];}
    else if (momentum > 100 && momentum <= 200) {
        [cell.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_2.png"]];}
    else if (momentum > 200 && momentum <= 300) {
        [cell.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_3.png"]];}
    else if (momentum > 300 && momentum <= 400) {
        [cell.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_4.png"]];}
    else if (momentum > 400 && momentum <= 1000) {
        [cell.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_5.png"]];}
    else {
        [cell.momentumImage setImage:[UIImage imageNamed:@"MOMENTUMS_6.png"]];}

    cell.favoriteButton.tag = indexPath.row;
    //[cell.favoriteButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateSelected];
    //[cell.favoriteButton setImage:[UIImage imageNamed:@"star_silver.png"] forState:UIControlStateNormal];
    if ([[[managedObject  valueForKey:@"kol"] description] isEqualToString:@"Y"])
        cell.favoriteButton.selected = TRUE;
    else
        cell.favoriteButton.selected = FALSE;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *fourDigitYearFormat = [[df dateFormat]
                                     stringByReplacingOccurrencesOfString:@"yy"
                                     withString:@"yyyy"];
    [df setDateFormat:fourDigitYearFormat];
    
    cell.subtitleLabel.text = [df stringFromDate:[managedObject valueForKey:@"nextFUDate"]];
    if (!([managedObject valueForKey:@"nextFUDate"] == nil))
    {   
        //NSLog(@"%@",[df stringFromDate:[managedObject valueForKey:@"nextFUDate"]]);
        //cell.nameLabel.textColor = [UIColor colorWithRed:128/255.0 green:122/255.0 blue:184/255.0 alpha:1];
        [cell.nameLabel setTextColor:[UIColor colorWithRed:155/255.0 green:0/255.0 blue:46/255.0 alpha:1]];
    }
    else {
        [cell.nameLabel setTextColor:[UIColor darkTextColor]];
    }
}
- (NSString *)buildPredicate {
    NSString *outPredicate =  @"(officeType = 'Hospital')";
    /*
    switch([self.distanceSegmentIndex integerValue])
    {
        case 0:
            outPredicate = [[NSString alloc] initWithFormat:@"(distance <= 0.5) && %@",outPredicate];
            break;
        case 1:
            outPredicate = [[NSString alloc] initWithFormat:@"(distance <= 1.0) && %@",outPredicate];
            break;
        case 2:
            outPredicate = [[NSString alloc] initWithFormat:@"(distance <= 5.0) && %@",outPredicate];
            break;
        case 3:
            outPredicate = [[NSString alloc] initWithFormat:@"(distance <= 15.0) && %@",outPredicate];
            break;
        default:
            break;
    }
    */
    switch([self.momentumSegmentIndex integerValue])
    {
        case 0:
            outPredicate = [[NSString alloc] initWithFormat:@"(rating >= 1 AND rating <=400) && %@",outPredicate];
            break;
        case 1:
            outPredicate = [[NSString alloc] initWithFormat:@"(rating >= 401 AND rating <=1000) && %@",outPredicate];
            break;
        case 2:
            outPredicate = [[NSString alloc] initWithFormat:@"(rating > 1000 OR rating = NULL) and %@",outPredicate];
            break;
        default:
            break;
    }
    switch([self.kitStockingSegmentIndex integerValue])
    {
        case 0:
            outPredicate = [[NSString alloc] initWithFormat:@"(stockingOffice = 'Y') && %@",outPredicate];
            break;
        case 1:
            outPredicate = [[NSString alloc] initWithFormat:@"(stockingOffice = 'N' || stockingOffice = NULL) && %@",outPredicate];
            break;
        default:
            break;
    }
    switch([self.mouSegmentIndex integerValue])
    {
            
        case 0:
            outPredicate = [[NSString alloc] initWithFormat:@"(nextFUDate != NULL) && %@",outPredicate];
            break;
        case 1:
        {
            break;
        }
        default:
            break;
    }
    switch([self.kolSegmentIndex integerValue])
    {
            
        case 0:
            outPredicate = [[NSString alloc] initWithFormat:@"(kol = 'Y') && %@",outPredicate];
            break;
        case 1:
        {
            outPredicate = [[NSString alloc] initWithFormat:@"(kol <> 'Y') && %@",outPredicate];
            break;
        }
        default:
            break;
    }
    if ([self.searchNameString length] > 0)
    {
        NSString *searchName = self.searchNameString;
        searchName = [[searchName componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@"?"];
        outPredicate = [[NSString alloc] initWithFormat:@"(name like [c] '*%@*') && %@", searchName, outPredicate];
        //outPredicate = [[NSString alloc] initWithFormat:@"(name CONTAINS[c] '%@') && %@",self.searchNameString, outPredicate];
   
    }
    return outPredicate;
}
- (void)sortMyResults {
    NSArray *recordSet = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.fetchedResultsController.fetchRequest error:NULL];
    
    if ([self.sortSegmentIndex integerValue] == 0)
    {
        self.fetchResultsArray = 
        [recordSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {       
            CLLocation *aLoc = [[CLLocation alloc] initWithLatitude:[[[a valueForKey:@"latitude"] description] floatValue] longitude:[[[a valueForKey:@"longitude"] description] floatValue]];
            CLLocation *bLoc = [[CLLocation alloc] initWithLatitude:[[[b valueForKey:@"latitude"] description] floatValue] longitude:[[[b valueForKey:@"longitude"] description] floatValue]];
            int distance = [self.myLocation.location distanceFromLocation:aLoc];
            int otherDistance = [self.myLocation.location distanceFromLocation:bLoc];
            if(distance > otherDistance){
                return NSOrderedDescending;
            } else if(distance < otherDistance){
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
    }
    else if([self.sortSegmentIndex integerValue] == 1)
    {
        // momentum: do nothing -- already pre-sorted by Momentum
        self.fetchResultsArray = 
        [recordSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            //NSString *momentum = [[a valueForKey:@"rating"] description];
            //NSString *otherMomentum = [[b valueForKey:@"rating"] description];
            int momentum = [[a valueForKey:@"rating"] integerValue];
            int otherMomentum = [[b valueForKey:@"rating"] integerValue];
            if (momentum  == 0) {
                momentum = 5000;}
            if (otherMomentum == 0) {
                otherMomentum = 5000;}
            if(momentum < otherMomentum){
                return NSOrderedAscending;
            } else if(momentum > otherMomentum){
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }

            //return [momentum compare:otherMomentum options:NSCaseInsensitiveSearch];
        }];
    } 
    else if ([self.sortSegmentIndex integerValue] == 2)
    {
        self.fetchResultsArray = 
        [recordSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {       
            
            int turn = [[a valueForKey:@"numEnrollments"] integerValue];
            int otherTurn = [[b valueForKey:@"numEnrollments"] integerValue];
            if(turn < otherTurn){
                return NSOrderedDescending;
            } else if(turn > otherTurn){
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
    }
    else if ([self.sortSegmentIndex integerValue] == 3)  // ascending
    {
        self.fetchResultsArray = 
        [recordSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {       
            
            int turn = [[a valueForKey:@"turn"] integerValue];
            int otherTurn = [[b valueForKey:@"turn"] integerValue];
            if(turn > otherTurn){
                return NSOrderedDescending;
            } else if(turn < otherTurn){
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
    }
    else if ([self.sortSegmentIndex integerValue] == -1)
    {
        self.fetchResultsArray = 
        [recordSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            
            if (([a valueForKey:@"nextFUDate"] == NULL) && ([b valueForKey:@"nextFUDate"] == NULL))
                return NSOrderedSame;
            else if (([a valueForKey:@"nextFUDate"] == NULL) && ([b valueForKey:@"nextFUDate"] != NULL))
                return NSOrderedDescending;
            else if (([a valueForKey:@"nextFUDate"] != NULL) && ([b valueForKey:@"nextFUDate"] == NULL))
                return NSOrderedAscending;
            else {
                NSDate *aDate = [a valueForKey:@"nextFUDate"];
                NSDate *bDate = [b valueForKey:@"nextFUDate"];
                return [aDate compare:bDate];
            }
        }];
    }
    else {
        self.fetchResultsArray = recordSet;
    }
}

#pragma mark -Map Functions
-(void)configureMapView {
    // remove existing annotations
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.showsUserLocation = NO;
    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotations:self.fetchResultsArray];
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.animatesDrop=TRUE;
    if (annotation == [self.mapView userLocation] ){
        return nil; //default to blue dot
    }
    if ([(NSManagedObject *)annotation valueForKey:@"nextFUDate"] != nil)
        annView.pinColor = MKPinAnnotationColorRed;
    else 
        annView.pinColor = MKPinAnnotationColorPurple;
    annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annView.canShowCallout = YES;
    annView.enabled = YES;
    return annView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    self.myObject = view.annotation;
    [self performSegueWithIdentifier:@"hospitalDetail" sender:self];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //self.mapView.centerCoordinate = userLocation.location.coordinate;
} 

#pragma mark -customActions
- (IBAction)toggleView:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:(self.mapView == nil ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft)
                           forView:self.view cache:NO];
    
    if (self.mapView == nil)
    {
        self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.hidden = YES;
        self.mapView.delegate = self;
    }
    // map visible? show or hide it
    if (self.mapView.isHidden)
    {
        // get on with setting up the region
        CLLocationManager *myLocation = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] locationManager];
        CLLocationCoordinate2D coord = myLocation.location.coordinate;
        MKCoordinateSpan span;
        span.latitudeDelta = .25;
        span.longitudeDelta =  .25;
        MKCoordinateRegion region;
        region.span = span;
        region.center = coord;
        [self.mapView setRegion:region animated:YES];
        
        [self.segmentedControl setTitle:@"List" forSegmentAtIndex:1];
        self.tableView.hidden = YES;
        self.mapView.hidden = NO;
        [self configureMapView];

    } else {
        
        [self.segmentedControl setTitle:@"Map" forSegmentAtIndex:1];
        self.mapView.hidden = YES;
        self.tableView.hidden = NO;
    }
    [UIView commitAnimations];
}
- (IBAction)segmentSelection:(id)sender {
    /*
    switch(self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            
            [self.segmentedControl setSelectedSegmentIndex:-1];
            [self performSegueWithIdentifier:@"setFilter" sender:self];
            break;
        case 1:
            
            [self.segmentedControl setSelectedSegmentIndex:-1];
            [self toggleView:sender];
            break;
        case 2:
            
            [self.segmentedControl setSelectedSegmentIndex:-1];
            [self addHospital:sender];
            break;
        default:
            break;
            
            
    }
     */
            
            NSString *choice;    
            choice = [self.segmentedControl titleForSegmentAtIndex: self.segmentedControl.selectedSegmentIndex];
            if ([choice isEqualToString:@"Map"] || ([choice isEqualToString:@"List"]))
            {
                [self toggleView:sender];
                
            } else if ([choice isEqualToString:@"Search"])
            {
                //[self filterProvider:sender];
                [self performSegueWithIdentifier:@"setFilter" sender:self];
            }
            else if ([choice isEqualToString:@"Add"]) {
                [self addHospital:sender];
                
            }
    
}
- (void)addHospital:(id)sender {
    [self performSegueWithIdentifier:@"addHospital" sender:self];
}
- (void)recordTransaction:(NSManagedObject *) obj
{
    //NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSManagedObject *newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:self.managedObjectContext];
    
    NSDate *today = [NSDate date];
    
    //current location
    CLLocationManager *clm = [[CLLocationManager alloc] init];
    
    //self.locationManager.delegate = self;
    clm.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    // Set a movement threshold for new events.
    clm.distanceFilter = 500;
    
    [clm startUpdatingLocation];
    
    CLLocation *myLocation = [clm location];
    
    [newTransaction setValue:[[obj valueForKey:@"rowId"] description] forKey:@"entityId"];
    [newTransaction setValue:@"Facility" forKey:@"entityType"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.latitude] forKey:@"latitude"];
    [newTransaction setValue:[NSNumber numberWithFloat:myLocation.coordinate.longitude] forKey:@"longitude"];
    [newTransaction setValue:today forKey:@"transactionDate"];
    [newTransaction setValue:@"Update" forKey:@"transactionType"];
    
    [clm stopUpdatingLocation];
    
    
    NSMutableSet *transactionRelation = [obj mutableSetValueForKey:@"transactions"];
    [transactionRelation addObject:newTransaction];
    
    //[context save:nil];
}


-(IBAction)tapFavoriteButton:(UIButton*)button
{
    NSManagedObject *managedObject;
    
    managedObject = [self.fetchResultsArray objectAtIndex:button.tag];
    if (button.selected)
        [managedObject setValue:@"N" forKey:@"kol"];
    else
        [managedObject setValue:@"Y" forKey:@"kol"];

    NSManagedObjectContext *moc = self.managedObjectContext;
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:[NSEntityDescription entityForName:@"Offices" inManagedObjectContext:self.managedObjectContext]];
    
    NSPredicate *officePredicate = [NSPredicate predicateWithFormat: @"(rowId = %@)", [[managedObject  valueForKey:@"rowId"] description]];
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