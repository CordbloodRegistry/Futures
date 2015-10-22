//
//  cbrInventoryScanViewController.h
//  fieldDevice
//
//  Created by Hai Tran on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedLaserSDK.h"
#import "LineaSDK.h"
#import "ZBarSDK.h"
#import <QuartzCore/QuartzCore.h>

@interface cbrInventoryScanViewController : UIViewController <LineaDelegate,BarcodePickerControllerDelegate,ZBarReaderDelegate> {
    	Linea *linea;
        //NSMutableString *status;
        NSMutableString *debug;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic)Linea *linea;
@property (strong, nonatomic)NSMutableString *debug;
@property (weak, nonatomic) IBOutlet UILabel *scannedLabel;
@property (strong, nonatomic) NSMutableArray *depositIds;
@property (weak, nonatomic) NSMutableArray *scannedIds;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *scanButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rescanButton;

@property (strong, nonatomic) ZBarReaderViewController *zbarReader;

- (IBAction)reScan:(id)sender;
- (IBAction)cancelScan:(id)sender;
- (IBAction)saveScan:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *scanMode;

@property (strong, nonatomic) NSString *scanType;
@property (strong, nonatomic) NSNumber *barcodesScanned;
@property (strong, nonatomic) IBOutlet UILabel *lblDepositError;

- (IBAction)lineaPushDown:(id)sender;
- (IBAction)lineaPushUpInside:(id)sender;

@end
cbrInventoryScanViewController *cbrinventoryScanViewController;

#define SHOWERR(func) func; if(error)[cbrinventoryScanViewController debug:error.localizedDescription];
#define ERRMSG(title) {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; [alert show];}