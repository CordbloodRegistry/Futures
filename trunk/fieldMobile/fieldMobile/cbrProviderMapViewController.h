//
//  cbrProviderMapViewController.h
//  fieldDevice
//
//  Created by Hai Tran on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface cbrProviderMapViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *mapView;
    IBOutlet UIToolbar *toolBar;
}
@property (strong, nonatomic) NSArray *fetchResultsArray;
- (IBAction)centerMap:(id)sender;
- (IBAction)changeSeq:(id)sender;

@end
