//
//  cbrHospitalMapViewController.h
//  fieldDevice
//
//  Created by Hai Tran on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cbrHospitalMapViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *mapView;
    IBOutlet UIToolbar *toolBar;
}
@property (strong, nonatomic) NSArray *fetchResultsArray;
- (IBAction)changeSeg:(id)sender;
- (IBAction)centerMap:(id)sender;

@end
