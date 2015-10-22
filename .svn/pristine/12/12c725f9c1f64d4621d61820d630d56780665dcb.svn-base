//
//  cbrProviderMapViewController.m
//  fieldDevice
//
//  Created by Hai Tran on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrProviderMapViewController.h"
#import "cbrAppDelegate.h"
#import "cbrMapViewAnnotation.h"

@implementation cbrProviderMapViewController
@synthesize fetchResultsArray = _fetchResultsArray;

- (void)setDetailItem:(id)newDetailItem{
    if (_fetchResultsArray != newDetailItem)
    {
        _fetchResultsArray = newDetailItem;
    }
}

-(void)configureView {
    
    //    [spinner stopAnimating];    
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    NSInteger i = 0;
    for (NSManagedObject *hospital in self.fetchResultsArray)
    {
        NSString *address = [NSString stringWithFormat:@"%@, %@, %@ %@", [hospital valueForKey:@"addr"],[hospital valueForKey:@"city"],[hospital valueForKey:@"state"],[hospital valueForKey:@"zipcode"]];
        
        NSString *urlString = [[NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=json", address]stringByReplacingOccurrencesOfString:@" " withString:@"%20"] ;
        //urlString = @"http://maps.google.com/maps/geo?q=338%20spear%20street,%20san%20francisco,%20ca%2094105&output=json";
        NSData *adata = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:adata options:kNilOptions error:&error];
        NSArray* Placemark =  [json objectForKey:@"Placemark"];
        NSDictionary* loan = [Placemark objectAtIndex:0];
        if (loan != nil)
        {
            NSDictionary *point = [loan objectForKey:@"Point"];
            NSDictionary *coord = [point objectForKey:@"coordinates"];
            NSArray *strings = [[coord description] componentsSeparatedByString:@","];
            
            NSString * lat = [[[[[[strings objectAtIndex:1] stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * lang = [[[[[[strings objectAtIndex:0] stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            double lati = [lat doubleValue]; 
            
            double longi = [lang doubleValue];                        
            
            CLLocationCoordinate2D location;
            location.latitude = lati;
            location.longitude = longi;
            
            // Add the annotation to our map view
            cbrMapViewAnnotation *newAnnotation = [[cbrMapViewAnnotation alloc] initWithTitle:[hospital valueForKey:@"name"] andCoordinate:location];
            [mapView addAnnotation:newAnnotation];
            
            i = i+1;             
        }
        if (i>500)
        {
            break;
        }
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    //annView.animatesDrop=TRUE;
    annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annView.canShowCallout = YES;
    annView.enabled = YES;
    return annView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    /*
     AllDetailDashboard *summary = [[AllDetailDashboard alloc] initWithNibName:@"View Controller" bundle:nil];
     //Want to write some code here to recognize which project is clicked, in AllDetailDashBoard class we have a variable called project id which is used to recognize the project but i am not able to fetch the project id for specific project which is clicked here
     [self.navigationController pushViewController:summary animated:YES];
     [summary release];
     */
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


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
    span.latitudeDelta = .02;
    span.longitudeDelta =  .02;
    MKCoordinateRegion region;
    region.span = span;
    region.center = coord;
    [mapView setRegion:region animated:YES];
    
    //[self configureView];
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

- (IBAction)changeSeq:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
