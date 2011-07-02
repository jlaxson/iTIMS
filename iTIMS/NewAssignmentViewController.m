//
//  NewAssignmentViewController.m
//  iTIMS
//
//  Created by John Laxson on 6/1/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "NewAssignmentViewController.h"

#import "ItemLocationViewController.h"
#import "ItemActivityViewController.h"
#import "AssignmentViewController.h"
#import "SignatureCaptureViewController.h"
#import "ItemPositionViewController.h"
#import "TextTableCell.h"

@implementation NewAssignmentViewController

@synthesize item, assignment;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
        self.assignment = [app.datasource createAssignment];
        self.assignment.location = @"DROHQ";
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
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAssignment)];
    button.enabled = NO;
    self.navigationItem.rightBarButtonItem = button;
    self.title = @"Assign";
    [button release];
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

- (void)validate
{
    BOOL valid = YES;
    valid = valid && [self.assignment.activity length] > 0;
    valid = valid && [self.assignment.position length] > 0;
    valid = valid && [self.assignment.location length] > 0;
    valid = valid && [self.assignment.name length] > 0;
    
    self.navigationItem.rightBarButtonItem.enabled = valid;
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
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 4;
        case 2:
            return 1;
    }
    return 0;
}

- (UITableViewCell *)cellForIdentifier:(NSString *)ident
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        if ([ident isEqualToString:@"TitleCell"]) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if ([ident isEqualToString:@"EditableCell"]) {
            TextTableCell *tcell = [[[TextTableCell alloc] initWithReuseIdentifier:ident] autorelease];
            tcell.textField.placeholder = @"Last, First";
#if TARGET_IPHONE_SIMULATOR
            tcell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
#endif
            tcell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            tcell.textField.delegate = self;
            cell = tcell;
            
        } else if ([ident isEqualToString:@"ValueCell"]) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [self cellForIdentifier:@"TitleCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = item.referenceNumber;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = item.desc;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // editable name field
            cell = [self cellForIdentifier:@"EditableCell"];
        } else if (indexPath.row == 1) {
            cell = [self cellForIdentifier:@"ValueCell"];
            cell.textLabel.text = @"Activity";
            cell.detailTextLabel.text = self.assignment.activity;
        } else if (indexPath.row == 2) {
            cell = [self cellForIdentifier:@"ValueCell"];
            cell.textLabel.text = @"Position";
            cell.detailTextLabel.text = self.assignment.position;
        } else if (indexPath.row == 3) {
            cell = [self cellForIdentifier:@"ValueCell"];
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = self.assignment.location;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell = [self cellForIdentifier:@"ValueCell"];
            cell.textLabel.text = @"Capture Signature";
            cell.accessoryType = self.assignment.signatureImage ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Item";
        case 1:
            return @"Assignment";
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            ItemActivityViewController *vc = [[ItemActivityViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.completedAction = ^(ItemActivityViewController *pvc, Activity *act) {
                self.assignment.activity = act.code;
                [self validate];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        } else if (indexPath.row == 2) {
            ItemPositionViewController *vc = [[ItemPositionViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.completedAction = ^(ItemPositionViewController *pvc, Position *pos) {
                self.assignment.position = pos.code;
                [self.tableView reloadData];
                [self validate];
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        } else if (indexPath.row == 3) {
            ItemLocationViewController *vc = [[ItemLocationViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.completedAction = ^(ItemLocationViewController *lvc, Location *loc) {
                self.assignment.location = loc.code;
                [self validate];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    } else if (indexPath.section == 2) {
        SignatureCaptureViewController *vc = [[SignatureCaptureViewController alloc] initWithNibName:@"SignatureCaptureViewController" bundle:nil];
        vc.completionHandler = ^(SignatureCaptureViewController *vc, UIImage *image) {
            self.assignment.signatureImage = image;
            [self.tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)saveAssignment
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to issue the equipment?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Issue" otherButtonTitles:nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.assignment.item = self.item;
        self.assignment.checkoutTime = [NSDate date];
        self.assignment.checkoutBy = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserInitials"];
        
        TextTableCell *nameCell = (TextTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        self.assignment.name = nameCell.textField.text;
        
        [self.item addAssignmentsObject:self.assignment];
        
        iTIMSAppDelegate *app = [[UIApplication sharedApplication] delegate];
        
        @try {
            [app.datasource saveAssignment:self.assignment];
        }
        @catch (NSException *e) {
            [app handleConnectionError:e];
            
            [self.item removeAssignmentsObject:self.assignment];
            return;
        }
        
        //[self.navigationController popViewControllerAnimated:NO];
        
        UINavigationController *nc = self.navigationController;
        NSMutableArray *a = [NSMutableArray arrayWithArray:nc.viewControllers];
        [a removeLastObject];
        
        AssignmentViewController *avc = [[AssignmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
        avc.assignment = self.assignment;
        [a addObject:avc];
        [avc release];
        
        [nc setViewControllers:a animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.assignment.name = textField.text;
    [self validate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
