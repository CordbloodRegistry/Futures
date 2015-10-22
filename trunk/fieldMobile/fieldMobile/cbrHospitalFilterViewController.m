//
//  cbrHospitalFilterViewController.m
//  fieldMobile
//
//  Created by Hai Tran on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrHospitalFilterViewController.h"



@implementation cbrHospitalFilterViewController
@synthesize searchNameField;
@synthesize sortSegment;
@synthesize distanceSegment;
@synthesize momentumSegment;
@synthesize kitStockingSegment;
@synthesize mouSegment;
@synthesize kolSegment;
@synthesize delegate;

@synthesize sortSegmentIndex, distanceSegmentIndex, momentumSegmentIndex, kitStockingSegmentIndex, mouSegmentIndex,searchNameString, kolSegmentIndex;

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
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    sortSegment.selectedSegmentIndex = [sortSegmentIndex integerValue];
    distanceSegment.selectedSegmentIndex = [distanceSegmentIndex integerValue];
    momentumSegment.selectedSegmentIndex = [momentumSegmentIndex integerValue];
    kitStockingSegment.selectedSegmentIndex = [kitStockingSegmentIndex integerValue];
    mouSegment.selectedSegmentIndex = [mouSegmentIndex integerValue];
    kolSegment.selectedSegmentIndex = [kolSegmentIndex integerValue];
    searchNameField.text = searchNameString;
    
    self.sortSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    
    UIColor *newTintColor = [UIColor colorWithRed: 64/255.0 green:18/255.0 blue:128/255.0 alpha:1.0];

    self.sortSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.sortSegment.subviews count]; i++) 
    {
        if ([[self.sortSegment.subviews objectAtIndex:i]isSelected] ) 
        {               
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.sortSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            break;
        }
    }    

    self.momentumSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.momentumSegment.subviews count]; i++) 
    {
        if ([[self.momentumSegment.subviews objectAtIndex:i]isSelected] ) 
        {               
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.momentumSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            break;
        }
    }    
    self.kitStockingSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.kitStockingSegment.subviews count]; i++) 
    {
        if ([[self.kitStockingSegment.subviews objectAtIndex:i]isSelected] ) 
        {               
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.kitStockingSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            break;
        }
    }    
    self.mouSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.mouSegment.subviews count]; i++) 
    {
        if ([[self.mouSegment.subviews objectAtIndex:i]isSelected] ) 
        {               
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.mouSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            break;
        }
    }    
    self.kolSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.kolSegment.subviews count]; i++)
    {
        if ([[self.kolSegment.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.kolSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            break;
        }
    }
   
    
}

- (void)viewDidUnload
{
    [self setSortSegment:nil];
    [self setDistanceSegment:nil];
    [self setMomentumSegment:nil];
    [self setKitStockingSegment:nil];
    [self setMouSegment:nil];
    [self setKolSegment:nil];
    [self setSearchNameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( [textField isEqual: searchNameField])
    {
        [searchNameField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)submitted:(id)sender
{
    [self.delegate searchSelected:self];
}
- (IBAction)backButton:(id)sender
{
    [self.delegate backButton:self];
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)tintSelectedSegment:(UISegmentedControl *)sender
{    /*
    sender.segmentedControlStyle = UISegmentedControlStyleBar;
    
    UIColor *newTintColor = [UIColor colorWithRed: 134/255.0 green:125/255.0 blue:193/255.0 alpha:1.0];
    sender.tintColor = newTintColor;
    */
    UIColor *newTintColor = [UIColor colorWithRed: 64/255.0 green:18/255.0 blue:128/255.0 alpha:1.0];
    for (int i=[sender.subviews count]-1; i>=0; i--)
    {
        
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
            //break;
        }
        else
        {
            [[sender.subviews objectAtIndex:i] setTintColor:newTintColor];
            //break;
        }
    }
}

@end
