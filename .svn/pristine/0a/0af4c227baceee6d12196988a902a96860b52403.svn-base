//
//  cbrActionDetailViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrActionDetailViewController.h"

@interface cbrActionDetailViewController()
- (void)configureView;
@end


@implementation cbrActionDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailType = _detailType;
@synthesize detailSubtype = _detailSubtype;
@synthesize detailDescription = _detailDescription;
@synthesize detailTopic = _detailTopic;
@synthesize detailComments = _detailComments;
@synthesize detailStatus = _detailStatus;
@synthesize detailDueDate = _detailDueDate;
@synthesize detailCompletedDate = _detailCompletedDate;


- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        
        //self.title = [[self.detailItem valueForKey:@"actionDate"] description];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterShortStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];
        
        NSString *fourDigitYearFormat = [[df dateFormat]
                                         stringByReplacingOccurrencesOfString:@"yy"
                                         withString:@"yyyy"];
        [df setDateFormat:fourDigitYearFormat];
    
        self.detailType.text = [self.detailItem valueForKey:@"type"];
        self.detailDescription.text = [self.detailItem valueForKey:@"descriptionType"];
        self.detailTopic.text = [self.detailItem valueForKey:@"note"];
        self.detailComments.text = [self.detailItem valueForKey:@"comments"];
        self.detailStatus.text = [self.detailItem valueForKey:@"status"];
        self.detailDueDate.text = [df stringFromDate:[self.detailItem valueForKey:@"dueDate"]];
        self.detailCompletedDate.text = [df stringFromDate:[self.detailItem valueForKey:@"actionDate"]];
        self.detailSubtype.text = [self.detailItem valueForKey:@"subType"];
    }
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];

}

- (void)viewDidUnload
{
    [self setDetailType:nil];
    [self setDetailSubtype:nil];
    [self setDetailDescription:nil];
    [self setDetailTopic:nil];
    [self setDetailComments:nil];
    [self setDetailStatus:nil];
    [self setDetailDueDate:nil];
    [self setDetailCompletedDate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Table view delegate

@end
