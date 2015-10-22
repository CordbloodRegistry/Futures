//
//  cbrProviderViewController.h
//  fieldDevice
//
//  Created by Hai Tran on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cbrProviderFilterViewController.h"
#import "cbrTableViewCell.h"

@interface cbrProviderViewController : UITableViewController <NSFetchedResultsControllerDelegate,MKMapViewDelegate,cbrProviderFilterViewControllerControllerDelegate> 
{
    IBOutlet MKMapView *mapView;
    IBOutlet UITableView *tableView;

}

@property (retain) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *myLocation;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchResultsArray;
@property (strong, nonatomic) NSManagedObject *myObject;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSNumber *sortSegmentIndex;
@property (strong, nonatomic) NSNumber *distanceSegmentIndex;
@property (strong, nonatomic) NSNumber *momentumSegmentIndex;
@property (strong, nonatomic) NSNumber *kitStockingSegmentIndex;
@property (strong, nonatomic) NSNumber *mouSegmentIndex;
@property (strong, nonatomic) NSNumber *kolSegmentIndex;
@property (strong, nonatomic) NSString *searchFirstNameString;
@property (strong, nonatomic) NSString *searchLastNameString; 
@property (strong, nonatomic) NSString *searchFacilityString; 


- (IBAction)toggleView:(id)sender;
-(IBAction)tapFavoriteButton:(id)sender;
- (IBAction)clickSegmentControl:(id)sender;
@end


