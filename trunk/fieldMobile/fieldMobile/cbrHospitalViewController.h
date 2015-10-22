//
//  cbrHospitalViewController.h
//  fieldDevice
//
//  Created by Hai Tran on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "cbrHospitalFilterViewController.h"
#import "MBProgressHUD.h"
#import "DeselectableUISegmentedControl.h"

@interface cbrHospitalViewController : UITableViewController <NSFetchedResultsControllerDelegate, cbrHospitalFilterViewControllerControllerDelegate, MKMapViewDelegate,MBProgressHUDDelegate>
{
     IBOutlet MKMapView *mapView;
     IBOutlet UITableView *tableView;
    
    //MBProgressHUD *HUD;
	//long long expectedLength;
	//long long currentLength;
}

@property (retain) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) CLLocationManager *myLocation;

@property (strong, nonatomic) NSArray *fetchResultsArray;
@property (strong, nonatomic) NSNumber *sortSegmentIndex;
@property (strong, nonatomic) NSNumber *distanceSegmentIndex;
@property (strong, nonatomic) NSNumber *momentumSegmentIndex;
@property (strong, nonatomic) NSNumber *kitStockingSegmentIndex;
@property (strong, nonatomic) NSNumber *kolSegmentIndex;
@property (strong, nonatomic) NSNumber *mouSegmentIndex;
@property (strong, nonatomic) NSString *searchNameString;
@property (strong, nonatomic) NSManagedObject *myObject;
@property (strong, nonatomic) NSNumber *firstTime;
- (IBAction)segmentSelection:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleButton;
- (IBAction)toggleView:(id)sender;
-(IBAction)tapFavoriteButton:(id)sender;
@end
