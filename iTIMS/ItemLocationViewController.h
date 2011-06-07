//
//  ItemLocationViewController.h
//  iTIMS
//
//  Created by John Laxson on 5/25/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocationViewController;

@interface ItemLocationViewController : UITableViewController {
    NSArray *locations;
}

@property (copy) void (^completedAction)(ItemLocationViewController *vc, Location *location);

@end
