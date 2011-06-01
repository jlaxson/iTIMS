//
//  RootViewController.m
//  iTIMS
//
//  Created by John Laxson on 5/24/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "RootViewController.h"
#import "ScannerViewController.h"
#import "ItemViewController.h"
#import "iTIMSAppDelegate.h"

#import <CoreData/CoreData.h>

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"iTIMS";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 3;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Actions";
        case 1:
            return @"Stock";
    }
    return @"Error";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Look Up Item";
                break;
            case 1:
                cell.textLabel.text = @"Issue Inventory";
                break;
            case 2:
                cell.textLabel.text = @"Look Up Comm Box";
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Count Stock";
                break;
            case 1:
                cell.textLabel.text = @"Inventory Report";
                break;
            case 2:
                cell.textLabel.text = @"Clear Report";
                break;
        }
    }
    
    
    
    return cell;
}

- (void)processItem:(Item *)item activity:(NSString *)activity location:(NSString *)loc
{
    iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
    item.showOnReport = [NSNumber numberWithBool:YES];
    
    if (item.currentAssignment) {
        Assignment *ass = item.currentAssignment;
        
        if ([ass.location isEqualToString:loc] && [ass.activity isEqualToString:activity])
            return;
        
        ass.returnTime = [NSDate date];
        ass.returnBy = @"DST";
    }
    
    Assignment *new = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:app.managedObjectContext];

    new.item = item;
    new.checkoutTime = [NSDate date];
    new.checkoutBy = @"DST";
    new.location = loc;
    new.name = activity;
    new.activity = activity;
    new.position = @"";
    
    
    
    NSLog(@"%@", new);
    
    [app saveContext];
    [app.managedObjectContext refreshObject:item mergeChanges:NO];
}

- (void)runReport
{
    iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [NSEntityDescription entityForName:@"Assignment" inManagedObjectContext:app.managedObjectContext];
    req.includesSubentities = YES;
    req.predicate = [NSPredicate predicateWithFormat:@"returnTime == nil && item.showOnReport == YES"];
    req.sortDescriptors = [NSArray arrayWithObjects:
                           [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES],
                           [NSSortDescriptor sortDescriptorWithKey:@"activity" ascending:YES],
                           [NSSortDescriptor sortDescriptorWithKey:@"item.commBox.referenceNumber" ascending:YES],
                           [NSSortDescriptor sortDescriptorWithKey:@"checkoutTime" ascending:YES],
                           nil];
    
    NSError *e;
    NSArray *results = [app.managedObjectContext executeFetchRequest:req error:&e];
    
    NSString *currentLocation = nil, *currentActivity = nil;
    NSMutableString *report = [NSMutableString string];
    
    for (Assignment *item in results) {
        
        if (![currentLocation isEqualToString:item.location]) {
            [report appendFormat:@"\n\n%@\n", item.location];
            currentLocation = item.location;
        }
        if (![currentActivity isEqualToString:item.activity]) {
            [report appendFormat:@"%@\n", item.activity];
            currentActivity = item.activity;
        }
        
        [report appendFormat:@"\t%@\t%@\t%@\n", item.item.referenceNumber, item.item.desc, item.item.entity.name];
    }
    
    NSLog(@"%@", report);
    
    MFMailComposeViewController *mvc = [[MFMailComposeViewController alloc] init];
    [mvc setSubject:@"iTIMS Report"];
    [mvc setMessageBody:report isHTML:NO];
    mvc.mailComposeDelegate = self;
    
    [self presentModalViewController:mvc animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ScannerViewController *vc = [[ScannerViewController alloc] initWithNibName:@"ScannerViewController" bundle:nil];
        switch (indexPath.row) {
                
            case 0:
                vc.navigationItem.title = @"Scan";
                vc.scanAction = ^(ScannerViewController *svc, NSString *barcode) {
                    iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
                    Item *item = [app itemByReference:barcode];
                    
                    if (item) {
                        ItemViewController *vc = [[ItemViewController alloc] initWithStyle:UITableViewStyleGrouped];
                        vc.item = item;
                        
                        [svc.navigationController pushViewController:vc animated:YES];
                    } else {
                        [svc showBanner:@"Not Found" subtitle:barcode duration:2.0];
                    }
                };
                break;
                
            case 2:
                vc.navigationItem.title = @"Comm Box";
                vc.scanAction = ^(ScannerViewController *svc, NSString *barcode) {
                    iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
                    Item *item = [app itemByReference:barcode];
                    
                    if (item) {
                        [svc showBanner:item.commBox.referenceNumber subtitle:item.referenceNumber duration:2.0];
                    } else {
                        [svc showBanner:@"Not Found" subtitle:barcode duration:2.0];
                    }
                };
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    } else if (indexPath.section == 1) {
        ScannerViewController *vc = [[ScannerViewController alloc] initWithNibName:@"ScannerViewController" bundle:nil];
        switch (indexPath.row) {
            case 0:
                vc.navigationItem.title = @"Count";
                vc.scanAction = ^(ScannerViewController *svc, NSString *barcode) {
                    iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
                    Item *item = [app itemByReference:barcode];
                    
                    if (item) {
                        [self processItem:item activity:vc.activity location:vc.location];
                        [svc showBanner:item.referenceNumber subtitle:item.desc duration:2.0];
                    } else {
                        [svc showBanner:@"Not Found" subtitle:barcode duration:2.0];
                    }
                };
                vc.location = @"DROHQ";
                vc.activity = @"Other-INV";
                [self.navigationController pushViewController:vc animated:YES];
                break;
            case 1:
                [self runReport];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                break;
                
            case 2:
            {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Reset Report" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset" otherButtonTitles:nil];
                [sheet showInView:self.view];
                [sheet release];
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        NSError *e;
        
        req.entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:app.managedObjectContext];
        
        NSArray *items = [app.managedObjectContext executeFetchRequest:req error:&e];
        for (Item *item in items) {
            item.showOnReport = [NSNumber numberWithBool:NO];
        }
        
        [app saveContext];
    }
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
