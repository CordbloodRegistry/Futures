//
//  cbrLoadProviderStatOperation.m
//  fieldMobile
//
//  Created by Remina Sangil on 6/10/13.
//
//

#import "cbrLoadProviderStatOperation.h"
#import "cbrAppDelegate.h"

@implementation cbrLoadProviderStatOperation
@synthesize done;
@synthesize status;
@synthesize errorMsg;


- (void)mergeChanges:(NSNotification *)notification
{
	NSManagedObjectContext *mainContext = [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
	// Merge changes into the main context on the main thread
	[mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                  withObject:notification
                               waitUntilDone:YES];
}

-(void) main
{
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filenamePath = [NSString stringWithString:[filePaths objectAtIndex:0]];
    NSString *filename = [filenamePath stringByAppendingString:@"/providerStats.json"];
    
    NSLog(@"ENTER Load Kits");
    // Create context on background thread
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	[moc setUndoManager:nil];
	[moc setPersistentStoreCoordinator: [(cbrAppDelegate *)[[UIApplication sharedApplication] delegate] persistentStoreCoordinator]];
	
	// Register context with the notification center
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
           selector:@selector(mergeChanges:)
               name:NSManagedObjectContextDidSaveNotification
             object:moc];
    
    
    NSData *responseData = [[NSData alloc] initWithContentsOfFile:filename];
}
@end
