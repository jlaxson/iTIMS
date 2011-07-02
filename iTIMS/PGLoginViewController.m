//
//  PGLoginViewController.m
//  iTIMS
//
//  Created by John Laxson on 6/7/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "PGLoginViewController.h"
#import "PSQLDatasource.h"

@implementation PGLoginViewController

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
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Server";
                break;
            case 1:
                cell.textLabel.text = @"Username";
                break;
            case 2:
                cell.textLabel.text = @"Password";
                break;
            case 3:
                cell.textLabel.text = @"Database Name";
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Connect";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = view;
        [view startAnimating];
        [view release];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self doConnect];
    }
}

- (void)doConnect {
    connection = [[PGSQLConnection alloc] init];
    [connection setServer:@"jlaxson.local"];
    [connection setDatabaseName:@"tims"];
    [connection setUserName:@"tims"];
    [connection setPassword:@"tims"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionCompleted:) name:PGSQLConnectionDidCompleteNotification object:connection];
    
    [connection connectAsync];
}

- (void)connectionCompleted:(NSNotification *)notification
{
    NSString *error = [[notification userInfo] objectForKey:@"Error"];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.accessoryView = nil;
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [connection release];
        connection = nil;
        return;
    }
    
    iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
    PSQLDatasource *datasource = [[PSQLDatasource alloc] initWithConnection:connection];
    app.datasource = datasource;
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
