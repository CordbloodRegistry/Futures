//
//  DeselectableUISegmentedControl.m
//  fieldMobile
//
//  Created by Hai Tran on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeselectableUISegmentedControl.h"

@implementation DeselectableUISegmentedControl
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    int oldValue = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
    if (oldValue == self.selectedSegmentIndex)
    {
        [super setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}
*/
+ (BOOL)isIOS7 {
    static BOOL isIOS7 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUInteger deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
        if (deviceSystemMajorVersion >= 7) {
            isIOS7 = YES;
        }
        else {
            isIOS7 = NO;
        }
    });
    return isIOS7;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
    if (![[self class] isIOS7]) {
        // before iOS7 the segment is selected in touchesBegan
        if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            // if the selectedSegmentIndex before the selection process is equal to the selectedSegmentIndex
            // after the selection process the superclass won't send a UIControlEventValueChanged event.
            // So we have to do this ourselves.
            [super setSelectedSegmentIndex:UISegmentedControlNoSegment];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesEnded:touches withEvent:event];
    if ([[self class] isIOS7]) {
        // on iOS7 the segment is selected in touchesEnded
        if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            [super setSelectedSegmentIndex:UISegmentedControlNoSegment];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            
        }
    }
}


@end
