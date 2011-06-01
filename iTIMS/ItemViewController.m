//
//  ItemViewController.m
//  iTIMS
//
//  Created by John Laxson on 5/27/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "ItemViewController.h"
#import "AssignmentViewController.h"

@implementation ItemViewController

@synthesize item;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.item.referenceNumber;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 4;
        case 1:
            return self.item.currentAssignment ? 2 : 1;
        case 2:
            return [self.item.assignments count] ? [self.item.assignments count] : 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    static NSDateFormatter *dateFormatter = nil, *dateTimeFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MM'/'d" options:0 locale:[NSLocale currentLocale]]];
        
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        [dateTimeFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MM'/'d hh:mma" options:0 locale:[NSLocale currentLocale]]];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = self.item.referenceNumber;
                break;
            case 1:
                cell.textLabel.text = self.item.assetTag;
                break;
            case 2:
                cell.textLabel.text = self.item.desc;
                break;
            case 3:
                cell.textLabel.text = self.item.commBox ? [self.item.commBox referenceNumber] : @"Unassigned";
                break;
        }
    } else if (indexPath.section == 1) {
        Assignment *ass = self.item.currentAssignment;
        if (ass) {
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"Checked out to %@", ass.name];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = [dateTimeFormatter stringFromDate:ass.checkoutTime];
            }
        } else {
            cell.textLabel.text = @"In Stock";
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.section == 2) {
        NSSet *assignments = self.item.assignments;
        if (assignments.count == 0) {
            cell.textLabel.text = @"No history";
        } else {
            Assignment *ass = [self.item.sortedAssignments objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@-%@", ass.name, [dateFormatter stringFromDate:ass.checkoutTime], ass.returnTime ? [dateFormatter stringFromDate:ass.returnTime] : @"Open"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Info";
        case 1:
            return @"Assignment";
        case 2:
            return @"History";
        default:
            return @"Error";
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (self.item.currentAssignment) {
            // return
            AssignmentViewController *vc = [[AssignmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.assignment = self.item.currentAssignment;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // assign
        }
    } else if (indexPath.section == 2) {
        AssignmentViewController *vc = [[AssignmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.assignment = [self.item.sortedAssignments objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
