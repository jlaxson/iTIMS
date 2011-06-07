//
//  ItemPositionViewController.m
//  iTIMS
//
//  Created by John Laxson on 5/25/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "ItemActivityViewController.h"

#import "LocationViewController.h"

@implementation ItemActivityViewController

@synthesize activity, completedAction;

- (id)initWithCompletionHandler:(ActivityCompletionHandler)handler
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    
    self.completedAction = handler;
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        DROInfo *info = [(iTIMSAppDelegate *)[[UIApplication sharedApplication] delegate] droInfo];
        positions = [info.groups retain];
        
        groups = [[positions allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
            return [(NSNumber *)[[positions objectForKey:obj1] index] compare:(NSNumber *)[[positions objectForKey:obj2] index]];
            
        }];
        [groups retain];
        
        self.title = @"Activity";
        
    }
    return self;
}

- (void)dealloc
{
    [positions release];
    [groups release];
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
    return [groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[positions objectForKey:[groups objectAtIndex:section]] activities] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSArray *g = [[positions objectForKey:[groups objectAtIndex:indexPath.section]] activities];
    Activity *act = [g objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = act.name;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = act.code;
    
    if ([act.code isEqualToString:self.activity.code]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *group = [groups objectAtIndex:section];
    return [[positions objectForKey:group] name];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *group = [groups objectAtIndex:indexPath.section];
    self.activity = [[[positions objectForKey:group] activities] objectAtIndex:indexPath.row];
    
    if (self.completedAction) {
        self.completedAction(self, self.activity);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
