//
//  cbrHospitalMapViewController.m
//  fieldDevice
//
//  Created by Hai Tran on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrHospitalMapViewController.h"
#import "cbrAppDelegate.h"
#import "cbrMapViewAnnotation.h"
#import "cbrHospitalDetailViewController.h"

@implementation cbrHospitalMapViewController

@synthesize fetchResultsArray = _fetchResultsArray;

- (void)setDetailItem:(id)newDetailItem{
    if (_fetchResultsArray != newDetailItem)
    {
        _fetchResultsArray = newDetailItem;
    }
}

-(void)configureView {
    
//    [spinner stopAnimating];    
    //mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    //NSInteger i = 0;
    for (NSManagedObject *hospital in self.fetchResultsArray)
    {
        double latitude = [[hospital valueForKey:@"latitude"] doubleValue];
        double longitude = [[hospital valueForKey:@"longitude"] doubleValue];
        NSLog(@"%@ %f %f", [hospital valueForKey:@"name"], latitude, longitude);
        
        //if (loan != nil)
        if (longitude != 0 && latitude != 0)    
        {
            CLLocationCoordinate2D location;
            //location.latitude = lati;
            //location.longitude = longi;
            location.latitude = latitude;
            location.longitude = longitude;
            
            // Add the annotation to our map view
            cbrMapViewAnnotation *newAnnotation = [[cbrMapViewAnnotation alloc] initWithTitle:[hospital valueForKey:@"name"] andCoordinate:location];
            [mapView addAnnotation:newAnnotation];

        //    i = i+1;             
        }
        //if (i>500)
        //{
        //    break;
        //}
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    //annView.animatesDrop=TRUE;
    if (annotation == mapView.userLocation ){
        return nil; //default to blue dot
    }
    annView.pinColor = MKPinAnnotationColorPurple;
    annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annView.canShowCallout = YES;
    annView.enabled = YES;
    return annView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
   /* 
    cbrHospitalDetailViewController *summary = [[cbrHospitalDetailViewController alloc] initWithNibName:@"View Controller" bundle:nil];
     //Want to write some code here to recognize which project is clicked, in AllDetailDashBoard class we have a variable called project id which is used to recognize the project but i am not able to fetch the project id for specific project which is clicked here
    [self.navigationController pushViewController:summary animated:YES];
    */
    /*
    cbrHospitalDetailViewController *abc = [[cbrHospitalDetailViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] init];
    
    [nav setToolbarHidden:YES animated:NO]; 
    [nav pushViewController:abc animated:YES];
    */
    
    [self performSegueWithIdentifier:@"mapAnnotationDetail" sender:self];
    NSLog(@"show detail view");

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [toolBar sizeToFit];
    [self.view addSubview:toolBar];
    
    mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    mapView.showsUserLocation = YES;
    
    CLLocationManager *myLocation = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] locationManager];
    CLLocationCoordinate2D coord = myLocation.location.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta = .5;
    span.longitudeDelta =  .5;
    MKCoordinateRegion region;
    region.span = span;
    region.center = coord;
    [mapView setRegion:region animated:YES];
    
    [self configureView];
    
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


-(IBAction)changeSeg:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)centerMap:(id)sender {
    CLLocationManager *myLocation = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] locationManager];
    CLLocationCoordinate2D coord = myLocation.location.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta = .02;
    span.longitudeDelta =  .02;
    MKCoordinateRegion region;
    region.span = span;
    region.center = coord;
    [mapView setRegion:region animated:YES];
}
@end
