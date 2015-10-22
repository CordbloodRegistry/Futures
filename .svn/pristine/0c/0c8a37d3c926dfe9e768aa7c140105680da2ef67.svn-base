//
//  cbrProviderFilterViewController.m
//  fieldMobile
//
//  Created by Remina Sangil on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cbrProviderFilterViewController.h"


@implementation cbrProviderFilterViewController
@synthesize searchFirstNameString;
@synthesize searchLastNameString;
@synthesize searchFacilityString;


@synthesize sortSegment;
@synthesize distanceSegment;
@synthesize momentumSegment;
@synthesize kitStockingSegment;
@synthesize mouSegment;
@synthesize delegate;
@synthesize kolSegment;

@synthesize sortSegmentIndex, distanceSegmentIndex, momentumSegmentIndex, kitStockingSegmentIndex, mouSegmentIndex,searchFirstNameField, searchLastNameField, searchFacilityField, kolSegmentIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.sortSegment.selectedSegmentIndex = [sortSegmentIndex integerValue];
    self.distanceSegment.selectedSegmentIndex = [distanceSegmentIndex integerValue];
    self.momentumSegment.selectedSegmentIndex = [momentumSegmentIndex integerValue];
    self.kitStockingSegment.selectedSegmentIndex = [kitStockingSegmentIndex integerValue];
    self.mouSegment.selectedSegmentIndex = [mouSegmentIndex integerValue];
    self.kolSegment.selectedSegmentIndex = [kolSegmentIndex integerValue];
    self.searchFirstNameField.text = searchFirstNameString;
    self.searchLastNameField.text = searchLastNameString;
    self.searchFacilityField.text = searchFacilityString;
    self.searchFirstNameField.delegate = self;
    self.searchLastNameField.delegate = self;
    self.searchFacilityField.delegate = self;
    
//    [self tintSelectedSegment:nil];
    
    //self.sortSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    
    UIColor *newTintColor = [UIColor colorWithRed: 64/255.0 green:18/255.0 blue:128/255.0 alpha:1.0];
    //self.sortSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.sortSegment.subviews count]; i++)
    {
        if ([[self.sortSegment.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.sortSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            //break;
        }
        else{
            [[self.sortSegment.subviews objectAtIndex:i] setTintColor:newTintColor];
            //break;
        }
    }
    
    //self.mouSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    //self.mouSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.mouSegment.subviews count]; i++)
    {
        if ([[self.mouSegment.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.mouSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            //break;
        }
        else{
            [[self.mouSegment.subviews objectAtIndex:i] setTintColor:newTintColor];
            //break;
        }
    }
    
    
    //self.kolSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    //self.kolSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.kolSegment.subviews count]; i++)
    {
        if ([[self.kolSegment.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.kolSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            //break;
        }
        else{
            [[self.kolSegment.subviews objectAtIndex:i] setTintColor:newTintColor];
            //break;
        }
    }
    
    
    //self.momentumSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    //self.momentumSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.momentumSegment.subviews count]; i++)
    {
        if ([[self.momentumSegment.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.momentumSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            //break;
        }
        else{
            [[self.momentumSegment.subviews objectAtIndex:i] setTintColor:newTintColor];
            //break;
        }
    }
    
    //self.kitStockingSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    //self.kitStockingSegment.tintColor = newTintColor;
    
    for (int i=0; i<[self.kitStockingSegment.subviews count]; i++)
    {
        if ([[self.kitStockingSegment.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[self.kitStockingSegment.subviews objectAtIndex:i] setTintColor:tintcolor];
            //break;
        }
        else{
            [[self.kitStockingSegment.subviews objectAtIndex:i] setTintColor:newTintColor];
            //break;
        }
    }
    
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    [self setSortSegment:nil];
    [self setDistanceSegment:nil];
    [self setMomentumSegment:nil];
    [self setKitStockingSegment:nil];
    [self setMouSegment:nil];
    [self setKolSegment:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( [textField isEqual: searchFirstNameField] ||  [textField isEqual: searchLastNameField] ||  [textField isEqual: searchFacilityField] )
    {
        [searchFirstNameField resignFirstResponder];
        [searchLastNameField resignFirstResponder];
        [searchFacilityField resignFirstResponder];
        return NO;
    }
    
    return YES;
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

#pragma mark - Custom
- (IBAction)submitted:(id)sender
{
    [self.delegate searchSelected:self];
}

- (IBAction)backButton:(id)sender
{
    [self.delegate backButton:self];
}

-(IBAction)tintSelectedSegment:(UISegmentedControl *)sender
{    
//sender.segmentedControlStyle = UISegmentedControlStyleBar;
    
    UIColor *newTintColor = [UIColor colorWithRed: 64/255.0 green:18/255.0 blue:128/255.0 alpha:1.0];
    //sender.tintColor = newTintColor;

    for (int i=0; i<[sender.subviews count]; i++)
    //for (int i=[sender.subviews count]-1; i>=0; i--)
    {
        
        if ([[sender.subviews objectAtIndex:i]isSelected] ) 
        {               
            UIColor *tintcolor=[UIColor colorWithRed:205/255.0 green:0/255.0 blue:146/255.0 alpha:1.0];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
            //break;
        }
        else{
            [[sender.subviews objectAtIndex:i] setTintColor:newTintColor];
            //break;
        }
    }
}


@end


