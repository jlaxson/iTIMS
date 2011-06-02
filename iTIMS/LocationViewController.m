//
//  LocationViewController.m
//  iTIMS
//
//  Created by John Laxson on 5/25/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "LocationViewController.h"

#import "ItemAreaViewController.h"
#import "ItemLocationViewController.h"
#import "ItemActivityViewController.h"

@implementation LocationViewController

@synthesize location, area, position, onComplete;

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
    
    closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(closeButton:)];
    self.navigationItem.rightBarButtonItem = closeButton;

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
    [closeButton release];
    closeButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = self.location;
            break;
            
        case 1:
            cell.textLabel.text = @"Position";
            cell.detailTextLabel.text = self.position;
            break;
            
        case 2:
            cell.textLabel.text = @"Area";
            cell.detailTextLabel.text = self.area;
            break;
            
        default:
            cell.textLabel.text = @"Error";
            break;
            
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Location";
            
        case 1:
            return @"Position";
            
        case 2:
            return @"Area";
            
        default:
            return @"Error";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc;
    switch (indexPath.section) {
        case 0:
            vc = [[ItemLocationViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        case 1:
        {
            
            ItemActivityViewController *pvc = [[ItemActivityViewController alloc] initWithStyle:UITableViewStyleGrouped];
            pvc.completedAction = ^(ItemActivityViewController *pvc, NSString *pos) {
                self.position = pos;
                //[self reloadData];
            };
            vc = pvc;
        }
            break;
        case 2:
            vc = [[ItemAreaViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)closeButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    if (self.onComplete) {
        self.onComplete(self);
    }
}

@end
