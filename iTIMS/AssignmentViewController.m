//
//  AssignmentViewController.m
//  iTIMS
//
//  Created by John Laxson on 5/28/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "AssignmentViewController.h"

#import "LoanRecordPrinter.h"

@implementation AssignmentViewController

@synthesize assignment;

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
    self.navigationItem.title = self.assignment.name;
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
    // Return the number of rows in the section.
    if (section == 0)
        return 2;
    if (section == 1)
        return 3;
    if (section == 2)
        return self.assignment.returnTime ? 1 : 2;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Item";
        case 1:
            return @"Assignment";
        case 2:
            return @"Actions";
    }
    return @"Error";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MM'/'d hh:mma" options:0 locale:[NSLocale currentLocale]]];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = self.assignment.item.referenceNumber;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = self.assignment.item.desc;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = self.assignment.name;
        } else if (indexPath.row == 1) {
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.textLabel.text = [NSString stringWithFormat:@"Checked out %@ by %@", [dateFormatter stringFromDate:self.assignment.checkoutTime], self.assignment.checkoutBy];
        } else if (indexPath.row == 2) {
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            if (self.assignment.returnTime) {
                cell.textLabel.text = [NSString stringWithFormat:@"Returned %@ by %@", [dateFormatter stringFromDate:self.assignment.returnTime], self.assignment.returnBy];
            } else {
                cell.textLabel.text = @"Not returned";
            }
        }
    } else if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if (indexPath.row == 0 && self.assignment.returnTime == nil) {
            cell.textLabel.text = @"Return";
        } else if (indexPath.row == 1 || self.assignment.returnTime != nil) {
            cell.textLabel.text = @"Print";
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate


- (void)print {
    LoanRecordPrinter *printer = [[LoanRecordPrinter alloc] init];
    [printer printAssignment:self.assignment];
}

- (void)beginReturn {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to return this item?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Return" otherButtonTitles:nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && (indexPath.row == 1 || self.assignment.returnTime)) {
        [self print];
    } else if (indexPath.section == 2 && indexPath.row == 0 && self.assignment.returnTime == nil) {
        [self beginReturn];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && (indexPath.row == 1 || self.assignment.returnTime)) {
        [self print];
    } else if (indexPath.section == 2 && indexPath.row == 0 && self.assignment.returnTime == nil) {
        [self beginReturn];
    }
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *initials = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserInitials"];
        self.assignment.returnTime = [NSDate date];
        self.assignment.returnBy = initials;
        
        iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app.datasource saveAssignment:self.assignment];
        
        [self.tableView reloadData];
    }
}

@end
