//
//  cbrInventoryScanOverlayController.h
//  fieldMobile
//
//  Created by Hai Tran on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedLaserSDK.h"
#import "AudioToolbox/AudioServices.h"
#import <QuartzCore/QuartzCore.h>

@interface cbrInventoryScanOverlayController : CameraOverlayViewController
{	
	IBOutlet UILabel * textCue;
	
	IBOutlet UIImageView * redlaserLogo;
	
	BOOL isGreen;
	BOOL viewHasAppeared;
	BOOL successSoundPlayed;
	
	SystemSoundID _scanSuccessSound;
	BOOL _isSilent;
	
	IBOutlet UILabel * latestResultLabel;
    
	IBOutlet UIBarButtonItem *flashButton; // got it
	IBOutlet UIToolbar *toolBar;            // got it
	IBOutlet UIBarButtonItem *cancelButton; // got it
	
	// Rectangle
	CAShapeLayer *_rectLayer;
}

-(IBAction) cancelPressed; // got
-(IBAction) flashPressed; // got
-(IBAction) rotatePressed; // got
-(void) setLandscapeLayout;
-(void) setPortraitLayout;
-(void) beepOrVibrate;
- (CGMutablePathRef)newRectPathInRect:(CGRect)rect;
- (void) setActiveRegionRect;
@end
